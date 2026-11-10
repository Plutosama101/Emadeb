table 52110 "E-Pump Company"
{
    Caption = 'E-Pump Company';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Companies";
    DrillDownPageId = "E-Pump Companies";

    fields
    {
        field(1; "Company Id"; Text[50]) { }
        field(2; "Name"; Text[250]) { }
        field(3; "Email"; Text[250]) { }
        field(4; "Phone"; Text[250]) { }
        field(5; "City"; Text[250]) { }
        field(6; "State"; Text[250]) { }
        field(7; "Country"; Text[250]) { }
        field(8; "Currency Code"; Text[50]) { }
        field(9; "Number of Branches"; Integer) { }
        field(10; "Number of Dealers"; Integer) { }
        field(11; "Status"; Text[250]) { }
    }

    keys
    {
        key(PK; "Company Id") { Clustered = true; }
    }
}
