table 52117 "E-Pump Manual Pump Record"
{
    Caption = 'E-Pump Manual Pump Record';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Manual Pump Records";
    DrillDownPageId = "E-Pump Manual Pump Records";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Date"; DateTime) { }
        field(3; "Branch Id"; Text[50]) { }
        field(4; "Pump Id"; Text[50]) { }
        field(5; "Pump Name"; Text[250]) { }
        field(6; "Staff Id"; Text[50]) { }
        field(7; "Staff Name"; Text[250]) { }
        field(8; "Outer Opening Read"; Decimal) { }
        field(9; "Outer Closing Read"; Decimal) { }
        field(10; "Opening Read"; Decimal) { }
        field(11; "Closing Read"; Decimal) { }
        field(12; "Max Reading"; Decimal) { }
        field(13; "Total Sale"; Decimal) { }
        field(14; "RTT"; Decimal) { }
        field(15; "Transfer"; Decimal) { }
        field(16; "Status"; Text[250]) { }
        field(17; "Rejected"; Boolean) { }
        field(18; "Date Rejected"; DateTime) { }
        field(19; "Image Url"; Text[2048]) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
