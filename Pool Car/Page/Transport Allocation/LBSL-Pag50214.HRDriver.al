page 50214 "LBSL-HRDrivers Card"
{
    PageType = Card;
    SourceTable = "LBSL-HR Drivers";
    Caption = 'HR Driver';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = All;
                }
                field("Driver License Number"; Rec."Driver License Number")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Last License Renewal"; Rec."Last License Renewal")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Renewal Interval"; Rec."Renewal Interval")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Renewal Interval Value"; Rec."Renewal Interval Value")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Next License Renewal"; Rec."Next License Renewal")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Year Of Experience"; Rec."Year Of Experience")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field(Grade; Rec.Grade)
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    Importance = Promoted;
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

