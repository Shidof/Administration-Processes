page 50211 "LBSL-HRTransport Allocation"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = "LBSL-HRTransport Allocations";
    Caption = 'Transport Allocation';


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Transport Allocation No"; Rec."Transport Allocation No")
                {
                    Caption = 'Allocation No.';
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Transport Request No"; Rec."Transport Request No")
                {
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
                field("No of Hrs Requested"; Rec."No of Hrs Requested")
                {
                    ApplicationArea = All;
                }
                field("Pick up point"; Rec."Pick up point")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
            }
            group("Allocation Detail")
            {
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
            group("Closing Remarks")
            {
                Caption = 'Closing Remarks';
                field("Opening Odometer Reading"; Rec."Opening Odometer Reading")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Closing Odometer Reading"; Rec."Closing Odometer Reading")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Time out"; Rec."Time out")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Time In"; Rec."Time In")
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
                action("<Action1102755035>")
                {
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        Rec.Status := Rec.Status::Open;
                        Rec.MODIFY;
                        MESSAGE('Transport Allocation No :: :: has been Re-Opened', Rec."Transport Allocation No");
                    end;
                }
                action(Closed)
                {
                    Caption = 'Closed';
                    Image = CloseDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Transport Allocation No");
                        Rec.TESTFIELD("Transport Request No");
                        Rec.TESTFIELD("Assigned Driver");
                        Rec.TESTFIELD("Vehicle Reg Number");

                        Question := Text001;
                        IF CONFIRM(Question) THEN BEGIN
                            Rec.Status := Rec.Status::Closed;
                            Rec.MODIFY;
                            MESSAGE('Transport Allocation No ::%1:: has been Closed', Rec."Transport Allocation No");
                        END ELSE BEGIN
                            MESSAGE('You selected :: NO :: Closed Cancelled');
                        END;
                    end;
                }
                action(Returned)
                {
                    Caption = 'Returned';
                    Image = ReturnShipment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Time In");
                        Rec.TESTFIELD("Closing Odometer Reading");
                        IF CONFIRM('Are you sure the vehicle has returned from this trip?', FALSE) THEN BEGIN
                            Rec.Status := Rec.Status::Returned;
                            Rec.MODIFY;
                            MESSAGE('Transport allocation is marked returned.');
                        END;
                    end;
                }
            }
        }
    }

    var
        HRTransportAllocationsH: Record "LBSL-HRTransport Allocations";
        Text19021002: Label 'Passenger List';
        Text001: Label 'Are you sure you want to close this Document?';
        Question: Text;
}

