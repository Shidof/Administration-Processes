tableextension 50202 "LBSL-UserSetup" extends "User Setup"
{
    fields
    {
        field(50200; "Full Name"; Text[100])
        {
            Caption = 'Full Name';
            DataClassification = CustomerContent;
        }
        field(50201; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
            trigger Onvalidate()
            begin
                IF Employee.GET("Employee No.") THEN
                    "Employee Name" := Employee.FullName;
            end;
        }
        field(50202; "Finance Officer E-mail"; Text[50])
        {
            Caption = 'Finance Officer E-mail';
            DataClassification = CustomerContent;
        }
        field(50203; "Finance Officer User ID"; Code[20])
        {
            Caption = 'Finance Officer User ID';
            DataClassification = CustomerContent;
        }
        field(50204; "HR Manager E-mail"; Text[50])
        {
            Caption = 'HR Manager E-mail';
            DataClassification = CustomerContent;
        }
        field(50205; "HR Manager"; Boolean)
        {
            Caption = 'HR Manager';
            DataClassification = ToBeClassified;
        }
        field(50206; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50207; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50208; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(50209; "View Approved Documents"; Boolean)
        {
            Editable = true;
        }
        field(50210; "Fin/Acc Officer"; Boolean)
        {
            Editable = true;
        }
    }
    var
        Employee: Record Employee;
}