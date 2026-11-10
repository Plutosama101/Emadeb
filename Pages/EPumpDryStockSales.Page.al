page 52143 "E-Pump Dry Stock Sales"
{
    Caption = 'E-Pump Dry Stock Sales';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Dry Stock Sale";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Sale Id"; Rec."Sale Id") { }
                field("Date"; Rec."Date") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Retail Outlet"; Rec."Retail Outlet") { }
                field("Products"; Rec."Products") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Quantity Sold"; Rec."Quantity Sold") { }
                field("Discount Price"; Rec."Discount Price") { }
                field("Total Amount"; Rec."Total Amount") { }
                field("Tax Rate"; Rec."Tax Rate") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchDryStockSales)
            {
                Caption = 'Dry Stock Sales for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.DryStockSales(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
        }
    }
}
