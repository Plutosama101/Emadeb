table 52100 "E-Pump Setup Table"
{
    Caption = 'E-Pump Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { DataClassification = SystemMetadata; }
        field(2; "Use E-Pump Integration"; Boolean) { }
        field(3; "Base URL"; Text[250]) { }
        field(4; "Login URL"; Text[100]) { }
        field(5; "User Name"; Text[100]) { }
        field(6; Password; Text[100]) { ExtendedDatatype = Masked; }
        field(7; Token; Text[2048]) { }
        field(8; "Refresh Token"; Text[250]) { }
        field(9; "Token Expiry"; DateTime) { }
        field(10; "Last Login"; DateTime) { }
        field(11; "Create Sales As"; Enum "E-Pump Sales Doc Type") { }
        field(12; "Auto-Post"; Boolean) { }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}