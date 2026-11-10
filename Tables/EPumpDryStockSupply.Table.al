table 52122 "E-Pump Dry Stock Supply"
{
    Caption = 'E-Pump Dry Stock Supply';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Dry Stock Supplies";
    DrillDownPageId = "E-Pump Dry Stock Supplies";

    fields
    {
        field(1; "Item Id"; Text[50]) { }
        field(2; "Supply Id"; Text[50]) { }
        field(3; "Date"; DateTime) { }
        field(4; "Branch Id"; Text[50]) { }
        field(5; "Retail Outlet"; Text[250]) { }
        field(6; "Supply Status"; Text[250]) { }
        field(7; "Recorded By"; Text[250]) { }
        field(8; "Product Name"; Text[250]) { }
        field(9; "Variation Name"; Text[250]) { }
        field(10; "Size"; Decimal) { }
        field(11; "Price Per Unit"; Decimal) { }
        field(12; "Quantity Per Unit"; Decimal) { }
        field(13; "Quantity Supplied"; Decimal) { }
        field(14; "Quantity Accepted"; Decimal) { }
        field(15; "Total Rejected"; Integer) { }
        field(16; "Item Status"; Text[250]) { }
        field(17; "Is Processed"; Boolean) { }
    }

    keys
    {
        key(PK; "Item Id") { Clustered = true; }
    }
}
