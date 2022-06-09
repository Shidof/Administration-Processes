page 50201 "LBSL-HRTransport Requests List"
{
    CardPageID = "HR Staff Transport Requisition";
    Editable = false;
    PageType = List;
    SourceTable = "LBSL-HR Transport Requisition";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Transport Requisition';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application Code"; Rec."Application Code")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field("Purpose of Trip"; Rec."Purpose of Trip")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("Time of Trip"; Rec."Time of Trip")
                {
                    ApplicationArea = All;
                }
                field("No. of Hours"; Rec."No. of Hours")
                {
                    ApplicationArea = All;
                }
                field("Pickup Point"; Rec."Pickup Point")
                {
                    ApplicationArea = All;
                }
                field("From Destination"; Rec."From Destination")
                {
                    ApplicationArea = All;
                }
                field("To Destination"; Rec."To Destination")
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
        area(reporting)
        {
            action("Transport Requests")
            {
                Caption = 'Transport Requests';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                //RunObject = Report 95605;
            }
        }
    }

    var
        EmpName: Text[70];
}

