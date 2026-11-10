page 52134 "E-Pump Tank Fills"
{
    Caption = 'E-Pump Tank Fills';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Tank Fill";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Source"; Rec."Source") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Branch Name"; Rec."Branch Name") { }
                field("Tank"; Rec."Tank") { }
                field("Product Name"; Rec."Product Name") { }
                field("Start Time"; Rec."Start Time") { }
                field("Start Volume"; Rec."Start Volume") { }
                field("End Time"; Rec."End Time") { }
                field("End Volume"; Rec."End Volume") { }
                field("Filled Volume"; Rec."Filled Volume") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchBranchTankFills)
            {
                Caption = 'Tank Fills for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.BranchTankFills(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchProductDischarge)
            {
                Caption = 'Product Discharge for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.ProductDischarge(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchCompanyTankFills)
            {
                Caption = 'Tank Fills for a Company';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.CompanyTankFills(Options.CompanyId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchCompanyTanksFilled)
            {
                Caption = 'Tanks Filled for a Company (one day)';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.CompanyTanksFilled(Options.CompanyId(), Options.StartDate()));
                end;
            }
        }
    }
}
