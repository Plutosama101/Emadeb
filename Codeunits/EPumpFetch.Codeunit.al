// One procedure per E-Pump endpoint. Each one:
//   1. builds the path   (e.g. '/Branch/Sales/' + BranchId + dates)
//   2. calls E-Pump      (EPumpMgt.GetArray does the login, request and error handling)
//   3. saves the rows    (one line per field) and returns how many rows it saved
//
// Endpoints that send back the same kind of row share one "Save..." procedure.
//
// Two kinds of tables:
//   - Rows WITH an id from E-Pump (sales, transactions, branches...) are added or updated, so fetching again never makes duplicates.
//   - Rows WITHOUT an id (tank fills, dips, offline pumps...) cannot be matched, so the old rows are deleted and replaced on every fetch.
codeunit 52103 "E-Pump Fetch"
{
    var
        EPumpMgt: Codeunit "E-Pump Mgt";

    // ================= Companies =================

    procedure MyCompanies(): Integer
    var
        Company: Record "E-Pump Company";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/Company/MyCompanies');
        foreach Row in Rows do begin
            R := Row.AsObject();
            Company.Init();
            Company."Company Id" := EPumpMgt.GetText(R, 'id');
            Company.Name := EPumpMgt.GetText(R, 'name');
            Company.Email := EPumpMgt.GetText(R, 'email');
            Company.Phone := EPumpMgt.GetText(R, 'phone');
            Company.City := EPumpMgt.GetText(R, 'city');
            Company.State := EPumpMgt.GetText(R, 'state');
            Company.Country := EPumpMgt.GetText(R, 'country');
            Company."Currency Code" := EPumpMgt.GetText(R, 'currencyCode');
            Company."Number of Branches" := EPumpMgt.GetInteger(R, 'numberOfBranches');
            Company."Number of Dealers" := EPumpMgt.GetInteger(R, 'numberOfDealers');
            Company.Status := EPumpMgt.GetText(R, 'status');
            if not Company.Insert() then
                Company.Modify();
        end;
        exit(Rows.Count());
    end;

    // ================= Branches =================

    procedure MyBranches(): Integer
    begin
        exit(SaveBranches(EPumpMgt.GetArray('/Company/MyBranches')));
    end;

    procedure CompanyBranches(CompanyId: Text; State: Text): Integer
    begin
        if State = '' then
            exit(SaveBranches(EPumpMgt.GetArray('/Company/Branches/' + CompanyId)));
        exit(SaveBranches(EPumpMgt.GetArray('/Company/Branches/' + CompanyId + '/' + Encode(State))));
    end;

    procedure ComprehensiveBranches(CompanyId: Text): Integer
    begin
        exit(SaveBranches(EPumpMgt.GetArray('/Company/ComprehensiveBranches/' + CompanyId)));
    end;

    local procedure SaveBranches(Rows: JsonArray): Integer
    var
        Branch: Record "E-Pump Branch";
        Row: JsonToken;
        R: JsonObject;
    begin
        foreach Row in Rows do begin
            R := Row.AsObject();
            Branch.Init();
            Branch."Branch Id" := EPumpMgt.GetText(R, 'id');
            Branch.Name := EPumpMgt.GetText(R, 'name');
            Branch."Company Id" := EPumpMgt.GetText(R, 'companyId');
            Branch."Company Name" := EPumpMgt.GetText(R, 'companyName');
            Branch.Phone := EPumpMgt.GetText(R, 'phone');
            Branch.Email := EPumpMgt.GetText(R, 'email');
            Branch.Street := EPumpMgt.GetText(R, 'street');
            Branch.City := EPumpMgt.GetText(R, 'city');
            Branch.LGA := EPumpMgt.GetText(R, 'lga');
            Branch.State := EPumpMgt.GetText(R, 'state');
            Branch.Country := EPumpMgt.GetText(R, 'country');
            Branch."Full Address" := EPumpMgt.GetText(R, 'fullAddress');
            Branch."Group Id" := EPumpMgt.GetText(R, 'groupId');
            Branch."Group Name" := EPumpMgt.GetText(R, 'groupName');
            Branch."Region Id" := EPumpMgt.GetText(R, 'regionId');
            Branch."Region Name" := EPumpMgt.GetText(R, 'regionName');
            Branch."Branch Status" := EPumpMgt.GetText(R, 'branchStatus');
            Branch.Type := EPumpMgt.GetText(R, 'type');
            Branch.Latitude := EPumpMgt.GetDecimal(R, 'latitude');
            Branch.Longitude := EPumpMgt.GetDecimal(R, 'longitude');
            Branch.Date := EPumpMgt.GetDateTime(R, 'date');
            if not Branch.Insert() then
                Branch.Modify();
        end;
        exit(Rows.Count());
    end;

    // ================= Pumps =================

    procedure BranchPumps(BranchId: Text): Integer
    var
        Pump: Record "E-Pump Branch Pump";
        Mapping: Record "E-Pump Product Mapping";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
        AlreadyThere: Boolean;
    begin
        Rows := EPumpMgt.GetArray('/Branch/Pumps/' + BranchId);
        foreach Row in Rows do begin
            R := Row.AsObject();
            // Load the pump if we have it, so the Item No. set in BC is kept
            AlreadyThere := Pump.Get(EPumpMgt.GetText(R, 'id'));
            if not AlreadyThere then begin
                Pump.Init();
                Pump."Pump Id" := EPumpMgt.GetText(R, 'id');
            end;
            Pump.Name := EPumpMgt.GetText(R, 'displayName');
            Pump."Branch Id" := EPumpMgt.GetText(R, 'branchId');
            Pump."Product Name" := EPumpMgt.GetText(R, 'productName');
            Pump."Tank Name" := EPumpMgt.GetText(R, 'tankName');
            Pump.Status := EPumpMgt.GetText(R, 'status');
            Pump."Selling Price" := EPumpMgt.GetDecimal(R, 'sellingPrice');
            Pump."Opening Reading" := EPumpMgt.GetDecimal(R, 'openingReading');
            Pump."Current Reading" := EPumpMgt.GetDecimal(R, 'currentReading');
            Pump."Manual Opening Reading" := EPumpMgt.GetDecimal(R, 'manualOpeningReading');
            Pump."Manual Closing Reading" := EPumpMgt.GetDecimal(R, 'manualClosingReading');
            Pump.Manufacturer := EPumpMgt.GetText(R, 'manufacturer');
            Pump.Model := EPumpMgt.GetText(R, 'model');
            Pump."Pump Address" := EPumpMgt.GetInteger(R, 'pumpAddress');
            Pump."Device Id" := EPumpMgt.GetText(R, 'deviceId');
            Pump."Last Update" := EPumpMgt.GetDateTime(R, 'lastUpdate');
            Pump."Date Created" := EPumpMgt.GetDateTime(R, 'dateCreated');

            // A pump without an item gets one from the Product Mappings (if there is one)
            if Pump."Item No." = '' then
                Pump."Item No." := Mapping.ItemFor(Pump."Product Name");

            if AlreadyThere then
                Pump.Modify()
            else
                Pump.Insert();
        end;
        exit(Rows.Count());
    end;

    // Fetches pumps for every branch on the E-Pump Branches page
    procedure AllBranchPumps() Total: Integer
    var
        Branch: Record "E-Pump Branch";
    begin
        if Branch.FindSet() then
            repeat
                Total += BranchPumps(Branch."Branch Id");
            until Branch.Next() = 0;
    end;

    // ================= Pump sales (all of these send back the same kind of row) =================

    procedure BranchSales(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SavePumpSales(EPumpMgt.GetArray('/Branch/Sales/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate)), BranchId));
    end;

    procedure BranchSalesV2(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SavePumpSales(EPumpMgt.GetArray('/Branch/Salesv2/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate)), BranchId));
    end;

    procedure DaySale(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SavePumpSales(EPumpMgt.GetArray('/Branch/DaySale/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate)), BranchId));
    end;

    procedure CompanySales(CompanyId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SavePumpSales(EPumpMgt.GetArray('/Company/BranchSales/' + CompanyId + EPumpMgt.DateRange(StartDate, EndDate)), ''));
    end;

    procedure CompanySalesSummary(CompanyId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SavePumpSales(EPumpMgt.GetArray('/Company/BranchSales/Summary/' + CompanyId + EPumpMgt.DateRange(StartDate, EndDate)), ''));
    end;

    procedure CompanyBranchSales(CompanyId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        // This endpoint takes the dates in the path, not after a '?'
        exit(SavePumpSales(EPumpMgt.GetArray('/Company/CompanyBranchSales/' + CompanyId + '/' + Format(StartDate, 0, 9) + '/' + Format(EndDate, 0, 9)), ''));
    end;

    procedure PriceChanges(CompanyId: Text; BranchId: Text; State: Text; StartDate: Date; EndDate: Date): Integer
    var
        Path: Text;
    begin
        Path := '/Company/BranchPriceChange/' + CompanyId + EPumpMgt.DateRange(StartDate, EndDate);
        if BranchId <> '' then
            Path += '&branchId=' + BranchId;
        if State <> '' then
            Path += '&state=' + Encode(State);
        exit(SavePumpSales(EPumpMgt.GetArray(Path), BranchId));
    end;

    procedure ProductPrices(CompanyId: Text; BranchId: Text; State: Text): Integer
    var
        Path: Text;
    begin
        Path := '/Company/BranchProductPrice/' + CompanyId + '?';
        if BranchId <> '' then
            Path += '&branchId=' + BranchId;
        if State <> '' then
            Path += '&state=' + Encode(State);
        exit(SavePumpSales(EPumpMgt.GetArray(Path), BranchId));
    end;

    local procedure SavePumpSales(Rows: JsonArray; AskedBranchId: Text): Integer
    var
        Sale: Record "E-Pump Pump Sale";
        Row: JsonToken;
        R: JsonObject;
        AlreadyThere: Boolean;
    begin
        foreach Row in Rows do begin
            R := Row.AsObject();
            // Load the row if we have it, so "Invoice Created" is not wiped
            AlreadyThere := Sale.Get(EPumpMgt.GetText(R, 'id'));
            if not AlreadyThere then begin
                Sale.Init();
                Sale."Sale Id" := EPumpMgt.GetText(R, 'id');
            end;
            Sale.Date := EPumpMgt.GetDateTime(R, 'date');
            Sale."Branch Id" := BranchIdOf(R, AskedBranchId);
            Sale."Branch Name" := EPumpMgt.GetText(R, 'branchName');
            Sale."Pump Id" := EPumpMgt.GetText(R, 'pumpId');
            Sale."Pump Name" := EPumpMgt.GetText(R, 'pumpName');
            Sale."Product Name" := EPumpMgt.GetText(R, 'productName');
            Sale."Opening Reading" := EPumpMgt.GetDecimal(R, 'openingReading');
            Sale."Last Reading" := EPumpMgt.GetDecimal(R, 'lastReading');
            Sale."Volume Sold" := EPumpMgt.GetDecimal(R, 'volumeSold');
            Sale.Price := EPumpMgt.GetDecimal(R, 'price');
            Sale."Amount Sold" := EPumpMgt.GetDecimal(R, 'amountSold');
            Sale.RTT := EPumpMgt.GetDecimal(R, 'rtt');
            Sale."Dealer Name" := EPumpMgt.GetText(R, 'dealerName');
            if AlreadyThere then
                Sale.Modify()
            else
                Sale.Insert();
        end;
        exit(Rows.Count());
    end;

    // E-Pump sometimes sends a sale without its branch id. Then we use:
    //   1. the branch we asked for (when fetching for one branch), or
    //   2. the branch on the E-Pump Branches page with the same name.
    local procedure BranchIdOf(R: JsonObject; AskedBranchId: Text): Text
    var
        Branch: Record "E-Pump Branch";
    begin
        if EPumpMgt.GetText(R, 'branchId') <> '' then
            exit(EPumpMgt.GetText(R, 'branchId'));
        if AskedBranchId <> '' then
            exit(AskedBranchId);
        Branch.SetRange(Name, EPumpMgt.GetText(R, 'branchName'));
        if Branch.FindFirst() then
            exit(Branch."Branch Id");
        exit('');
    end;

    // ================= Transactions =================

    procedure BranchTransactions(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SaveTransactions(EPumpMgt.GetArray('/Branch/Transactions/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate)), BranchId));
    end;

    procedure CompanyTransactions(CompanyId: Text; OnDate: Date): Integer
    begin
        exit(SaveTransactions(EPumpMgt.GetArray('/Company/BranchTransactions/' + CompanyId + '?date=' + Format(OnDate, 0, 9)), ''));
    end;

    local procedure SaveTransactions(Rows: JsonArray; AskedBranchId: Text): Integer
    var
        Trans: Record "E-Pump Transaction";
        Row: JsonToken;
        R: JsonObject;
        AlreadyThere: Boolean;
    begin
        foreach Row in Rows do begin
            R := Row.AsObject();
            // Load the row if we have it, so "Invoice Created" is not wiped
            AlreadyThere := Trans.Get(EPumpMgt.GetText(R, 'id'));
            if not AlreadyThere then begin
                Trans.Init();
                Trans."Transaction Id" := EPumpMgt.GetText(R, 'id');
            end;
            Trans.Date := EPumpMgt.GetDateTime(R, 'date');
            Trans."Branch Id" := BranchIdOf(R, AskedBranchId);
            Trans."Branch Name" := EPumpMgt.GetText(R, 'branchName');
            Trans."Pump Id" := EPumpMgt.GetText(R, 'pumpId');
            Trans."Pump Name" := EPumpMgt.GetText(R, 'pumpName');
            Trans."Product Name" := EPumpMgt.GetText(R, 'productName');
            Trans."Opening Read" := EPumpMgt.GetDecimal(R, 'openingRead');
            Trans."Closing Read" := EPumpMgt.GetDecimal(R, 'closingRead');
            Trans."Vol Sold" := EPumpMgt.GetDecimal(R, 'volSold');
            Trans.Price := EPumpMgt.GetDecimal(R, 'price');
            Trans.Amount := EPumpMgt.GetDecimal(R, 'amount');
            Trans.RTT := EPumpMgt.GetDecimal(R, 'rtt');
            Trans."Staff Name" := EPumpMgt.GetText(R, 'staffName');
            Trans."Sales Type" := EPumpMgt.GetText(R, 'salesType');
            Trans."Voucher Card Number" := EPumpMgt.GetText(R, 'voucherCardNumber');
            Trans."Transaction Time" := EPumpMgt.GetInteger(R, 'transactionTime');
            if AlreadyThere then
                Trans.Modify()
            else
                Trans.Insert();
        end;
        exit(Rows.Count());
    end;

    // ================= Tank fills (no id, so each fetch replaces the rows from the same source) =================

    procedure BranchTankFills(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SaveTankFills(EPumpMgt.GetArray('/Branch/TankFills/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate)), 'Branch Tank Fills'));
    end;

    procedure ProductDischarge(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SaveTankFills(EPumpMgt.GetArray('/Branch/ProductDischarge/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate)), 'Product Discharge'));
    end;

    procedure CompanyTankFills(CompanyId: Text; StartDate: Date; EndDate: Date): Integer
    begin
        exit(SaveTankFills(EPumpMgt.GetArray('/Company/TankFills/' + CompanyId + EPumpMgt.DateRange(StartDate, EndDate)), 'Company Tank Fills'));
    end;

    procedure CompanyTanksFilled(CompanyId: Text; OnDate: Date): Integer
    begin
        exit(SaveTankFills(EPumpMgt.GetArray('/Company/TanksFilled/' + CompanyId + '?date=' + Format(OnDate, 0, 9)), 'Company Tanks Filled'));
    end;

    local procedure SaveTankFills(Rows: JsonArray; Source: Text): Integer
    var
        TankFill: Record "E-Pump Tank Fill";
        Row: JsonToken;
        R: JsonObject;
    begin
        TankFill.SetRange(Source, Source);
        TankFill.DeleteAll();

        foreach Row in Rows do begin
            R := Row.AsObject();
            TankFill.Init();
            TankFill."Entry No." := 0; // 0 = let BC pick the next number
            TankFill.Source := Source;
            TankFill."Branch Id" := EPumpMgt.GetText(R, 'branchId');
            TankFill."Branch Name" := EPumpMgt.GetText(R, 'branchName');
            TankFill.Tank := EPumpMgt.GetText(R, 'tank');
            TankFill."Product Name" := EPumpMgt.GetText(R, 'productName');
            TankFill."Start Time" := EPumpMgt.GetDateTime(R, 'startTime');
            TankFill."Start Volume" := EPumpMgt.GetDecimal(R, 'startVolume');
            TankFill."End Time" := EPumpMgt.GetDateTime(R, 'endTime');
            TankFill."End Volume" := EPumpMgt.GetDecimal(R, 'endVolume');
            TankFill."Filled Volume" := EPumpMgt.GetDecimal(R, 'filledVolume');
            TankFill.Insert();
        end;
        exit(Rows.Count());
    end;

    // ================= Tank product sales =================

    procedure TankSales(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    var
        TankSale: Record "E-Pump Tank Sale";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/Branch/TankProductSales/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate));
        TankSale.DeleteAll();

        foreach Row in Rows do begin
            R := Row.AsObject();
            TankSale.Init();
            TankSale."Entry No." := 0;
            TankSale.Date := EPumpMgt.GetDateTime(R, 'date');
            TankSale."Branch Id" := EPumpMgt.GetText(R, 'branchId');
            TankSale."Branch Name" := EPumpMgt.GetText(R, 'branchName');
            TankSale."Tank Id" := EPumpMgt.GetText(R, 'tankId');
            TankSale."Tank Name" := EPumpMgt.GetText(R, 'tankName');
            TankSale."Product Name" := EPumpMgt.GetText(R, 'productName');
            TankSale."Opening Dip" := EPumpMgt.GetDecimal(R, 'openingDip');
            TankSale."Closing Dip" := EPumpMgt.GetDecimal(R, 'closingDip');
            TankSale."Volume Filled" := EPumpMgt.GetDecimal(R, 'volumeFilled');
            TankSale."Volume Sold" := EPumpMgt.GetDecimal(R, 'volumeSold');
            TankSale.Insert();
        end;
        exit(Rows.Count());
    end;

    // ================= Inventory (one row per tank) =================

    procedure Inventory(BranchId: Text): Integer
    var
        Inv: Record "E-Pump Inventory";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/Branch/InventoryReport/' + BranchId);
        foreach Row in Rows do begin
            R := Row.AsObject();
            Inv.Init();
            Inv."Tank Id" := EPumpMgt.GetText(R, 'tankId');
            Inv."Branch Id" := BranchId; // E-Pump does not send this back, so we keep the one we asked for
            Inv."Tank Name" := EPumpMgt.GetText(R, 'tankName');
            Inv.Product := EPumpMgt.GetText(R, 'product');
            Inv."Current Volume" := EPumpMgt.GetDecimal(R, 'currentVolume');
            Inv."Tank Capacity" := EPumpMgt.GetDecimal(R, 'tankCapacity');
            Inv."Last Filled Date" := EPumpMgt.GetDateTime(R, 'lastFilledDate');
            Inv."Last Filled Volume" := EPumpMgt.GetDecimal(R, 'lastFilledVolume');
            Inv."Avg Dispensed Per Day" := EPumpMgt.GetDecimal(R, 'avgProductDispensePerDay');
            if not Inv.Insert() then
                Inv.Modify();
        end;
        exit(Rows.Count());
    end;

    // ================= Manual records =================

    procedure ManualPumpRecords(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    var
        Manual: Record "E-Pump Manual Pump Record";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/Branch/ManualRecord/Pump/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate));
        Manual.DeleteAll();

        foreach Row in Rows do begin
            R := Row.AsObject();
            Manual.Init();
            Manual."Entry No." := 0;
            Manual.Date := EPumpMgt.GetDateTime(R, 'date');
            Manual."Branch Id" := EPumpMgt.GetText(R, 'branchId');
            Manual."Pump Id" := EPumpMgt.GetText(R, 'pumpId');
            Manual."Pump Name" := EPumpMgt.GetText(R, 'pumpName');
            Manual."Staff Id" := EPumpMgt.GetText(R, 'staffId');
            Manual."Staff Name" := EPumpMgt.GetText(R, 'staffName');
            Manual."Outer Opening Read" := EPumpMgt.GetDecimal(R, 'outerOpeningRead');
            Manual."Outer Closing Read" := EPumpMgt.GetDecimal(R, 'outerClosingRead');
            Manual."Opening Read" := EPumpMgt.GetDecimal(R, 'openingRead');
            Manual."Closing Read" := EPumpMgt.GetDecimal(R, 'closingRead');
            Manual."Max Reading" := EPumpMgt.GetDecimal(R, 'maxReading');
            Manual."Total Sale" := EPumpMgt.GetDecimal(R, 'totalSale');
            Manual.RTT := EPumpMgt.GetDecimal(R, 'rtt');
            Manual.Transfer := EPumpMgt.GetDecimal(R, 'transfer');
            Manual.Status := EPumpMgt.GetText(R, 'status');
            Manual.Rejected := EPumpMgt.GetBoolean(R, 'rejected');
            Manual."Date Rejected" := EPumpMgt.GetDateTime(R, 'dateRejected');
            Manual."Image Url" := EPumpMgt.GetText(R, 'imageUrl');
            Manual.Insert();
        end;
        exit(Rows.Count());
    end;

    procedure TankDips(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    var
        Dip: Record "E-Pump Tank Dip";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/Branch/ManualRecord/Tank/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate));
        Dip.DeleteAll();

        foreach Row in Rows do begin
            R := Row.AsObject();
            Dip.Init();
            Dip."Entry No." := 0;
            Dip.Date := EPumpMgt.GetDateTime(R, 'date');
            Dip."Branch Id" := EPumpMgt.GetText(R, 'branchId');
            Dip."Tank Id" := EPumpMgt.GetText(R, 'tankId');
            Dip."Tank Name" := EPumpMgt.GetText(R, 'tankName');
            Dip."Opening Dip" := EPumpMgt.GetDecimal(R, 'openingDip');
            Dip."Closing Dip" := EPumpMgt.GetDecimal(R, 'closingDip');
            Dip.Height := EPumpMgt.GetDecimal(R, 'height');
            Dip."Filled Volume" := EPumpMgt.GetDecimal(R, 'filledVolume');
            Dip."Actual Volume" := EPumpMgt.GetDecimal(R, 'actualVolume');
            Dip."Calculated Volume" := EPumpMgt.GetDecimal(R, 'calculatedVolume');
            Dip.Difference := EPumpMgt.GetDecimal(R, 'difference');
            Dip.Remarks := EPumpMgt.GetText(R, 'remarks');
            Dip."Recorded By" := EPumpMgt.GetText(R, 'recordedBy');
            Dip."Recorded On" := EPumpMgt.GetDateTime(R, 'recordedOn');
            Dip.Rejected := EPumpMgt.GetBoolean(R, 'rejected');
            Dip."Date Rejected" := EPumpMgt.GetDateTime(R, 'dateRejected');
            Dip.Insert();
        end;
        exit(Rows.Count());
    end;

    // ================= Offline / disconnected pumps =================

    procedure DisconnectedPumps(CompanyId: Text): Integer
    var
        Pump: Record "E-Pump Offline Pump";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/Company/DisconnectedPump/' + CompanyId);
        Pump.SetRange(Source, 'Disconnected');
        Pump.DeleteAll();

        foreach Row in Rows do begin
            R := Row.AsObject();
            Pump.Init();
            Pump."Entry No." := 0;
            Pump.Source := 'Disconnected';
            Pump."Pump Id" := EPumpMgt.GetText(R, 'pumpId');
            Pump."Device Id" := EPumpMgt.GetText(R, 'deviceId');
            Pump.Pumps := EPumpMgt.GetText(R, 'pumps');
            Pump."Company Name" := EPumpMgt.GetText(R, 'companyName');
            Pump."Branch Name" := EPumpMgt.GetText(R, 'branchName');
            Pump.State := EPumpMgt.GetText(R, 'state');
            Pump.Region := EPumpMgt.GetText(R, 'region');
            Pump."Last Date" := EPumpMgt.GetDateTime(R, 'date');
            Pump.Insert();
        end;
        exit(Rows.Count());
    end;

    procedure OfflinePumps(CompanyId: Text): Integer
    var
        Pump: Record "E-Pump Offline Pump";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/Company/OfflinePump/' + CompanyId);
        Pump.SetRange(Source, 'Offline');
        Pump.DeleteAll();

        foreach Row in Rows do begin
            R := Row.AsObject();
            Pump.Init();
            Pump."Entry No." := 0;
            Pump.Source := 'Offline';
            Pump."Device Id" := EPumpMgt.GetText(R, 'deviceId');
            Pump."Device Type" := EPumpMgt.GetText(R, 'deviceType');
            Pump.Pumps := EPumpMgt.GetText(R, 'nozzles');
            Pump."Company Name" := EPumpMgt.GetText(R, 'companyName');
            Pump."Branch Name" := EPumpMgt.GetText(R, 'branchName');
            Pump.Street := EPumpMgt.GetText(R, 'street');
            Pump.City := EPumpMgt.GetText(R, 'city');
            Pump.State := EPumpMgt.GetText(R, 'state');
            Pump.Region := EPumpMgt.GetText(R, 'region');
            Pump."Last Date" := EPumpMgt.GetDateTime(R, 'lastDate');
            Pump.Duration := EPumpMgt.GetText(R, 'duration');
            Pump.Insert();
        end;
        exit(Rows.Count());
    end;

    // These two send back just a number, e.g. 5
    procedure DisconnectedPumpCount(CompanyId: Text) Result: Integer
    begin
        Evaluate(Result, EPumpMgt.CallApi('/Company/DisconnectedPumpCount/' + CompanyId));
    end;

    procedure OfflinePumpCount(CompanyId: Text) Result: Integer
    begin
        Evaluate(Result, EPumpMgt.CallApi('/Company/OfflinePumpCount/' + CompanyId));
    end;

    // ================= End of day (4 small reports saved as Name / Amount lines) =================

    procedure EndOfDay(BranchId: Text; OnDate: Date): Integer
    var
        Summary: Record "E-Pump Day Summary";
        Answer: JsonObject;
        Expense: JsonObject;
        Expenses: JsonToken;
        Row: JsonToken;
        Query: Text;
    begin
        Summary.DeleteAll();
        Query := BranchId + '?date=' + Format(OnDate, 0, 9);

        Answer := EPumpMgt.GetObject('/Branch/EndofDayReport/DryStockSummary/' + Query);
        AddLine(BranchId, OnDate, 'Dry Stock', 'Total Sale Amount', EPumpMgt.GetDecimal(Part(Answer, 'totalSale'), 'amount'));
        AddLine(BranchId, OnDate, 'Dry Stock', 'Total Sale Items', EPumpMgt.GetDecimal(Part(Answer, 'totalSale'), 'itemCount'));
        AddLine(BranchId, OnDate, 'Dry Stock', 'Total Supply Amount', EPumpMgt.GetDecimal(Part(Answer, 'totalSupply'), 'amount'));
        AddLine(BranchId, OnDate, 'Dry Stock', 'Total Supply Items', EPumpMgt.GetDecimal(Part(Answer, 'totalSupply'), 'itemCount'));
        AddLine(BranchId, OnDate, 'Dry Stock', 'Total Product Left', EPumpMgt.GetDecimal(Answer, 'totalProductLeft'));

        Answer := EPumpMgt.GetObject('/Branch/EndofDayReport/ExpenseSummary/' + Query);
        AddLine(BranchId, OnDate, 'Expenses', 'Total Expenses', EPumpMgt.GetDecimal(Answer, 'totalExpenses'));
        if Answer.Get('expenses', Expenses) then
            if Expenses.IsArray() then
                foreach Row in Expenses.AsArray() do begin
                    Expense := Row.AsObject();
                    AddLine(BranchId, OnDate, 'Expenses', EPumpMgt.GetText(Expense, 'name'), EPumpMgt.GetDecimal(Expense, 'amount'));
                end;

        Answer := EPumpMgt.GetObject('/Branch/EndofDayReport/RentalManagement/' + Query);
        AddLine(BranchId, OnDate, 'Rental', 'Estimated Rent Revenue', EPumpMgt.GetDecimal(Answer, 'estimatedRentRevenue'));
        AddLine(BranchId, OnDate, 'Rental', 'Total Amount Paid', EPumpMgt.GetDecimal(Answer, 'totalAmountPaid'));
        AddLine(BranchId, OnDate, 'Rental', 'Outstanding Payment', EPumpMgt.GetDecimal(Answer, 'outstandingPayment'));

        Answer := EPumpMgt.GetObject('/Branch/EndofDayReport/MaintenanceManagement/' + Query);
        AddLine(BranchId, OnDate, 'Maintenance', 'Total Requests', EPumpMgt.GetDecimal(Answer, 'totalMaintenanceRequest'));
        AddLine(BranchId, OnDate, 'Maintenance', 'Pending Requests', EPumpMgt.GetDecimal(Answer, 'totalPendingRequest'));
        AddLine(BranchId, OnDate, 'Maintenance', 'Fixed Requests', EPumpMgt.GetDecimal(Answer, 'totalFixedRequest'));

        exit(Summary.Count());
    end;

    local procedure AddLine(BranchId: Text; OnDate: Date; ReportName: Text; LineName: Text; Amount: Decimal)
    var
        Summary: Record "E-Pump Day Summary";
    begin
        Summary.Init();
        Summary."Entry No." := 0;
        Summary."Branch Id" := BranchId;
        Summary.Date := OnDate;
        Summary."Report" := ReportName;
        Summary."Line" := LineName;
        Summary.Amount := Amount;
        Summary.Insert();
    end;

    // Gets an object inside an object, e.g. "totalSale": { "amount": 10 }. Gives an empty object if it is missing.
    local procedure Part(Row: JsonObject; FieldName: Text) Result: JsonObject
    var
        Value: JsonToken;
    begin
        if Row.Get(FieldName, Value) then
            if Value.IsObject() then
                Result := Value.AsObject();
    end;

    // ================= Dry stock =================

    procedure DryStockProducts(BranchId: Text): Integer
    var
        Product: Record "E-Pump Dry Stock Product";
        Rows: JsonArray;
        Row: JsonToken;
        Variation: JsonToken;
        R: JsonObject;
        V: JsonObject;
        Variations: JsonToken;
    begin
        Rows := EPumpMgt.GetArray('/DrystockProduct/' + BranchId);
        Product.DeleteAll();

        // Each product has a list of sizes ("items"). We save one row per size.
        foreach Row in Rows do begin
            R := Row.AsObject();
            if R.Get('items', Variations) then
                if Variations.IsArray() then
                    foreach Variation in Variations.AsArray() do begin
                        V := Variation.AsObject();
                        Product.Init();
                        Product."Entry No." := 0;
                        Product."Branch Id" := BranchId;
                        Product."Product Id" := EPumpMgt.GetText(R, 'id');
                        Product."Product Name" := EPumpMgt.GetText(R, 'name');
                        Product.Category := EPumpMgt.GetText(R, 'category');
                        Product.Description := EPumpMgt.GetText(R, 'description');
                        Product."Is Company Product" := EPumpMgt.GetBoolean(R, 'isCompanyProduct');
                        Product."Variation Id" := EPumpMgt.GetText(V, 'id');
                        Product."Variation Name" := EPumpMgt.GetText(V, 'variationName');
                        Product.Size := EPumpMgt.GetDecimal(V, 'size');
                        Product."Size Detail" := EPumpMgt.GetText(V, 'sizeDetail');
                        Product."Price Per Unit" := EPumpMgt.GetDecimal(V, 'pricePerUnit');
                        Product."Quantity Per Unit" := EPumpMgt.GetInteger(V, 'quantityPerUnit');
                        Product."Total Items" := EPumpMgt.GetInteger(V, 'totalItem');
                        Product.Insert();
                    end;
        end;
        exit(Product.Count());
    end;

    procedure DryStockSupplies(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    var
        Supply: Record "E-Pump Dry Stock Supply";
        Rows: JsonArray;
        Row: JsonToken;
        Item: JsonToken;
        Items: JsonToken;
        R: JsonObject;
        I: JsonObject;
        Saved: Integer;
    begin
        Rows := EPumpMgt.GetArray('/DryStockSupply/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate));

        // Each supply has a list of items. We save one row per item.
        foreach Row in Rows do begin
            R := Row.AsObject();
            if R.Get('items', Items) then
                if Items.IsArray() then
                    foreach Item in Items.AsArray() do begin
                        I := Item.AsObject();
                        Supply.Init();
                        Supply."Item Id" := EPumpMgt.GetText(I, 'id');
                        Supply."Supply Id" := EPumpMgt.GetText(R, 'id');
                        Supply.Date := EPumpMgt.GetDateTime(R, 'date');
                        Supply."Branch Id" := BranchId;
                        Supply."Retail Outlet" := EPumpMgt.GetText(R, 'retailOutlet');
                        Supply."Supply Status" := EPumpMgt.GetText(R, 'status');
                        Supply."Recorded By" := EPumpMgt.GetText(R, 'recordedBy');
                        Supply."Product Name" := EPumpMgt.GetText(I, 'productName');
                        Supply."Variation Name" := EPumpMgt.GetText(I, 'variationName');
                        Supply.Size := EPumpMgt.GetDecimal(I, 'sizeNumber');
                        Supply."Price Per Unit" := EPumpMgt.GetDecimal(I, 'pricePerUnit');
                        Supply."Quantity Per Unit" := EPumpMgt.GetDecimal(I, 'quantityPerUnit');
                        Supply."Quantity Supplied" := EPumpMgt.GetDecimal(I, 'quantitySupply');
                        Supply."Quantity Accepted" := EPumpMgt.GetDecimal(I, 'quantityAccepted');
                        Supply."Total Rejected" := EPumpMgt.GetInteger(I, 'totalRejected');
                        Supply."Item Status" := EPumpMgt.GetText(I, 'status');
                        Supply."Is Processed" := EPumpMgt.GetBoolean(I, 'isProcessed');
                        if not Supply.Insert() then
                            Supply.Modify();
                        Saved += 1;
                    end;
        end;
        exit(Saved);
    end;

    procedure DryStockSales(BranchId: Text; StartDate: Date; EndDate: Date): Integer
    var
        Sale: Record "E-Pump Dry Stock Sale";
        Rows: JsonArray;
        Row: JsonToken;
        R: JsonObject;
    begin
        Rows := EPumpMgt.GetArray('/DryStockSale/' + BranchId + EPumpMgt.DateRange(StartDate, EndDate));
        foreach Row in Rows do begin
            R := Row.AsObject();
            Sale.Init();
            Sale."Sale Id" := EPumpMgt.GetText(R, 'id');
            Sale.Date := EPumpMgt.GetDateTime(R, 'date');
            Sale."Branch Id" := BranchId;
            Sale."Retail Outlet" := EPumpMgt.GetText(R, 'retailOutlet');
            Sale.Products := EPumpMgt.GetTextList(R, 'product');
            Sale."Customer Name" := EPumpMgt.GetText(R, 'customerName');
            Sale."Quantity Sold" := EPumpMgt.GetDecimal(R, 'quantitySold');
            Sale."Discount Price" := EPumpMgt.GetDecimal(R, 'discountPrice');
            Sale."Total Amount" := EPumpMgt.GetDecimal(R, 'totalAmount');
            Sale."Tax Rate" := EPumpMgt.GetInteger(R, 'taxRate');
            if not Sale.Insert() then
                Sale.Modify();
        end;
        exit(Rows.Count());
    end;

    // Makes text safe to put in a URL, e.g. 'Lagos State' -> 'Lagos%20State'
    local procedure Encode(Value: Text): Text
    var
        Uri: Codeunit Uri;
    begin
        exit(Uri.EscapeDataString(Value));
    end;
}
