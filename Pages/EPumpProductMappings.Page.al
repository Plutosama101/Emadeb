// Fill this in once: "PMS = ITM0001, AGO = ITM0002".
// Pumps without an Item No. then get their item from here.
page 52145 "E-Pump Product Mappings"
{
    Caption = 'E-Pump Product Mappings';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Product Mapping";

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Product Name"; Rec."Product Name") { ToolTip = 'The product name exactly as E-Pump sends it, e.g. PMS.'; }
                field("Item No."; Rec."Item No.") { }
                field("Item Description"; Rec."Item Description") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AddFromPumps)
            {
                Caption = 'Add Product Names from Pumps';
                Image = Add;
                ToolTip = 'Adds every product name found on the E-Pump Branch Pumps page, so you only have to choose the items.';

                trigger OnAction()
                var
                    Pump: Record "E-Pump Branch Pump";
                    Mapping: Record "E-Pump Product Mapping";
                    Added: Integer;
                begin
                    if Pump.FindSet() then
                        repeat
                            if (Pump."Product Name" <> '') and not Mapping.Get(Pump."Product Name") then begin
                                Mapping.Init();
                                Mapping."Product Name" := Pump."Product Name";
                                Mapping.Insert();
                                Added += 1;
                            end;
                        until Pump.Next() = 0;
                    Message('%1 product name(s) added.', Added);
                end;
            }
            action(ApplyToPumps)
            {
                Caption = 'Apply to Pumps';
                Image = Apply;
                ToolTip = 'Fills in the Item No. on every pump that does not have one yet. Items you set by hand are never changed.';

                trigger OnAction()
                var
                    Pump: Record "E-Pump Branch Pump";
                    Mapping: Record "E-Pump Product Mapping";
                    Updated: Integer;
                begin
                    if Pump.FindSet(true) then
                        repeat
                            if (Pump."Item No." = '') and (Mapping.ItemFor(Pump."Product Name") <> '') then begin
                                Pump."Item No." := Mapping.ItemFor(Pump."Product Name");
                                Pump.Modify();
                                Updated += 1;
                            end;
                        until Pump.Next() = 0;
                    Message('%1 pump(s) updated.', Updated);
                end;
            }
        }
    }
}
