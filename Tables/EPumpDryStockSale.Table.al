table 52123 "E-Pump Dry Stock Sale"
{
    Caption = 'E-Pump Dry Stock Sale';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Dry Stock Sales";
    DrillDownPageId = "E-Pump Dry Stock Sales";

    fields
    {
        field(1; "Sale Id"; Text[50]) { }
        field(2; "Date"; DateTime) { }
        field(3; "Branch Id"; Text[50]) { }
        field(4; "Retail Outlet"; Text[250]) { }
        field(5; "Products"; Text[2048]) { }
        field(6; "Customer Name"; Text[250]) { }
        field(7; "Quantity Sold"; Decimal) { }
        field(8; "Discount Price"; Decimal) { }
        field(9; "Total Amount"; Decimal) { }
        field(10; "Tax Rate"; Integer) { }
    }

    keys
    {
        key(PK; "Sale Id") { Clustered = true; }
    }
}
