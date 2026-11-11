// "Convert to Sales Document": turns E-Pump sales into Business Central sales invoices or orders.
//
//   - Only rows that are not converted yet are used.
//   - One branch on one day = one sales document.
//   - Sales from the same pump at the same price on that day are added together into ONE line.
//     (If the price changed during the day, that pump gets one line per price.)
//   - Customer: Branch -> its Location Code -> the E-Pump Customer No. on that Location Card.
//   - Item:     the pump's Item No., or the Product Mapping when the pump has none.
//   - Every converted row gets "Invoice Created" ticked and the Sales Document No.
//
// Step 1 checks every row first. If anything is missing it stops with a message
// and nothing is created. Step 2 creates the documents.
//
// Both pages (Transactions and Pump Sales) copy their rows into the same temporary
// list ("Buffer"), so the converting is written only once, in ConvertBuffer.
codeunit 52104 "E-Pump Sales Convert"
{
    // ---------- From the E-Pump Transactions page ----------

    procedure ConvertTransactions(var Trans: Record "E-Pump Transaction")
    var
        Buffer: Record "E-Pump Transaction" temporary;
        Done: Record "E-Pump Transaction";
        DocNoFor: Dictionary of [Text, Code[20]];
        CreatedDocs: List of [Code[20]];
        RowId: Text;
    begin
        Trans.SetRange("Invoice Created", false);
        if Trans.IsEmpty() then
            Error('There is nothing to convert. The rows you chose are already converted.');

        Trans.FindSet();
        repeat
            Buffer := Trans;
            Buffer.Insert();
        until Trans.Next() = 0;

        ConvertBuffer(Buffer, DocNoFor, CreatedDocs);

        // Tick "Invoice Created" on every row that went into a document
        foreach RowId in DocNoFor.Keys() do begin
            Done.Get(RowId);
            Done."Invoice Created" := true;
            Done."Sales Document No." := DocNoFor.Get(RowId);
            Done.Modify();
        end;

        Finish(CreatedDocs, DocNoFor.Count());
    end;

    // ---------- From the E-Pump Pump Sales page ----------

    procedure ConvertPumpSales(var Sale: Record "E-Pump Pump Sale")
    var
        Buffer: Record "E-Pump Transaction" temporary;
        Done: Record "E-Pump Pump Sale";
        DocNoFor: Dictionary of [Text, Code[20]];
        CreatedDocs: List of [Code[20]];
        RowId: Text;
    begin
        Sale.SetRange("Invoice Created", false);
        if Sale.IsEmpty() then
            Error('There is nothing to convert. The rows you chose are already converted.');

        // Copy each pump sale into the same shape as a transaction
        Sale.FindSet();
        repeat
            Buffer.Init();
            Buffer."Transaction Id" := Sale."Sale Id";
            Buffer."Branch Id" := Sale."Branch Id";
            Buffer.Date := Sale.Date;
            Buffer."Pump Id" := Sale."Pump Id";
            Buffer."Pump Name" := Sale."Pump Name";
            Buffer."Product Name" := Sale."Product Name";
            Buffer."Vol Sold" := Sale."Volume Sold";
            Buffer.Price := Sale.Price;
            Buffer.Insert();
        until Sale.Next() = 0;

        ConvertBuffer(Buffer, DocNoFor, CreatedDocs);

        foreach RowId in DocNoFor.Keys() do begin
            Done.Get(RowId);
            Done."Invoice Created" := true;
            Done."Sales Document No." := DocNoFor.Get(RowId);
            Done.Modify();
        end;

        Finish(CreatedDocs, DocNoFor.Count());
    end;

    // ---------- The converting itself ----------

    // DocNoFor:    which sales document each row went into (row id -> document no.)
    // CreatedDocs: the new sales documents
    local procedure ConvertBuffer(var Buffer: Record "E-Pump Transaction" temporary; var DocNoFor: Dictionary of [Text, Code[20]]; var CreatedDocs: List of [Code[20]])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LineFor: Dictionary of [Text, Integer];
        LastBranch: Text;
        LastDay: Date;
        PumpAndPrice: Text;
        LineNo: Integer;
    begin
        // Step 1: check every row. Stops with a message before anything is created.
        Buffer.FindSet();
        repeat
            CustomerFor(Buffer."Branch Id");
            ItemFor(Buffer."Pump Id", Buffer."Product Name");
        until Buffer.Next() = 0;

        // Step 2: create. Sorted by branch and date, so each branch-day comes together.
        Buffer.SetCurrentKey("Branch Id", "Date");
        Buffer.FindSet();
        repeat
            // New branch or new day -> new sales document
            if (Buffer."Branch Id" <> LastBranch) or (DT2Date(Buffer.Date) <> LastDay) then begin
                CreateHeader(SalesHeader, Buffer."Branch Id", DT2Date(Buffer.Date));
                CreatedDocs.Add(SalesHeader."No.");
                Clear(LineFor); // line list starts empty for each new document
                LastBranch := Buffer."Branch Id";
                LastDay := DT2Date(Buffer.Date);
            end;

            // Same pump at the same price already has a line on this document -> add the litres to it
            PumpAndPrice := Buffer."Pump Id" + '|' + Format(Buffer.Price);
            if LineFor.Get(PumpAndPrice, LineNo) then begin
                SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", LineNo);
                SalesLine.Validate(Quantity, SalesLine.Quantity + Buffer."Vol Sold");
                SalesLine.Modify(true);
            end else begin
                LineNo := AddLine(SalesHeader, ItemFor(Buffer."Pump Id", Buffer."Product Name"), Buffer."Vol Sold", Buffer.Price, Buffer."Pump Name");
                LineFor.Add(PumpAndPrice, LineNo);
            end;

            DocNoFor.Add(Buffer."Transaction Id", SalesHeader."No.");
        until Buffer.Next() = 0;
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

    // Adds one sales line and gives back its Line No.
    local procedure AddLine(SalesHeader: Record "Sales Header"; ItemNo: Code[20]; Quantity: Decimal; UnitPrice: Decimal; PumpName: Text): Integer
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
        SalesLine."Description 2" := CopyStr('Pump: ' + PumpName, 1, MaxStrLen(SalesLine."Description 2"));
        SalesLine.Modify(true);
        exit(SalesLine."Line No.");
    end;

    // Posts the documents if Auto-Post is on, then says what was done
    local procedure Finish(CreatedDocs: List of [Code[20]]; RowCount: Integer)
    var
        Setup: Record "E-Pump Setup Table";
        SalesHeader: Record "Sales Header";
        DocNo: Code[20];
    begin
        Setup.Get();
        if not Setup."Auto-Post" then begin
            Message('%1 row(s) converted into %2 sales document(s).', RowCount, CreatedDocs.Count());
            exit;
        end;

        // Save the new documents and the ticks before posting, so a posting error does not undo them
        Commit();
        foreach DocNo in CreatedDocs do begin
            SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order);
            SalesHeader.SetRange("No.", DocNo);
            SalesHeader.FindFirst();
            SalesHeader.Ship := true;
            SalesHeader.Invoice := true;
            Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
        end;
        Message('%1 row(s) converted into %2 sales document(s), all posted.', RowCount, CreatedDocs.Count());
    end;
}
