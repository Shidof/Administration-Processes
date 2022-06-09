page 50200 "HR Staff Transport Requisition"
{
    PageType = Card;
    SourceTable = "LBSL-HR Transport Requisition";
    Caption = 'Staff Transport Requisition';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Application Code"; Rec."Application Code")
                {
                    Caption = 'Request No';
                    ApplicationArea = All;

                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; Rec."Employee No")
                {
                    Caption = 'Applicant No.';
                    ApplicationArea = All;
                }
                field(Names; Rec.Names)
                {
                    Caption = 'Applicant Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Caption = 'Job Title';
                    Editable = false;
                    ApplicationArea = All;
                }
                /* field(EmpJobDesc; EmpJobDesc)
                {
                    Caption = 'Job Description';
                    Editable = false;
                    Visible = false;
                } */
                field(Department; Rec.Department)
                {
                    Caption = 'Department Code';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Vehicle; Rec.Vehicle)
                {
                    ApplicationArea = All;
                }
                field("Vehicle Name"; Rec."Vehicle Name")
                {
                    ApplicationArea = All;
                }
                field(Supervisor; Rec.Supervisor)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Supervisor Email"; Rec."Supervisor Email")
                {
                    Caption = 'Supervisor Email';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            group("Trip Details")
            {
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("Transport type"; Rec."Transport type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Time of Trip"; Rec."Time of Trip")
                {
                    ApplicationArea = All;
                }
                field("Purpose of Trip"; Rec."Purpose of Trip")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("No. of Hours"; Rec."No. of Hours")
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
                field("Pickup Point"; Rec."Pickup Point")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Document Approval WF FactBox"; 50207)
            {
                ApplicationArea = All;
                SubPageLink = "Table No." = CONST(50201),

                              "Document No." = field("Application Code");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        IF Rec."User ID" <> USERID THEN
                            ERROR('You are not authorized to send the approval request.');


                        IF Rec.Status = Rec.Status::Approved THEN
                            ERROR('The document is already approved!');

                        IF DocumentWorkflow.GET(USERID, DATABASE::"LBSL-HR Transport Requisition") THEN
                            IF UserSetup.GET(DocumentWorkflow."1st Approver") THEN;

                        Rec.TESTFIELD("Application Code");
                        Rec.TESTFIELD("Start Date");
                        Rec.TESTFIELD("Purpose of Trip");
                        Rec.TESTFIELD("Time of Trip");

                        TransportReq.SETRANGE("Application Code", Rec."Application Code");
                        IF TransportReq.FINDFIRST THEN
                            RecID := TransportReq.RECORDID;
                        DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, Rec."Application Code", RecID, Rec."Request Date", 0, Rec."Purpose of Trip");
                        SendApprovalRequestNotification(UserSetup, Rec."Application Code", Rec."Purpose of Trip");
                        Rec.Status := Rec.Status::"Pending Approval";
                        Rec.MODIFY;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Ellipsis = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;


                    trigger OnAction()
                    begin
                        IF Rec."User ID" <> USERID THEN
                            ERROR('You are not authorized to cancel the approval request.');

                        IF Rec.Status = Rec.Status::Approved THEN
                            ERROR('The document is already approved!');

                        TransportReq.SETRANGE("Application Code", Rec."Application Code");
                        IF TransportReq.FINDFIRST THEN
                            RecID := TransportReq.RECORDID;
                        DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, Rec."Application Code");
                        Rec.Status := Rec.Status::" ";
                        Rec."Current Pending Approver" := '';
                        Rec.MODIFY;
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ApprovalRequestVisible;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";


                    begin
                        IF Rec.Status = Rec.Status::Approved THEN
                            ERROR('The document is already approved!');

                        DocumentApprovalWorkflow.ApproveDocument(Rec."Application Code", CURRENTDATETIME);
                        IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."Application Code", RecID) THEN BEGIN
                            UserSetup.RESET;
                            UserSetup.GET(Rec."User ID");
                            SendFinalApprovalNotification(UserSetup, Rec."Application Code", Rec."Purpose of Trip");
                            Rec.Status := Rec.Status::Approved;
                            Rec."Current Pending Approver" := '';
                            Rec.MODIFY;
                        END;

                        CheckForNextApprover(DATABASE::"LBSL-HR Transport Requisition", Rec."Application Code");
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ApprovalRequestVisible;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        IF Rec.Status = Rec.Status::Approved THEN
                            ERROR('The document is already approved!');

                        DocumentApprovalWorkflow.RejectDocument(Rec."Application Code");
                        IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."Application Code", RecID) THEN BEGIN
                            Rec.Status := Rec.Status::Rejected;
                            Rec.MODIFY;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls();

        FillVariables;
    end;

    trigger OnOpenPage()
    begin



        ApprovalRequestVisible := TRUE;
        IF Rec.Status = Rec.Status::" " THEN
            ApprovalRequestVisible := FALSE
        ELSE
            ApprovalRequestVisible := TRUE;


        IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
            DocumentApprovalEntry.RESET;
            DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
            DocumentApprovalEntry.SETRANGE("Document No.", Rec."Application Code");
            DocumentApprovalEntry.SETRANGE("Table No.", 50201);
            DocumentApprovalEntry.SETFILTER(DocumentApprovalEntry."Approval Status", '%1', DocumentApprovalEntry."Approval Status"::Pending);
            IF DocumentApprovalEntry.FINDFIRST THEN BEGIN

                // Start of Logic that allows only current approver see approve or reject action
                IF DocumentApprovalEntry.Approver = USERID THEN
                    ApprovalRequestVisible := TRUE
                ELSE
                    ApprovalRequestVisible := FALSE;
                // End of Logic that allows only current approver see approve or reject action

                Rec.MODIFY(TRUE);
            end;
        END;
        CurrPage.Update;
    end;

    var
        /* HREmp: Record "95575";
        EmpJobDesc: Text[30];
        SupervisorName: Text[30]; */
        SMTP: Codeunit "Email Message";
        URL: Text[500];
        dAlloc: Decimal;
        dEarnd: Decimal;
        dTaken: Decimal;
        dLeft: Decimal;
        cReimbsd: Decimal;
        cPerDay: Decimal;
        cbf: Decimal;
        HRSetup: Record "LBSL-HR Setup";
        EmpDept: Text[30];
        HRLeaveApp: Record "LBSL-HR Transport Requisition";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Budget Transfer","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval";
        D: Date;
        EmpName: Text[70];
        TransportReq: Record "LBSL-HR Transport Requisition";
        RecID: RecordID;
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        ApprovalEntries: Page "Approval Entries";
        CTEXTURL: Text[30];
        HREmailParameters: Record "LBSL-HR E-Mail Parameters";
        RecRef: RecordRef;
        UserSetup: Record "User Setup";
        SenderName: Text;
        SenderAddress: Text;
        EmailSubject: Text;
        EmailMessage: Codeunit "Email Message";
        TransportReq1: Record "LBSL-HR Transport Requisition";
        IsOther: Boolean;
        hyperlinkText: Text;
        ApprovalRequestVisible: Boolean;
        VisibleForFinanceOnly: Boolean;
        DocumentApprovalEntry: Record "LBSL Document Approval Entry";
        DocumentWorkflow: Record "Document Workflow";
        SentBy: Record "User Setup";
        VisibleToHR: Boolean;
        IsRequester: Boolean;
        Text001: Label 'Vacancy for the Postion of %1';
        Text009: Label 'This e-mail is from Microsoft Dynamics BC. Please do not reply';
        Text002: Label 'We are pleased to inform you of %1  opportunity within the organisation. Kindly click on the link below to see the Job Description and the requirements. ';
        Text003: Label 'You may refer qualified applicants to apply for the role.';
        Text004: Label 'Applicants should send their application as the body of the email indicating the position applied for as email subject and their CV in MS Word or PDF format as an attachment to hr@relianceinfosystems.com copying careers@relianceinfosystems.com ';
        Text005: Label 'Applicants should apply via this %1';
        Text006: Label 'Please note that only shortlisted candidates will be contacted. ';
        Text007: Label 'Transport requisition with ID No. %1 raised by %2 for the purpose of (%3) requires your attention. Please find details below:';
        SystemGenerated: Label 'This is a system generated mail.';
        Text008: Label 'Please be informed that your transport requisition for the purpose of %1 has been finally approved by %2. ';
        Text010: Label 'Dear';
        Text011: Label 'Cash Advance with No. %1 requires your urgent payment processing. Kindly proceed to disburse the payment to the beneficiary on the approved payment requisition page.';
        Text012: Label '<br> Reason for Request: %1</br>Other Reasons: %2';
        Text013: Label 'Transport Requisition with ID: %1 :: Requester: %2 ::Trip Purpose: %3 ';

    procedure FillVariables()
    begin
        //GET THE APPLICANT DETAILS

        /*HREmp.RESET;
        IF HREmp.GET("Employee No") THEN
        BEGIN
        EmpName:=HREmp.FullName;
        EmpDept:=HREmp."Global Dimension 1 Code";
        END ELSE BEGIN
        EmpDept:='';
        END;*/

        //GET THE JOB DESCRIPTION FRON THE HR JOBS TABLE AND PASS IT TO THE VARIABLE
        //HRJobs.RESET;
        /*IF HRJobs.GET("Job Title") THEN
        BEGIN
        EmpJobDesc:=HRJobs."Job Title";
        END ELSE BEGIN
        EmpJobDesc:='';
        END;*/

        //GET THE APPROVER NAMES
        /*HREmp.RESET;
        HREmp.SETRANGE(HREmp."User ID",Supervisor);
        IF HREmp.FIND('-') THEN
        BEGIN
        SupervisorName:=HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
        END ELSE BEGIN
        SupervisorName:='';
        END;*/

    end;

    procedure GetLeaveStats(LeaveType: Text[50])
    begin

        /*dAlloc := 0;
        dEarnd := 0;
        dTaken := 0;
        dLeft := 0;
        cReimbsd := 0;
        cPerDay := 0;
        cbf:=0;
        IF HREmp.GET("Employee No") THEN BEGIN
        HREmp.SETFILTER(HREmp."Leave Type Filter",LeaveType);
        HREmp.CALCFIELDS(HREmp."Allocated Leave Days");
        dAlloc := HREmp."Allocated Leave Days";
        HREmp.VALIDATE(HREmp."Allocated Leave Days");
        dEarnd := HREmp."Total (Leave Days)";
        HREmp.CALCFIELDS(HREmp."Total Leave Taken");
        dTaken := HREmp."Total Leave Taken";
        dLeft :=  HREmp."Leave Balance";
        cReimbsd :=HREmp."Cash - Leave Earned";
        cPerDay := HREmp."Cash per Leave Day" ;
        cbf:=HREmp."Reimbursed Leave Days";
        END;*/

    end;

    procedure TESTFIELDS()
    begin
        //TESTFIELD("Leave Type");
        /*TESTFIELD("Days Applied");
        TESTFIELD("Start Date");
        //TESTFIELD(Reliever);
        TESTFIELD(Supervisor);*/

    end;

    procedure UpdateControls()
    begin

        /*
         IF Status<>Status::New THEN BEGIN
         CurrForm."Leave Type".EDITABLE:=FALSE;
         CurrForm."Days Applied".EDITABLE:=FALSE;
         CurrForm."Start Date".EDITABLE:=FALSE;
         CurrForm.Reliever.EDITABLE:=FALSE;
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
         END ELSE BEGIN
         CurrForm."Leave Type".EDITABLE:=TRUE;
         CurrForm."Days Applied".EDITABLE:=TRUE;
         CurrForm."Start Date".EDITABLE:=TRUE;
         CurrForm.Reliever.EDITABLE:=TRUE;
         CurrForm."Responsibility Center".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END;

         IF Status<>Status::Approved THEN BEGIN
         CurrForm."Leave Type".EDITABLE:=TRUE;
         CurrForm."Days Applied".EDITABLE:=TRUE;
         CurrForm."Start Date".EDITABLE:=TRUE;
         CurrForm.Reliever.EDITABLE:=TRUE;
         CurrForm."Responsibility Center".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END ELSE BEGIN
         CurrForm."Leave Type".EDITABLE:=FALSE;
         CurrForm."Days Applied".EDITABLE:=FALSE;
         CurrForm."Start Date".EDITABLE:=FALSE;
         CurrForm.Reliever.EDITABLE:=FALSE;
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
         END;
         */

    end;

    procedure SendApprovalRequestNotification(Recipient: Record "User Setup"; DocNo: Code[20]; Description: Text[100])
    var
        Subject: Text;
        EmailBody: Text;
        EmailMessage: Codeunit "Email Message";
        EmailAccount: Record "Email Account";
        EmailSend: Codeunit Email;
        hyperlinkText: Text;
        Link: Text;
        GLSetup: Record "General Ledger Setup";
        CurrCode: Code[10];
        BodyMessage: Text;
        AddBodyMessage: Text;

    begin
        IF SentBy.GET(USERID) THEN;
        //  GLSetup.GET;
        //  CurrCode  := GLSetup."LCY Code";

        EmailBody := STRSUBSTNO(Text007, Rec."Application Code", Rec.Names, Rec."Purpose of Trip");

        Rec.SETRECFILTER;
        Link := GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page,
                    PAGE::"HR Staff Transport Requisition", Rec);
        hyperlinkText := STRSUBSTNO('<a href=' + Link + '>' + 'Click here to approve or reject record.</a>');
        Subject := STRSUBSTNO(Text013, Rec."Application Code", Rec.Names, Rec."Purpose of Trip");
        EmailMessage.Create(Recipient."E-Mail", Subject, '', true);
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO('Dear ' + Recipient."Full Name" + ',')));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(EmailBody));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO('Purpose of Trip: %1', Rec."Purpose of Trip")));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO('Date of Trip: %1', Rec."Start Date")));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(hyperlinkText);
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody('Regards,');
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."Full Name")));
        EmailMessage.AppendToBody('<HR>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SystemGenerated)));
        IF EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
    end;

    local procedure CheckForNextApprover(TableID: Integer; DocNo: Code[10])
    var
        DocumentApprovalEntryLocal: Record "LBSL Document Approval Entry";
        Seq: Integer;
        PrevApprover: Code[30];
        CurrApprovSetup: Record "User Setup";
    begin
        //Get Last Approved sequence and approver for the document
        Seq := 0;
        PrevApprover := '';
        DocumentApprovalEntryLocal.RESET;
        DocumentApprovalEntryLocal.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntryLocal.SETRANGE("Table No.", TableID);
        DocumentApprovalEntryLocal.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntryLocal.SETRANGE("Approval Status", DocumentApprovalEntryLocal."Approval Status"::Approved);
        DocumentApprovalEntryLocal.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntryLocal.FINDLAST THEN BEGIN
            PrevApprover := DocumentApprovalEntryLocal.Approver;
            Seq := DocumentApprovalEntryLocal.Sequence;
        END;

        //Check if there is another approver and notify the next approver
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntryLocal.SETRANGE("Table No.", TableID);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Sequence, Seq + 1);
        DocumentApprovalEntry.SETRANGE("Approval Status", DocumentApprovalEntry."Approval Status"::Pending);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            CurrApprovSetup.RESET;
            CurrApprovSetup.GET(DocumentApprovalEntry.Approver);
            SendApprovalRequestNotification(CurrApprovSetup, DocNo, DocumentApprovalEntry."Document Description");
        END;
    end;

    local procedure SendFinalApprovalNotification(Recipient: Record "User Setup"; DocNo: Code[20]; Description: Text[100])
    var
        Subject: Text;
        EmailBody: Text;
        EmailMessage: Codeunit "Email Message";
        hyperlinkText: Text;
        Link: Text;
        GLSetup: Record "General Ledger Setup";
        CurrCode: Code[10];
        SenderEmail: Text;
        SenderName: Text;
        EmailSend: Codeunit Email;

    begin
        IF SentBy.GET(USERID) THEN;
        SenderEmail := SentBy."E-Mail";
        SenderName := SentBy."Full Name";

        // GLSetup.GET;
        // CurrCode  := GLSetup."LCY Code";
        EmailBody := STRSUBSTNO(Text008, Rec."Purpose of Trip", SenderName);

        Rec.SETRECFILTER;
        Link := GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page,
                    PAGE::"HR Staff Transport Requisition", Rec);
        hyperlinkText := STRSUBSTNO('<a href=' + Link + '>' + 'Click here to view the approved record.</a>');
        Subject := STRSUBSTNO('Your Approval Request is completed for %1 by %2 - %3',
                    Rec."Application Code", SenderName, COMPANYNAME);
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE("Approval Status", DocumentApprovalEntry."Approval Status"::Pending);
        IF NOT DocumentApprovalEntry.FINDFIRST THEN BEGIN
            EmailMessage.Create(Recipient."E-Mail", Subject, '', true);
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO('Dear ' + Recipient."Full Name" + ',')));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(FORMAT(EmailBody));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(hyperlinkText);
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody('Regards,');
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."Full Name")));
            EmailMessage.AppendToBody('<HR>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SystemGenerated)));
            //EmailMessage.Send;
            IF EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
            MESSAGE('%1 has been notified of this final approval.', Rec."User ID");
        END;
    end;

    local procedure NotifyRequesterOfEachApproval(NextApprover: Record "User Setup"; DocNo: Code[20]; Description: Text[100])
    var
        Subject: Text;
        EmailBody: Text;
        EmailMessage: Codeunit "Email Message";
        hyperlinkText: Text;
        Link: Text;
        GLSetup: Record "General Ledger Setup";
        CurrCode: Code[10];
        SenderEmail: Text;
        SenderName: Text;
        Msg: Label 'Please be informed that your transport requisition %1 has been approved.<br><br>Kindly note that the next approver is <b>%2</b> ';
        Recipient: Record "User Setup";
    begin
        /*IF SentBy.GET(USERID) THEN;
        SenderEmail := SentBy."E-Mail";
        SenderName := SentBy."Full Name";
        
        Recipient.GET("User ID");
        
        Rec.SETRECFILTER;
        Link := GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,
                    PAGE::"HR Staff Transport Requisition",Rec);
        hyperlinkText := STRSUBSTNO('<a href=' + Link + '>' + 'Click here to view the record.</a>');
        Subject := STRSUBSTNO('Transport Requisition %1 Has Been Approved',Rec."Application Code");
        
        EmailBody := STRSUBSTNO(Msg,DocNo,NextApprover."Approver ID");
        
        EmailMessage.CreateMessage(SenderName,SenderEmail,Recipient."E-Mail",Subject,'',TRUE);
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO('Dear ' + Recipient."Full Name" + ',')));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(EmailBody)));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(hyperlinkText);
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody('Regards,');
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."Full Name")));
        EmailMessage.AppendToBody('<HR>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SystemGenerated)));
        //EmailMessage.Send;
        IF EmailMessage.TrySend THEN
        MESSAGE('Requester %1 has been notified of your approval.',Rec."User ID");
        */


    end;
}

