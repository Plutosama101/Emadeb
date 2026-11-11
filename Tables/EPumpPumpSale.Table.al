table 52112 "E-Pump Pump Sale"
{
    Caption = 'E-Pump Pump Sale';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Pump Sales";
    DrillDownPageId = "E-Pump Pump Sales";

    fields
    {
        field(1; "Sale Id"; Text[50]) { }
        field(2; "Date"; DateTime) { }
        field(3; "Branch Id"; Text[50]) { }
        field(4; "Branch Name"; Text[250]) { }
        field(5; "Pump Id"; Text[50]) { }
        field(6; "Pump Name"; Text[250]) { }
        field(7; "Product Name"; Text[250]) { }
        field(8; "Opening Reading"; Decimal) { }
        field(9; "Last Reading"; Decimal) { }
        field(10; "Volume Sold"; Decimal) { }
        field(11; "Price"; Decimal) { }
        field(12; "Amount Sold"; Decimal) { }
        field(13; "RTT"; Decimal) { }
        field(14; "Dealer Name"; Text[250]) { }

        // Set by "Convert to Sales Document", never by E-Pump
        field(50; "Invoice Created"; Boolean) { Editable = false; }
        field(51; "Sales Document No."; Code[20]) { Editable = false; }
    }

    keys
    {
        key(PK; "Sale Id") { Clustered = true; }
        key(BranchDate; "Branch Id", "Date") { }
    }
}
