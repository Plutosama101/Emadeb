table 52111 "E-Pump Branch"
{
    Caption = 'E-Pump Branch';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Branches";
    DrillDownPageId = "E-Pump Branches";

    fields
    {
        field(1; "Branch Id"; Text[50]) { }
        field(2; "Name"; Text[250]) { }
        field(3; "Company Id"; Text[50]) { }
        field(4; "Company Name"; Text[250]) { }
        field(5; "Phone"; Text[250]) { }
        field(6; "Email"; Text[250]) { }
        field(7; "Street"; Text[250]) { }
        field(8; "City"; Text[250]) { }
        field(9; "LGA"; Text[250]) { }
        field(10; "State"; Text[250]) { }
        field(11; "Country"; Text[250]) { }
        field(12; "Full Address"; Text[2048]) { }
        field(13; "Group Id"; Text[50]) { }
        field(14; "Group Name"; Text[250]) { }
        field(15; "Region Id"; Text[50]) { }
        field(16; "Region Name"; Text[250]) { }
        field(17; "Branch Status"; Text[250]) { }
        field(18; "Type"; Text[250]) { }
        field(19; "Latitude"; Decimal) { }
        field(20; "Longitude"; Decimal) { }
        field(21; "Date"; DateTime) { }

        // Set in Business Central, never by E-Pump. Used to find the customer when converting sales.
        field(50; "Location Code"; Code[10]) { TableRelation = Location; }
    }

    keys
    {
        key(PK; "Branch Id") { Clustered = true; }
    }
}
