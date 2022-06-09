page 50213 "LBSL-HRDrivers List"
{
    CardPageID = "LBSL-HRDrivers Card";
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "LBSL-HR Drivers";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'HR Driver';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    ApplicationArea = All;
                }
                field("Driver License Number"; Rec."Driver License Number")
                {
                    ApplicationArea = All;
                }
                field("Last License Renewal"; Rec."Last License Renewal")
                {
                    ApplicationArea = All;
                }
                field("Renewal Interval"; REc."Renewal Interval")
                {
                    ApplicationArea = All;
                }
                field("Renewal Interval Value"; Rec."Renewal Interval Value")
                {
                    ApplicationArea = All;
                }
                field("Next License Renewal"; Rec."Next License Renewal")
                {
                    ApplicationArea = All;
                }
                field("Year Of Experience"; Rec."Year Of Experience")
                {
                    ApplicationArea = All;
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
            }
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

