// Connects an E-Pump product name (like PMS or AGO) to a Business Central item.
table 52125 "E-Pump Product Mapping"
{
    Caption = 'E-Pump Product Mapping';
    DataClassification = CustomerContent;
    LookupPageId = "E-Pump Product Mappings";
    DrillDownPageId = "E-Pump Product Mappings";

    fields
    {
        field(1; "Product Name"; Text[250]) { }
        field(2; "Item No."; Code[20]) { TableRelation = Item; }
        field(3; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Product Name") { Clustered = true; }
    }

    // Gives the item for a product name, or '' if there is no mapping yet.
    procedure ItemFor(ProductName: Text): Code[20]
    var
        Mapping: Record "E-Pump Product Mapping";
    begin
        if Mapping.Get(ProductName) then
            exit(Mapping."Item No.");
        exit('');
    end;
}
