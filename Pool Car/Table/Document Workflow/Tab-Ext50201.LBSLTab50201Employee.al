tableextension 50201 "LBSL-Tab50201.Employee" extends Employee
{
    fields
    {
        field(50200; "Department Code"; Text[50])
        {
            Caption = '';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50201; "Branch Code"; Text[50])
        {
            Caption = '';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }
}
