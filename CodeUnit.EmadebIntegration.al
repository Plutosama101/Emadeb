codeunit 50300 "E-Pump Mgt"
{
    procedure EPumpLogin(): Boolean
    var
        EPumpSetup: Record "E-Pump Setup";
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        JsonToken: JsonToken;
        RequestBody: Text;
        ResponseBody: Text;
        URL: Text;
    begin
        if not EPumpSetup.Get() then
            exit(false);
        if not EPumpSetup."Use E-Pump Integration" then
            exit(false);

        EPumpSetup.TestField("Base URL");
        EPumpSetup.TestField("Login URL");
        EPumpSetup.TestField("User Name");
        EPumpSetup.TestField(Password);

        URL := EPumpSetup."Base URL".TrimEnd('/') + '/' + EPumpSetup."Login URL".TrimStart('/');

        // Build the request body
        RequestJson.Add('userName', EPumpSetup."User Name");
        RequestJson.Add('password', EPumpSetup.Password);
        RequestJson.WriteTo(RequestBody);

        RequestContent.WriteFrom(RequestBody);
        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        // Send it
        if not Client.Post(URL, RequestContent, Response) then
            Error('Could not reach the E-Pump server.');

        Response.Content().ReadAs(ResponseBody);

        if not Response.IsSuccessStatusCode() then
            Error('E-Pump login failed (%1): %2', Response.HttpStatusCode(), ResponseBody);

        // Read the answer
        if not ResponseJson.ReadFrom(ResponseBody) then
            Error('E-Pump sent an answer that is not valid JSON.');

        if not ResponseJson.Get('token', JsonToken) then
            Error('E-Pump answer has no token.');
        EPumpSetup.Token := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(EPumpSetup.Token));

        if ResponseJson.Get('refreshToken', JsonToken) then
            EPumpSetup."Refresh Token" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(EPumpSetup."Refresh Token"));

        EPumpSetup."Last Login" := CurrentDateTime();
        // Token lasts 6 days, so we say 5 to be safe
        EPumpSetup."Token Expiry" := CurrentDateTime() + (5 * 24 * 60 * 60 * 1000);
        EPumpSetup.Modify();

        exit(true);
    end;

    // Call this before any other E-Pump request. It logs in again only when needed.
    procedure EnsureValidToken()
    var
        EPumpSetup: Record "E-Pump Setup";
    begin
        EPumpSetup.Get();
        if (EPumpSetup.Token = '') or (EPumpSetup."Token Expiry" < CurrentDateTime()) then
            EPumpLogin();
    end;
}