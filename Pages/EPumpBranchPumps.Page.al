page 52144 "E-Pump Branch Pumps"
{
    Caption = 'E-Pump Branch Pumps';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Branch Pump";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Name"; Rec."Name") { Editable = false; }
                field("Branch Name"; Rec."Branch Name") { }
                field("Product Name"; Rec."Product Name") { Editable = false; }
                // The only field you fill in. Fetching again never changes it.
                field("Item No."; Rec."Item No.") { }
                field("Item Description"; Rec."Item Description") { }
                field("Tank Name"; Rec."Tank Name") { Editable = false; }
                field("Status"; Rec."Status") { Editable = false; }
                field("Selling Price"; Rec."Selling Price") { Editable = false; }
                field("Opening Reading"; Rec."Opening Reading") { Editable = false; }
                field("Current Reading"; Rec."Current Reading") { Editable = false; }
                field("Manual Opening Reading"; Rec."Manual Opening Reading") { Editable = false; }
                field("Manual Closing Reading"; Rec."Manual Closing Reading") { Editable = false; }
                field("Manufacturer"; Rec."Manufacturer") { Editable = false; }
                field("Model"; Rec."Model") { Editable = false; }
                field("Pump Address"; Rec."Pump Address") { Editable = false; }
                field("Device Id"; Rec."Device Id") { Editable = false; }
                field("Last Update"; Rec."Last Update") { Editable = false; }
                field("Date Created"; Rec."Date Created") { Editable = false; }
                field("Pump Id"; Rec."Pump Id") { Editable = false; }
                field("Branch Id"; Rec."Branch Id") { Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchBranchPumps)
            {
                Caption = 'Fetch Pumps for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.BranchPumps(Options.BranchId()));
                end;
            }
            action(FetchAllBranchPumps)
            {
                Caption = 'Fetch Pumps for All Branches';
                Image = Refresh;

                trigger OnAction()
                var
                    Branch: Record "E-Pump Branch";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Branch.IsEmpty() then
                        Error('There are no branches yet. Fetch branches on the E-Pump Branches page first.');
                    Message('%1 rows fetched.', Fetch.AllBranchPumps());
                end;
            }
            action(ProductMappings)
            {
                Caption = 'Product Mappings';
                Image = ItemCrossReference;
                RunObject = page "E-Pump Product Mappings";
            }
        }
    }
}
