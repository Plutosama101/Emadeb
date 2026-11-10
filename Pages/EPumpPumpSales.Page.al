page 52132 "E-Pump Pump Sales"
{
    Caption = 'E-Pump Pump Sales';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Pump Sale";
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
                field("Branch Name"; Rec."Branch Name") { }
                field("Pump Id"; Rec."Pump Id") { }
                field("Pump Name"; Rec."Pump Name") { }
                field("Product Name"; Rec."Product Name") { }
                field("Opening Reading"; Rec."Opening Reading") { }
                field("Last Reading"; Rec."Last Reading") { }
                field("Volume Sold"; Rec."Volume Sold") { }
                field("Price"; Rec."Price") { }
                field("Amount Sold"; Rec."Amount Sold") { }
                field("RTT"; Rec."RTT") { }
                field("Dealer Name"; Rec."Dealer Name") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchBranchSales)
            {
                Caption = 'Sales for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.BranchSales(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchBranchSalesV2)
            {
                Caption = 'Sales for a Branch (v2)';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.BranchSalesV2(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchDaySale)
            {
                Caption = 'Day Sales for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.DaySale(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchCompanySales)
            {
                Caption = 'Sales for a Company';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.CompanySales(Options.CompanyId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchCompanySalesSummary)
            {
                Caption = 'Sales Summary for a Company';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.CompanySalesSummary(Options.CompanyId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchCompanyBranchSales)
            {
                Caption = 'Company Branch Sales';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.CompanyBranchSales(Options.CompanyId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchPriceChanges)
            {
                Caption = 'Price Changes';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.PriceChanges(Options.CompanyId(), Options.OptionalBranchId(), Options.State(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchProductPrices)
            {
                Caption = 'Product Prices';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.ProductPrices(Options.CompanyId(), Options.OptionalBranchId(), Options.State()));
                end;
            }
        }
    }
}
