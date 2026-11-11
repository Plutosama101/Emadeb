tableextension 52100 "E-Pump Location" extends Location
{
    fields
    {
        // The customer the E-Pump sales of this location are sold to
        field(52100; "E-Pump Customer No."; Code[20])
        {
            Caption = 'E-Pump Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
    }
}
