page 50212 "HRTransport Allocations List"
{
    CardPageID = "LBSL-HRTransport Allocation";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = "LBSL-HRTransport Allocations";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Transport Allocation';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Transport Allocation No"; Rec."Transport Allocation No")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Trip Description"; Rec."Trip Description")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Purpose of Trip"; Rec."Purpose of Trip")
                {
                    ApplicationArea = All;
                }
                field("Date of Trip"; Rec."Date of Trip")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Time of Trip"; Rec."Time of Trip")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Vehicle Reg Number"; Rec."Vehicle Reg Number")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Assigned Driver"; Rec."Assigned Driver")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Date of Allocation"; Rec."Date of Allocation")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("&Print")
                {
                    Caption = '&Print';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        HRTransportAllocationsH.RESET;
                        HRTransportAllocationsH.SETRANGE(HRTransportAllocationsH."Transport Allocation No", Rec."Transport Allocation No");
                        IF HRTransportAllocationsH.FIND('-') THEN
                            REPORT.RUN(93929, TRUE, TRUE, HRTransportAllocationsH);
                    end;
                }
                action("<Action1102755035>p")
                {
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Open;
                        Rec.MODIFY;
                        MESSAGE('Transport Allocation No :: :: has been Re-Opened', Rec."Transport Allocation No");
                    end;
                }
                action(Release)
                {
                    Caption = 'Closed';
                    Image = CloseDocument;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Question := Text001;
                        IF CONFIRM(Question) THEN BEGIN
                            Rec.Status := Rec.Status::Closed;
                            Rec.MODIFY;
                            MESSAGE('Transport Allocation No :: :: has been Closed', Rec."Transport Allocation No");
                        END ELSE BEGIN
                            MESSAGE('You selected :: NO :: Closed Cancelled');
                        END;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Transport Allocations")
            {
                Caption = 'Transport Allocations';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                //RunObject = Report 95596;
            }
        }
    }

    var
        HRTransportAllocationsH: Record "LBSL-HRTransport Allocations";
        Text19021002: Label 'Passenger List';
        Text001: Label 'Are you sure you want to Release this Document?';
        Question: Text;
}

