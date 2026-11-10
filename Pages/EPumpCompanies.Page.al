page 52130 "E-Pump Companies"
{
    Caption = 'E-Pump Companies';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Company";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Company Id"; Rec."Company Id") { }
                field("Name"; Rec."Name") { }
                field("Email"; Rec."Email") { }
                field("Phone"; Rec."Phone") { }
                field("City"; Rec."City") { }
                field("State"; Rec."State") { }
                field("Country"; Rec."Country") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("Number of Branches"; Rec."Number of Branches") { }
                field("Number of Dealers"; Rec."Number of Dealers") { }
                field("Status"; Rec."Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchMyCompanies)
            {
                Caption = 'Fetch My Companies';
                Image = Refresh;

                trigger OnAction()
                var
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    Message('%1 rows fetched.', Fetch.MyCompanies());
                end;
            }
        }
    }
}
