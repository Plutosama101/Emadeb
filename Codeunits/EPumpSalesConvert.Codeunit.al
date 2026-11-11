// "Convert to Sales Document": turns E-Pump sales into Business Central sales invoices or orders.
//
//   - Only rows that are not converted yet are used.
//   - One branch on one day = one sales document, with one line per sale.
//   - Customer: Branch -> its Location Code -> the E-Pump Customer No. on that Location Card.
//   - Item:     the pump's Item No., or the Product Mapping when the pump has none.
//
// Step 1 checks every row first. If anything is missing it stops with a message
// and nothing is created. Step 2 creates the documents.
codeunit 52104 "E-Pump Sales Convert"
{
    // ---------- From the E-Pump Transactions page ----------

    procedure ConvertTransactions(var Trans: Record "E-Pump Transaction")
    var
        Done: Record "E-Pump Transaction";
        SalesHeader: Record "Sales Header";
        CreatedDocs: List of [Code[20]];
        LastBranch: Text;
        LastDay: Date;
    begin
        Trans.SetRange("Invoice Created", false);
        Trans.SetCurrentKey("Branch Id", "Date");
        if Trans.IsEmpty() then
            Error('There is nothing to convert. All rows shown are already converted.');

        // Step 1: check
        Trans.FindSet();
        repeat
            CustomerFor(Trans."Branch Id");
            ItemFor(Trans."Pump Id", Trans."Product Name");
        until Trans.Next() = 0;

        // Step 2: create
        Trans.FindSet();
        repeat
            if (Trans."Branch Id" <> LastBranch) or (DT2Date(Trans.Date) <> LastDay) then begin
                CreateHeader(SalesHeader, Trans."Branch Id", DT2Date(Trans.Date));
                CreatedDocs.Add(SalesHeader."No.");
                LastBranch := Trans."Branch Id";
                LastDay := DT2Date(Trans.Date);
            end;
            AddLine(SalesHeader, ItemFor(Trans."Pump Id", Trans."Product Name"), Trans."Vol Sold", Trans.Price,
                Trans."Pump Name" + ' ' + Format(Trans.Date));

            // Mark it through a copy: changing the filtered field on Trans itself would upset the loop
            Done := Trans;
            Done."Invoice Created" := true;
            Done."Sales Document No." := SalesHeader."No.";
            Done.Modify();
        until Trans.Next() = 0;

        Finish(CreatedDocs);
    end;

    // ---------- From the E-Pump Pump Sales page ----------

    procedure ConvertPumpSales(var Sale: Record "E-Pump Pump Sale")
    var
        Done: Record "E-Pump Pump Sale";
        SalesHeader: Record "Sales Header";
        CreatedDocs: List of [Code[20]];
        LastBranch: Text;
        LastDay: Date;
    begin
        Sale.SetRange("Invoice Created", false);
        Sale.SetCurrentKey("Branch Id", "Date");
        if Sale.IsEmpty() then
            Error('There is nothing to convert. All rows shown are already converted.');

        // Step 1: check
        Sale.FindSet();
        repeat
            CustomerFor(Sale."Branch Id");
            ItemFor(Sale."Pump Id", Sale."Product Name");
        until Sale.Next() = 0;

        // Step 2: create
        Sale.FindSet();
        repeat
            if (Sale."Branch Id" <> LastBranch) or (DT2Date(Sale.Date) <> LastDay) then begin
                CreateHeader(SalesHeader, Sale."Branch Id", DT2Date(Sale.Date));
                CreatedDocs.Add(SalesHeader."No.");
                LastBranch := Sale."Branch Id";
                LastDay := DT2Date(Sale.Date);
            end;
            AddLine(SalesHeader, ItemFor(Sale."Pump Id", Sale."Product Name"), Sale."Volume Sold", Sale.Price,
                Sale."Pump Name" + ' ' + Format(Sale.Date));

            // Mark it through a copy: changing the filtered field on Sale itself would upset the loop
            Done := Sale;
            Done."Invoice Created" := true;
            Done."Sales Document No." := SalesHeader."No.";
            Done.Modify();
        until Sale.Next() = 0;

        Finish(CreatedDocs);
    end;

    // ---------- Shared steps ----------

    // Branch -> Location Code -> Location's E-Pump Customer No.
    local procedure CustomerFor(BranchId: Text): Code[20]
    var
        Branch: Record "E-Pump Branch";
        Location: Record Location;
    begin
        if BranchId = '' then
            Error('Some rows have no Branch Id because E-Pump did not send one. Filter on an empty Branch Id to see them, then fetch them again with "Transactions for a Branch".');
        if not Branch.Get(BranchId) then
            Error('Branch %1 is not on the E-Pump Branches page. Fetch branches first.', BranchId);
        if Branch."Location Code" = '' then
            Error('Branch %1 has no Location Code. Fill it in on the E-Pump Branches page.', Branch.Name);
        Location.Get(Branch."Location Code");
        if Location."E-Pump Customer No." = '' then
            Error('Location %1 has no E-Pump Customer No. Fill it in on the Location Card.', Location.Code);
        exit(Location."E-Pump Customer No.");
    end;

    // The pump's Item No., or the Product Mapping when the pump has none
    local procedure ItemFor(PumpId: Text; ProductName: Text): Code[20]
    var
        Pump: Record "E-Pump Branch Pump";
        Mapping: Record "E-Pump Product Mapping";
    begin
        if Pump.Get(PumpId) then
            if Pump."Item No." <> '' then
                exit(Pump."Item No.");
        if Mapping.ItemFor(ProductName) <> '' then
            exit(Mapping.ItemFor(ProductName));
        Error('No item found for product %1 (pump %2). Set the Item No. on the pump, or add %1 on the E-Pump Product Mappings page.', ProductName, PumpId);
    end;

    local procedure CreateHeader(var SalesHeader: Record "Sales Header"; BranchId: Text; SaleDay: Date)
    var
        Branch: Record "E-Pump Branch";
        Setup: Record "E-Pump Setup Table";
    begin
        Setup.Get();
        Branch.Get(BranchId);

        SalesHeader.Init();
        if Setup."Create Sales As" = Setup."Create Sales As"::"Sales Order" then
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order
        else
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := '';
        SalesHeader.Insert(true); // true = take the next number from the number series

        SalesHeader.Validate("Sell-to Customer No.", CustomerFor(BranchId));
        SalesHeader.Validate("Posting Date", SaleDay);
        SalesHeader.Validate("Document Date", SaleDay);
        SalesHeader.Validate("Location Code", Branch."Location Code");
        SalesHeader."External Document No." := CopyStr('E-PUMP ' + Format(SaleDay, 0, 9), 1, MaxStrLen(SalesHeader."External Document No."));
        SalesHeader.Modify(true);
    end;

    local procedure AddLine(SalesHeader: Record "Sales Header"; ItemNo: Code[20]; Quantity: Decimal; UnitPrice: Decimal; Note: Text)
    var
        SalesLine: Record "Sales Line";
        LastLine: Record "Sales Line";
    begin
        LastLine.SetRange("Document Type", SalesHeader."Document Type");
        LastLine.SetRange("Document No.", SalesHeader."No.");
        if not LastLine.FindLast() then
            LastLine."Line No." := 0;

        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := LastLine."Line No." + 10000;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate("Location Code", SalesHeader."Location Code");
        SalesLine.Validate(Quantity, Quantity);
        SalesLine.Validate("Unit Price", UnitPrice);
        SalesLine."Description 2" := CopyStr(Note, 1, MaxStrLen(SalesLine."Description 2"));
        SalesLine.Modify(true);
    end;

    // Posts the documents if Auto-Post is on, then says what was done
    local procedure Finish(CreatedDocs: List of [Code[20]])
    var
        Setup: Record "E-Pump Setup Table";
        SalesHeader: Record "Sales Header";
        DocNo: Code[20];
    begin
        Setup.Get();
        if not Setup."Auto-Post" then begin
            Message('%1 sales document(s) created.', CreatedDocs.Count());
            exit;
        end;

        // Save the new documents before posting, so a posting error does not undo them
        Commit();
        foreach DocNo in CreatedDocs do begin
            SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order);
            SalesHeader.SetRange("No.", DocNo);
            SalesHeader.FindFirst();
            SalesHeader.Ship := true;
            SalesHeader.Invoice := true;
            Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
        end;
        Message('%1 sales document(s) created and posted.', CreatedDocs.Count());
    end;
}
