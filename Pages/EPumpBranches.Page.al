page 52131 "E-Pump Branches"
{
    Caption = 'E-Pump Branches';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Branch";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Branch Id"; Rec."Branch Id") { Editable = false; }
                field("Name"; Rec."Name") { Editable = false; }
                // The only field you fill in: the BC location for this branch
                field("Location Code"; Rec."Location Code") { }
                field("Company Id"; Rec."Company Id") { Editable = false; }
                field("Company Name"; Rec."Company Name") { Editable = false; }
                field("Phone"; Rec."Phone") { Editable = false; }
                field("Email"; Rec."Email") { Editable = false; }
                field("Street"; Rec."Street") { Editable = false; }
                field("City"; Rec."City") { Editable = false; }
                field("LGA"; Rec."LGA") { Editable = false; }
                field("State"; Rec."State") { Editable = false; }
                field("Country"; Rec."Country") { Editable = false; }
                field("Full Address"; Rec."Full Address") { Editable = false; }
                field("Group Id"; Rec."Group Id") { Editable = false; }
                field("Group Name"; Rec."Group Name") { Editable = false; }
                field("Region Id"; Rec."Region Id") { Editable = false; }
                field("Region Name"; Rec."Region Name") { Editable = false; }
                field("Branch Status"; Rec."Branch Status") { Editable = false; }
                field("Type"; Rec."Type") { Editable = false; }
                field("Latitude"; Rec."Latitude") { Editable = false; }
                field("Longitude"; Rec."Longitude") { Editable = false; }
                field("Date"; Rec."Date") { Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Pumps)
            {
                Caption = 'Pumps';
                Image = Line;
                ToolTip = 'Shows the pumps of the selected branch.';
                RunObject = page "E-Pump Branch Pumps";
                RunPageLink = "Branch Id" = field("Branch Id");
            }
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
