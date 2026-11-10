// The small pop-up every "Fetch" action opens to ask for a company, branch and dates.
// The page actions read the answers through the procedures at the bottom.
// Those procedures also show the error when something needed was left blank,
// so the fetch code never has to check.
page 52150 "E-Pump Fetch Options"
{
    Caption = 'E-Pump Fetch';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(CompanyIdField; CompanyIdValue)
            {
                Caption = 'Company Id';
                TableRelation = "E-Pump Company";
                ToolTip = 'Pick a company. Run "Fetch My Companies" on the E-Pump Companies page first if the list is empty.';
            }
            field(BranchIdField; BranchIdValue)
            {
                Caption = 'Branch Id';
                TableRelation = "E-Pump Branch";
                ToolTip = 'Pick a branch. Run "Fetch My Branches" on the E-Pump Branches page first if the list is empty.';
            }
            field(StartDateField; StartDateValue)
            {
                Caption = 'Start Date';
                ToolTip = 'For one-day reports (end of day, company transactions, tanks filled) only this date is used.';
            }
            field(EndDateField; EndDateValue)
            {
                Caption = 'End Date';
            }
            field(StateField; StateValue)
            {
                Caption = 'State (optional)';
                ToolTip = 'Only used by Company Branches, Price Changes and Product Prices. Leave blank for all states.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        StartDateValue := Today();
        EndDateValue := Today();
    end;

    var
        CompanyIdValue: Text[50];
        BranchIdValue: Text[50];
        StartDateValue: Date;
        EndDateValue: Date;
        StateValue: Text[250];

    procedure CompanyId(): Text
    begin
        if CompanyIdValue = '' then
            Error('Please choose a Company Id.');
        exit(CompanyIdValue);
    end;

    procedure BranchId(): Text
    begin
        if BranchIdValue = '' then
            Error('Please choose a Branch Id.');
        exit(BranchIdValue);
    end;

    // For endpoints where the branch is only a filter
    procedure OptionalBranchId(): Text
    begin
        exit(BranchIdValue);
    end;

    procedure StartDate(): Date
    begin
        if StartDateValue = 0D then
            Error('Please enter a Start Date.');
        exit(StartDateValue);
    end;

    procedure EndDate(): Date
    begin
        if EndDateValue = 0D then
            Error('Please enter an End Date.');
        if EndDateValue < StartDateValue then
            Error('End Date cannot be before Start Date.');
        exit(EndDateValue);
    end;

    procedure State(): Text
    begin
        exit(StateValue);
    end;
}
