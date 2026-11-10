page 52135 "E-Pump Tank Sales"
{
    Caption = 'E-Pump Tank Product Sales';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Tank Sale";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Date"; Rec."Date") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Branch Name"; Rec."Branch Name") { }
                field("Tank Id"; Rec."Tank Id") { }
                field("Tank Name"; Rec."Tank Name") { }
                field("Product Name"; Rec."Product Name") { }
                field("Opening Dip"; Rec."Opening Dip") { }
                field("Closing Dip"; Rec."Closing Dip") { }
                field("Volume Filled"; Rec."Volume Filled") { }
                field("Volume Sold"; Rec."Volume Sold") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchTankSales)
            {
                Caption = 'Tank Product Sales for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.TankSales(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
        }
    }
}
