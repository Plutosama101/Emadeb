table 52121 "E-Pump Dry Stock Product"
{
    Caption = 'E-Pump Dry Stock Product';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Dry Stock Products";
    DrillDownPageId = "E-Pump Dry Stock Products";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Branch Id"; Text[50]) { }
        field(3; "Product Id"; Text[50]) { }
        field(4; "Product Name"; Text[250]) { }
        field(5; "Category"; Text[250]) { }
        field(6; "Description"; Text[2048]) { }
        field(7; "Variation Id"; Text[50]) { }
        field(8; "Variation Name"; Text[250]) { }
        field(9; "Size"; Decimal) { }
        field(10; "Size Detail"; Text[250]) { }
        field(11; "Price Per Unit"; Decimal) { }
        field(12; "Quantity Per Unit"; Integer) { }
        field(13; "Total Items"; Integer) { }
        field(14; "Is Company Product"; Boolean) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
