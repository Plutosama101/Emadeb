table 52115 "E-Pump Tank Sale"
{
    Caption = 'E-Pump Tank Sale';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Tank Sales";
    DrillDownPageId = "E-Pump Tank Sales";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Date"; DateTime) { }
        field(3; "Branch Id"; Text[50]) { }
        field(4; "Branch Name"; Text[250]) { }
        field(5; "Tank Id"; Text[50]) { }
        field(6; "Tank Name"; Text[250]) { }
        field(7; "Product Name"; Text[250]) { }
        field(8; "Opening Dip"; Decimal) { }
        field(9; "Closing Dip"; Decimal) { }
        field(10; "Volume Filled"; Decimal) { }
        field(11; "Volume Sold"; Decimal) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
