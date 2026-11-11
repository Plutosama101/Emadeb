// Everything shared by all E-Pump calls lives here:
//   1. Login         - gets a token and saves it on the setup record
//   2. CallApi       - sends a GET to E-Pump (logs in first if the token is old)
//   3. GetArray      - CallApi + turn the answer into a list of rows
//   4. Small helpers - read one field from a JSON row without crashing on missing/null values
codeunit 52102 "E-Pump Mgt"
{
    procedure Login(var EPumpSetup: Record "E-Pump Setup Table")
    var
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        ResponseArray: JsonArray;
        Row: JsonToken;
        RequestBody: Text;
        ResponseBody: Text;
        URL: Text;
    begin
        URL := EPumpSetup."Base URL".TrimEnd('/') + '/' + EPumpSetup."Login URL".TrimStart('/');

        RequestJson.Add('userName', EPumpSetup."User Name");
        RequestJson.Add('password', EPumpSetup.Password);
        RequestJson.WriteTo(RequestBody);

        RequestContent.WriteFrom(RequestBody);
        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        if not Client.Post(URL, RequestContent, Response) then
            Error('Could not reach the E-Pump server at %1.', URL);

        Response.Content().ReadAs(ResponseBody);
        if not Response.IsSuccessStatusCode() then
            Error('E-Pump login failed (%1) calling %2: %3', Response.HttpStatusCode(), URL, ResponseBody);

        // E-Pump sends back { "token": ... }. Swagger says it can be a list [ { "token": ... } ], so we accept both.
        Row.ReadFrom(ResponseBody);
        if Row.IsArray() then begin
            ResponseArray := Row.AsArray();
            ResponseArray.Get(0, Row);
        end;
        ResponseJson := Row.AsObject();

        EPumpSetup.Token := GetText(ResponseJson, 'token');
        EPumpSetup."Refresh Token" := GetText(ResponseJson, 'refreshToken');
        EPumpSetup."Last Login" := CurrentDateTime();
        // The token lasts 6 days, so we say 5 to be safe
        EPumpSetup."Token Expiry" := CurrentDateTime() + (5 * 24 * 60 * 60 * 1000);
        EPumpSetup.Modify();
    end;

    // Sends a GET request, for example CallApi('/Branch/Sales/<id>?startDate=...').
    // Returns the raw text E-Pump sent back.
    procedure CallApi(Path: Text): Text
    var
        EPumpSetup: Record "E-Pump Setup Table";
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseBody: Text;
        URL: Text;
    begin
        EPumpSetup.Get();
        if (EPumpSetup.Token = '') or (EPumpSetup."Token Expiry" < CurrentDateTime()) then
            Login(EPumpSetup);

        URL := EPumpSetup."Base URL".TrimEnd('/') + Path;
        Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + EPumpSetup.Token);
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        if not Client.Get(URL, Response) then
            Error('Could not reach the E-Pump server at %1.', URL);

        Response.Content().ReadAs(ResponseBody);
        if not Response.IsSuccessStatusCode() then
            Error('E-Pump returned an error (%1) for %2: %3', Response.HttpStatusCode(), Path, ResponseBody);

        exit(ResponseBody);
    end;

    // Most E-Pump endpoints send back a list: [ {...}, {...} ].
    // When there is nothing to send, some send { "message": "No ... yet" } instead,
    // so we show that message and return an empty list.
    procedure GetArray(Path: Text) Rows: JsonArray
    var
        Answer: JsonObject;
        ResponseBody: Text;
    begin
        ResponseBody := CallApi(Path);
        if Rows.ReadFrom(ResponseBody) then
            exit(Rows);

        if Answer.ReadFrom(ResponseBody) then
            if GetText(Answer, 'message') <> '' then
                Message('%1', GetText(Answer, 'message'));
    end;

    // Same as GetArray, for endpoints that send back one object: { ... }
    procedure GetObject(Path: Text) Answer: JsonObject
    begin
        Answer.ReadFrom(CallApi(Path));
    end;

    // Builds '?startDate=2026-11-01&endDate=2026-11-10'
    procedure DateRange(StartDate: Date; EndDate: Date): Text
    begin
        exit('?startDate=' + Format(StartDate, 0, 9) + '&endDate=' + Format(EndDate, 0, 9));
    end;

    // ---- Read one field from a JSON row. Missing or null fields give a blank / 0 value. ----

    procedure GetText(Row: JsonObject; FieldName: Text): Text
    var
        Value: JsonToken;
    begin
        if not FindValue(Row, FieldName, Value) then
            exit('');
        // E-Pump sends this "all zeros" id when there is no id, so treat it as blank
        if Value.AsValue().AsText() = '00000000-0000-0000-0000-000000000000' then
            exit('');
        exit(Value.AsValue().AsText());
    end;

    procedure GetDecimal(Row: JsonObject; FieldName: Text): Decimal
    var
        Value: JsonToken;
    begin
        if not FindValue(Row, FieldName, Value) then
            exit(0);
        exit(Value.AsValue().AsDecimal());
    end;

    procedure GetInteger(Row: JsonObject; FieldName: Text): Integer
    var
        Value: JsonToken;
    begin
        if not FindValue(Row, FieldName, Value) then
            exit(0);
        exit(Value.AsValue().AsInteger());
    end;

    procedure GetBoolean(Row: JsonObject; FieldName: Text): Boolean
    var
        Value: JsonToken;
    begin
        if not FindValue(Row, FieldName, Value) then
            exit(false);
        exit(Value.AsValue().AsBoolean());
    end;

    procedure GetDateTime(Row: JsonObject; FieldName: Text): DateTime
    var
        Value: JsonToken;
    begin
        if not FindValue(Row, FieldName, Value) then
            exit(0DT);
        // .NET sends '0001-01-01T00:00:00' for "no date"; BC cannot store dates that old
        if Value.AsValue().AsText().StartsWith('0001-') then
            exit(0DT);
        exit(Value.AsValue().AsDateTime());
    end;

    // For fields that hold a list of words, like "product": ["Water", "Oil"] -> 'Water, Oil'
    procedure GetTextList(Row: JsonObject; FieldName: Text) Result: Text
    var
        List: JsonToken;
        Item: JsonToken;
    begin
        if not Row.Get(FieldName, List) then
            exit('');
        if not List.IsArray() then
            exit('');
        foreach Item in List.AsArray() do begin
            if Result <> '' then
                Result += ', ';
            Result += Item.AsValue().AsText();
        end;
    end;

    local procedure FindValue(Row: JsonObject; FieldName: Text; var Value: JsonToken): Boolean
    begin
        if not Row.Get(FieldName, Value) then
            exit(false);
        if not Value.IsValue() then
            exit(false);
        exit(not Value.AsValue().IsNull());
    end;
}
