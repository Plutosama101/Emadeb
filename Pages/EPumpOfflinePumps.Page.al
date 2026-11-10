page 52139 "E-Pump Offline Pumps"
{
    Caption = 'E-Pump Offline Pumps';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E-Pump Offline Pump";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Source"; Rec."Source") { }
                field("Pump Id"; Rec."Pump Id") { }
                field("Device Id"; Rec."Device Id") { }
                field("Device Type"; Rec."Device Type") { }
                field("Pumps"; Rec."Pumps") { }
                field("Company Name"; Rec."Company Name") { }
                field("Branch Name"; Rec."Branch Name") { }
                field("Street"; Rec."Street") { }
                field("City"; Rec."City") { }
                field("State"; Rec."State") { }
                field("Region"; Rec."Region") { }
                field("Last Date"; Rec."Last Date") { }
                field("Duration"; Rec."Duration") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchDisconnectedPumps)
            {
                Caption = 'Disconnected Pumps';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.DisconnectedPumps(Options.CompanyId()));
                end;
            }
            action(FetchOfflinePumps)
            {
                Caption = 'Offline Pumps';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 rows fetched.', Fetch.OfflinePumps(Options.CompanyId()));
                end;
            }
            action(CountDisconnected)
            {
                Caption = 'Count Disconnected Pumps';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 disconnected pumps.', Fetch.DisconnectedPumpCount(Options.CompanyId()));
                end;
            }
            action(CountOffline)
            {
                Caption = 'Count Offline Pumps';
                Image = Refresh;

                trigger OnAction()
                var
                    Options: Page "E-Pump Fetch Options";
                    Fetch: Codeunit "E-Pump Fetch";
                begin
                    if Options.RunModal() <> Action::OK then
                        exit;
                    Message('%1 offline pumps.', Fetch.OfflinePumpCount(Options.CompanyId()));
                end;
            }
        }
    }
}
