table 52113 "E-Pump Transaction"
{
    Caption = 'E-Pump Transaction';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Transactions";
    DrillDownPageId = "E-Pump Transactions";

    fields
    {
        field(1; "Transaction Id"; Text[50]) { }
        field(2; "Date"; DateTime) { }
        field(3; "Branch Id"; Text[50]) { }
        field(4; "Branch Name"; Text[250]) { }
        field(5; "Pump Id"; Text[50]) { }
        field(6; "Pump Name"; Text[250]) { }
        field(7; "Product Name"; Text[250]) { }
        field(8; "Opening Read"; Decimal) { }
        field(9; "Closing Read"; Decimal) { }
        field(10; "Vol Sold"; Decimal) { }
        field(11; "Price"; Decimal) { }
        field(12; "Amount"; Decimal) { }
        field(13; "RTT"; Decimal) { }
        field(14; "Staff Name"; Text[250]) { }
        field(15; "Sales Type"; Text[250]) { }
        field(16; "Voucher Card Number"; Text[250]) { }
        field(17; "Transaction Time"; Integer) { }
    }

    keys
    {
        key(PK; "Transaction Id") { Clustered = true; }
    }
}
