table 52118 "E-Pump Tank Dip"
{
    Caption = 'E-Pump Tank Dip';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Tank Dips";
    DrillDownPageId = "E-Pump Tank Dips";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Date"; DateTime) { }
        field(3; "Branch Id"; Text[50]) { }
        field(4; "Tank Id"; Text[50]) { }
        field(5; "Tank Name"; Text[250]) { }
        field(6; "Opening Dip"; Decimal) { }
        field(7; "Closing Dip"; Decimal) { }
        field(8; "Height"; Decimal) { }
        field(9; "Filled Volume"; Decimal) { }
        field(10; "Actual Volume"; Decimal) { }
        field(11; "Calculated Volume"; Decimal) { }
        field(12; "Difference"; Decimal) { }
        field(13; "Remarks"; Text[250]) { }
        field(14; "Recorded By"; Text[250]) { }
        field(15; "Recorded On"; DateTime) { }
        field(16; "Rejected"; Boolean) { }
        field(17; "Date Rejected"; DateTime) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
