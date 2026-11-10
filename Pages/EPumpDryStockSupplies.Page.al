page 52142 "E-Pump Dry Stock Supplies"
{
    Caption = 'E-Pump Dry Stock Supplies';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Dry Stock Supply";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Item Id"; Rec."Item Id") { }
                field("Supply Id"; Rec."Supply Id") { }
                field("Date"; Rec."Date") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Retail Outlet"; Rec."Retail Outlet") { }
                field("Supply Status"; Rec."Supply Status") { }
                field("Recorded By"; Rec."Recorded By") { }
                field("Product Name"; Rec."Product Name") { }
                field("Variation Name"; Rec."Variation Name") { }
                field("Size"; Rec."Size") { }
                field("Price Per Unit"; Rec."Price Per Unit") { }
                field("Quantity Per Unit"; Rec."Quantity Per Unit") { }
                field("Quantity Supplied"; Rec."Quantity Supplied") { }
                field("Quantity Accepted"; Rec."Quantity Accepted") { }
                field("Total Rejected"; Rec."Total Rejected") { }
                field("Item Status"; Rec."Item Status") { }
                field("Is Processed"; Rec."Is Processed") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchDryStockSupplies)
            {
                Caption = 'Dry Stock Supplies for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.DryStockSupplies(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
        }
    }
}
