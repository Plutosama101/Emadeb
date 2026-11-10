table 52120 "E-Pump Day Summary"
{
    Caption = 'E-Pump Day Summary';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Day Summary";
    DrillDownPageId = "E-Pump Day Summary";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Branch Id"; Text[50]) { }
        field(3; "Date"; Date) { }
        field(4; "Report"; Text[250]) { }
        field(5; "Line"; Text[250]) { }
        field(6; "Amount"; Decimal) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
