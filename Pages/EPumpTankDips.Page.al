page 52138 "E-Pump Tank Dips"
{
    Caption = 'E-Pump Manual Tank Records';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Tank Dip";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Date"; Rec."Date") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Tank Id"; Rec."Tank Id") { }
                field("Tank Name"; Rec."Tank Name") { }
                field("Opening Dip"; Rec."Opening Dip") { }
                field("Closing Dip"; Rec."Closing Dip") { }
                field("Height"; Rec."Height") { }
                field("Filled Volume"; Rec."Filled Volume") { }
                field("Actual Volume"; Rec."Actual Volume") { }
                field("Calculated Volume"; Rec."Calculated Volume") { }
                field("Difference"; Rec."Difference") { }
                field("Remarks"; Rec."Remarks") { }
                field("Recorded By"; Rec."Recorded By") { }
                field("Recorded On"; Rec."Recorded On") { }
                field("Rejected"; Rec."Rejected") { }
                field("Date Rejected"; Rec."Date Rejected") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchTankDips)
            {
                Caption = 'Manual Tank Records for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.TankDips(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
        }
    }
}
