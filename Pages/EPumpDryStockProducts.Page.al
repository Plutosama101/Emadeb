page 52141 "E-Pump Dry Stock Products"
{
    Caption = 'E-Pump Dry Stock Products';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Dry Stock Product";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Branch Id"; Rec."Branch Id") { }
                field("Product Id"; Rec."Product Id") { }
                field("Product Name"; Rec."Product Name") { }
                field("Category"; Rec."Category") { }
                field("Description"; Rec."Description") { }
                field("Variation Id"; Rec."Variation Id") { }
                field("Variation Name"; Rec."Variation Name") { }
                field("Size"; Rec."Size") { }
                field("Size Detail"; Rec."Size Detail") { }
                field("Price Per Unit"; Rec."Price Per Unit") { }
                field("Quantity Per Unit"; Rec."Quantity Per Unit") { }
                field("Total Items"; Rec."Total Items") { }
                field("Is Company Product"; Rec."Is Company Product") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchDryStockProducts)
            {
                Caption = 'Dry Stock Products for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.DryStockProducts(Options.BranchId()));
                end;
            }
        }
    }
}
