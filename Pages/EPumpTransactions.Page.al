page 52133 "E-Pump Transactions"
{
    Caption = 'E-Pump Transactions';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Transaction";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Transaction Id"; Rec."Transaction Id") { }
                field("Date"; Rec."Date") { }
                field("Branch Id"; Rec."Branch Id") { }
                field("Branch Name"; Rec."Branch Name") { }
                field("Pump Id"; Rec."Pump Id") { }
                field("Pump Name"; Rec."Pump Name") { }
                field("Product Name"; Rec."Product Name") { }
                field("Opening Read"; Rec."Opening Read") { }
                field("Closing Read"; Rec."Closing Read") { }
                field("Vol Sold"; Rec."Vol Sold") { }
                field("Price"; Rec."Price") { }
                field("Amount"; Rec."Amount") { }
                field("RTT"; Rec."RTT") { }
                field("Staff Name"; Rec."Staff Name") { }
                field("Sales Type"; Rec."Sales Type") { }
                field("Voucher Card Number"; Rec."Voucher Card Number") { }
                field("Transaction Time"; Rec."Transaction Time") { }
                field("Invoice Created"; Rec."Invoice Created") { }
                field("Sales Document No."; Rec."Sales Document No.") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConvertSelected)
            {
                Caption = 'Convert Selected to Sales Document';
                Image = MakeOrder;
                ToolTip = 'Converts the row(s) you selected. Select one row, or several with Ctrl/Shift. Same pump + same day = one summed line.';

                trigger OnAction()
                var
                    Rows: Record "E-Pump Transaction";
                    Convert: Codeunit "E-Pump Sales Convert";
                begin
                    CurrPage.SetSelectionFilter(Rows); // only the selected rows
                    if not Confirm('Convert the %1 selected row(s) into sales documents?', true, Rows.Count()) then
                        exit;
                    Convert.ConvertTransactions(Rows);
                    CurrPage.Update(false); // show the new "Invoice Created" ticks
                end;
            }
            action(ConvertAllShown)
            {
                Caption = 'Convert All Shown to Sales Document';
                Image = MakeOrder;
                ToolTip = 'Converts every row the page shows (use filters first). One branch on one day = one document. Same pump + same day = one summed line. Rows already converted are skipped.';

                trigger OnAction()
                var
                    Rows: Record "E-Pump Transaction";
                    Convert: Codeunit "E-Pump Sales Convert";
                begin
                    Rows.CopyFilters(Rec); // the same rows you see on the page
                    if not Confirm('Convert all %1 row(s) shown into sales documents?', true, Rows.Count()) then
                        exit;
                    Convert.ConvertTransactions(Rows);
                    CurrPage.Update(false); // show the new "Invoice Created" ticks
                end;
            }
            action(FetchBranchTransactions)
            {
                Caption = 'Transactions for a Branch';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.BranchTransactions(Options.BranchId(), Options.StartDate(), Options.EndDate()));
                end;
            }
            action(FetchCompanyTransactions)
            {
                Caption = 'Transactions for a Company';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.CompanyTransactions(Options.CompanyId(), Options.StartDate()));
                end;
            }
        }
    }
}
