table 50207 "LBSL-HR Leave Batches Lines"
{

    fields
    {
        field(1; "Doucment No."; Code[10])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Employee No."; Code[10])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Last Name";
                    "Employee Group" := Employee."Employee Posting Group";
                    //"Leave Days" := Employee."Annual Leave Days";
                    "Leave Entry Type" := "Leave Entry Type"::Positive;
                    "Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
                END ELSE BEGIN
                    "Employee Name" := '';
                    "Employee Group" := '';
                    "Leave Days" := 0;
                    "Shortcut Dimension 1 Code" := '';
                    "Shortcut Dimension 2 Code" := '';
                END;
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
        }
        field(5; "Employee Group"; Code[20])
        {
        }
        field(6; "Leave Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(7; "Leave Entry Type"; Option)
        {
            OptionCaption = 'Positive,Negative';
            OptionMembers = Positive,Negative;
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = const(1));
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(Key1; "Doucment No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;

}

