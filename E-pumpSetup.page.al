page 52101 "E-Pump Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "E-Pump Setup Table";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'E-Pump Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Use E-Pump Integration"; Rec."Use E-Pump Integration") { ApplicationArea = All; }
                field("Base URL"; Rec."Base URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Example: https://integrations.epump.com.ng';
                }
                field("Login URL"; Rec."Login URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Example: /Account/login';
                }
            }
            group(Credentials)
            {
                field("User Name"; Rec."User Name") { ApplicationArea = All; }
                field(Password; Rec.Password) { ApplicationArea = All; }
            }
            group(TokenInfo)
            {
                Caption = 'Token';
                field("Token Expiry"; Rec."Token Expiry") { ApplicationArea = All; Editable = false; }
                field("Last Login"; Rec."Last Login") { ApplicationArea = All; Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestLogin)
            {
                Caption = 'Test Login';
                ApplicationArea = All;
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    EPumpMgt: Codeunit "E-Pump Mgt";
                begin
                    if EPumpMgt.EPumpLogin() then
                        Message('Login successful.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}