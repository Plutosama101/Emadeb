page 52131 "E-Pump Branches"
{
    Caption = 'E-Pump Branches';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Branch";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Branch Id"; Rec."Branch Id") { }
                field("Name"; Rec."Name") { }
                field("Company Id"; Rec."Company Id") { }
                field("Company Name"; Rec."Company Name") { }
                field("Phone"; Rec."Phone") { }
                field("Email"; Rec."Email") { }
                field("Street"; Rec."Street") { }
                field("City"; Rec."City") { }
                field("LGA"; Rec."LGA") { }
                field("State"; Rec."State") { }
                field("Country"; Rec."Country") { }
                field("Full Address"; Rec."Full Address") { }
                field("Group Id"; Rec."Group Id") { }
                field("Group Name"; Rec."Group Name") { }
                field("Region Id"; Rec."Region Id") { }
                field("Region Name"; Rec."Region Name") { }
                field("Branch Status"; Rec."Branch Status") { }
                field("Type"; Rec."Type") { }
                field("Latitude"; Rec."Latitude") { }
                field("Longitude"; Rec."Longitude") { }
                field("Date"; Rec."Date") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchMyBranches)
            {
                Caption = 'Fetch My Branches';
                Image = Refresh;

                trigger OnAction()
                var
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    Message('%1 rows fetched.', Fetch.MyBranches());
                end;
            }
            action(FetchCompanyBranches)
            {
                Caption = 'Fetch Company Branches';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.CompanyBranches(Options.CompanyId(), Options.State()));
                end;
            }
            action(FetchComprehensiveBranches)
            {
                Caption = 'Fetch Comprehensive Branches';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.ComprehensiveBranches(Options.CompanyId()));
                end;
            }
        }
    }
}
