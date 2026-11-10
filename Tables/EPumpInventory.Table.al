table 52116 "E-Pump Inventory"
{
    Caption = 'E-Pump Inventory';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Inventory";
    DrillDownPageId = "E-Pump Inventory";

    fields
    {
        field(1; "Tank Id"; Text[50]) { }
        field(2; "Branch Id"; Text[50]) { }
        field(3; "Tank Name"; Text[250]) { }
        field(4; "Product"; Text[250]) { }
        field(5; "Current Volume"; Decimal) { }
        field(6; "Tank Capacity"; Decimal) { }
        field(7; "Last Filled Date"; DateTime) { }
        field(8; "Last Filled Volume"; Decimal) { }
        field(9; "Avg Dispensed Per Day"; Decimal) { }
    }

    keys
    {
        key(PK; "Tank Id") { Clustered = true; }
    }
}
