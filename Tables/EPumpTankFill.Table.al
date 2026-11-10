table 52114 "E-Pump Tank Fill"
{
    Caption = 'E-Pump Tank Fill';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Tank Fills";
    DrillDownPageId = "E-Pump Tank Fills";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Source"; Text[250]) { }
        field(3; "Branch Id"; Text[50]) { }
        field(4; "Branch Name"; Text[250]) { }
        field(5; "Tank"; Text[250]) { }
        field(6; "Product Name"; Text[250]) { }
        field(7; "Start Time"; DateTime) { }
        field(8; "Start Volume"; Decimal) { }
        field(9; "End Time"; DateTime) { }
        field(10; "End Volume"; Decimal) { }
        field(11; "Filled Volume"; Decimal) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
