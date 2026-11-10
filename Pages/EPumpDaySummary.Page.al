page 52140 "E-Pump Day Summary"
{
    Caption = 'E-Pump End of Day Summary';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Day Summary";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Branch Id"; Rec."Branch Id") { }
                field("Date"; Rec."Date") { }
                field("Report"; Rec."Report") { }
                field("Line"; Rec."Line") { }
                field("Amount"; Rec."Amount") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchEndOfDay)
            {
                Caption = 'End of Day for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.EndOfDay(Options.BranchId(), Options.StartDate()));
                end;
            }
        }
    }
}
