table 52124 "E-Pump Branch Pump"
{
    Caption = 'E-Pump Branch Pump';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Branch Pumps";
    DrillDownPageId = "E-Pump Branch Pumps";

    fields
    {
        field(1; "Pump Id"; Text[50]) { }
        field(2; "Name"; Text[250]) { }
        field(3; "Branch Id"; Text[50]) { TableRelation = "E-Pump Branch"; }
        field(4; "Branch Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("E-Pump Branch"."Name" where("Branch Id" = field("Branch Id")));
            Editable = false;
        }
        field(5; "Product Name"; Text[250]) { }
        field(6; "Tank Name"; Text[250]) { }
        field(7; "Status"; Text[250]) { }
        field(8; "Selling Price"; Decimal) { }
        field(9; "Opening Reading"; Decimal) { }
        field(10; "Current Reading"; Decimal) { }
        field(11; "Manual Opening Reading"; Decimal) { }
        field(12; "Manual Closing Reading"; Decimal) { }
        field(13; "Manufacturer"; Text[250]) { }
        field(14; "Model"; Text[250]) { }
        field(15; "Pump Address"; Integer) { }
        field(16; "Device Id"; Text[250]) { }
        field(17; "Last Update"; DateTime) { }
        field(18; "Date Created"; DateTime) { }

        // Set in Business Central, never by E-Pump. Fetching pumps again keeps it.
        field(50; "Item No."; Code[20]) { TableRelation = Item; }
        field(51; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Pump Id") { Clustered = true; }
        key(Branch; "Branch Id") { }
    }
}
