pageextension 50201 "LBSL-Employee" extends "Employee Card"
{
    layout
    {

        addafter("Company E-Mail")
        {
            field("Department Code"; Rec."Department code")
            {
                ApplicationArea = All;
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = All;
            }

        }
    }
}
