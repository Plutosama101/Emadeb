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
            action(ConvertToSalesDocument)
            {
                Caption = 'Convert to Sales Document';
                Image = MakeOrder;
                ToolTip = 'Turns the rows shown (use filters first) into sales invoices or orders. One branch on one day = one document. Rows already converted are skipped.';

                trigger OnAction()
                var
                    Rows: Record "E-Pump Transaction";
                    Convert: Codeunit "E-Pump Sales Convert";
                begin
                    if not Confirm('Convert the rows shown into sales documents?') then
                        exit;
                    Rows.CopyFilters(Rec); // the same rows you see on the page
                    Convert.ConvertTransactions(Rows);
                    CurrPage.Update(false);
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
