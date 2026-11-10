page 52136 "E-Pump Inventory"
{
    Caption = 'E-Pump Inventory Report';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Inventory";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Tank Id"; Rec."Tank Id") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Tank Name"; Rec."Tank Name") { }
                field("Product"; Rec."Product") { }
                field("Current Volume"; Rec."Current Volume") { }
                field("Tank Capacity"; Rec."Tank Capacity") { }
                field("Last Filled Date"; Rec."Last Filled Date") { }
                field("Last Filled Volume"; Rec."Last Filled Volume") { }
                field("Avg Dispensed Per Day"; Rec."Avg Dispensed Per Day") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchInventory)
            {
                Caption = 'Inventory for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.Inventory(Options.BranchId()));
                end;
            }
        }
    }
}
