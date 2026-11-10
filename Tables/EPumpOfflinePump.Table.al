table 52119 "E-Pump Offline Pump"
{
    Caption = 'E-Pump Offline Pump';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Offline Pumps";
    DrillDownPageId = "E-Pump Offline Pumps";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Source"; Text[250]) { }
        field(3; "Pump Id"; Text[50]) { }
        field(4; "Device Id"; Text[250]) { }
        field(5; "Device Type"; Text[250]) { }
        field(6; "Pumps"; Text[250]) { }
        field(7; "Company Name"; Text[250]) { }
        field(8; "Branch Name"; Text[250]) { }
        field(9; "Street"; Text[250]) { }
        field(10; "City"; Text[250]) { }
        field(11; "State"; Text[250]) { }
        field(12; "Region"; Text[250]) { }
        field(13; "Last Date"; DateTime) { }
        field(14; "Duration"; Text[250]) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
