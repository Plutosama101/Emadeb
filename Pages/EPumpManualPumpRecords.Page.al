page 52137 "E-Pump Manual Pump Records"
{
    Caption = 'E-Pump Manual Pump Records';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Manual Pump Record";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Date"; Rec."Date") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Pump Id"; Rec."Pump Id") { }
                field("Pump Name"; Rec."Pump Name") { }
                field("Staff Id"; Rec."Staff Id") { }
                field("Staff Name"; Rec."Staff Name") { }
                field("Outer Opening Read"; Rec."Outer Opening Read") { }
                field("Outer Closing Read"; Rec."Outer Closing Read") { }
                field("Opening Read"; Rec."Opening Read") { }
                field("Closing Read"; Rec."Closing Read") { }
                field("Max Reading"; Rec."Max Reading") { }
                field("Total Sale"; Rec."Total Sale") { }
                field("RTT"; Rec."RTT") { }
                field("Transfer"; Rec."Transfer") { }
                field("Status"; Rec."Status") { }
                field("Rejected"; Rec."Rejected") { }
                field("Date Rejected"; Rec."Date Rejected") { }
                field("Image Url"; Rec."Image Url") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchManualPumpRecords)
            {
                Caption = 'Manual Pump Records for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.ManualPumpRecords(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
        }
    }
}
