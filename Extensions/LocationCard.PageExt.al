pageextension 52100 "E-Pump Location Card" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("E-Pump Customer No."; Rec."E-Pump Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'The customer that E-Pump sales from this location are invoiced to.';
            }
        }
    }
}
