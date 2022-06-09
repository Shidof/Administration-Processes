codeunit 50200 "Document Approval Workflow"
{

    trigger OnRun()
    begin
    end;

    var
        DocumentWorkflow: Record "Document Workflow";
        DocumentApprovalEntry: Record "LBSL Document Approval Entry";
        DocumentApprovalEntry2: Record "LBSL Document Approval Entry";
        Text001: Label 'Approval request has been sent.';
        Text002: Label 'The approval cannot be cancelled because it has been treated by your approver.';
        Text003: Label 'Please hold on. This document requires a prior approval.';
        DocumentApprovalEntry3: Record "LBSL Document Approval Entry";
        DocumentApprovalEntry4: Record "LBSL Document Approval Entry";
        DocumentApprovalEntry5: Record "LBSL Document Approval Entry";
        DocumentApprovalEntry6: Record "LBSL Document Approval Entry";
        DocumentApprovalEntry7: Record "LBSL Document Approval Entry";
        UserSetup: Record "User Setup";
        Text004: Label 'The document has been approved.';
        Text005: Label 'The document has been rejected.';
        EmailMessage: Codeunit "Email Message";
        EmailMessage2: Codeunit "Email Message";
        EmailSend: Codeunit Email;
        EmailAccount: Record "Email Account";




        User: Record "User Setup";
        User2: Record "User Setup";
        Text006: Label 'Dear ';
        Text007: Label '%1 requires your approval.';
        SentBy: Record "User Setup";
        Apprv1: Record "User Setup";
        Apprv2: Record "User Setup";
        Apprv3: Record "User Setup";
        Apprv4: Record "User Setup";
        Apprv5: Record "User Setup";
        Apprv6: Record "User Setup";
        Apprv7: Record "User Setup";
        Subject: Text[150];
        Body: Text[250];
        Recepient: Text[250];
        Text008: Label '%1 requires your approval. Please click on the link below to approve or reject the document.';
        Text009: Label 'This is a system generated mail.';
        DocApprv: Record "User Setup";
        Text010: Label '%1 has been approved.';
        Text011: Label 'Please note that transaction %1 has been approved.';
        Text012: Label '%1 has been rejected.';
        Text013: Label 'Please note that transaction %1 has been rejected.';
        WebLink: Text;
        Text014: Label 'Your approval request is completed for %1.';
        Text015: Label 'This is an automatic notification for your approval request on %1. The request is now approved and you can proceed on further action.';
        Text016: Label 'Click the following link to view the approved record.';
        Text017: Label 'The document approvals has been reset and the document is reopened.';
        Text018: Label '%1 requires yoururgent payment processingl. Kindly proceed to disburse the payment to the beneficiary on the approved payment requisition page.';
        HRSetup: Record "LBSL-HR Setup";
        UseAnotherMailTemplate: Boolean;

    procedure SendApprovalRequest(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF NOT DocumentWorkflow.GET(USERID, TableID) THEN
            ERROR('No Approval Workflow is set for you on this document. Contact your system administrator!');

        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            IF DocumentWorkflow."1st Approver" = '' THEN
                ERROR('At least One Approver must be configured for you. Contact your system administrator!');
        END;
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            IF SentBy.GET(DocumentWorkflow."User ID") THEN;
            IF Apprv1.GET(DocumentWorkflow."1st Approver") THEN;
            IF Apprv2.GET(DocumentWorkflow."2nd Approver") THEN;
            IF Apprv3.GET(DocumentWorkflow."3rd Approver") THEN;
            IF Apprv4.GET(DocumentWorkflow."4th Approver") THEN;
            IF Apprv5.GET(DocumentWorkflow."5th Approver") THEN;
            IF Apprv6.GET(DocumentWorkflow."6th Approver") THEN;
            IF Apprv7.GET(DocumentWorkflow."7th Approver") THEN;
            Recepient := '';


            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" = '')
              AND (DocumentWorkflow."3rd Approver" = '') AND (DocumentWorkflow."4th Approver" = '')
              AND (DocumentWorkflow."5th Approver" = '') AND (DocumentWorkflow."6th Approver" = '') AND (DocumentWorkflow."7th Approver" = '') THEN
                LevelsApproval1(TableID, DocNo, RecID, DocDate, DocAmount, DocDesc);

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" = '') AND (DocumentWorkflow."4th Approver" = '')
              AND (DocumentWorkflow."5th Approver" = '') AND (DocumentWorkflow."6th Approver" = '') AND (DocumentWorkflow."7th Approver" = '') THEN
                LevelsApproval2(TableID, DocNo, RecID, DocDate, DocAmount, DocDesc);

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" <> '') AND (DocumentWorkflow."4th Approver" = '')
              AND (DocumentWorkflow."5th Approver" = '') AND (DocumentWorkflow."6th Approver" = '') AND (DocumentWorkflow."7th Approver" = '') THEN
                LevelsApproval3(TableID, DocNo, RecID, DocDate, DocAmount, DocDesc);

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" <> '') AND (DocumentWorkflow."4th Approver" <> '')
              AND (DocumentWorkflow."5th Approver" = '') AND (DocumentWorkflow."6th Approver" = '') AND (DocumentWorkflow."7th Approver" = '') THEN
                LevelsApproval4(TableID, DocNo, RecID, DocDate, DocAmount, DocDesc);


            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" <> '') AND (DocumentWorkflow."4th Approver" <> '')
              AND (DocumentWorkflow."5th Approver" <> '') AND (DocumentWorkflow."6th Approver" = '') AND (DocumentWorkflow."7th Approver" = '') THEN
                LevelsApproval5(TableID, DocNo, RecID, DocDate, DocAmount, DocDesc);

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" <> '') AND (DocumentWorkflow."4th Approver" <> '')
              AND (DocumentWorkflow."5th Approver" <> '') AND (DocumentWorkflow."6th Approver" <> '') AND (DocumentWorkflow."7th Approver" = '') THEN
                LevelsApproval6(TableID, DocNo, RecID, DocDate, DocAmount, DocDesc);

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" <> '') AND (DocumentWorkflow."4th Approver" <> '')
              AND (DocumentWorkflow."5th Approver" <> '') AND (DocumentWorkflow."6th Approver" <> '') AND (DocumentWorkflow."7th Approver" <> '') THEN
                LevelsApproval7(TableID, DocNo, RecID, DocDate, DocAmount, DocDesc);

            //SendApprovalRequestNotification(Apprv1,DocNo,DocDesc);

            //Checks first if Table ID is listed among those that
            //uses another email notification template while sending
            //for approval request
            UseAnotherApprovalNotificationTemplate(TableID);
            IF UseAnotherMailTemplate <> TRUE THEN //If table ID is not listed,
                                                   //the default Document Workflow
                                                   //Notification template is used
                SendApprovalRequestNotification(Apprv1, DocNo, DocDesc);

        END;
    end;

    procedure LevelsApproval1(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Pending;
            DocumentApprovalEntry."Document Date" := DocDate;
            DocumentApprovalEntry."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry.INSERT;
        END;
        MESSAGE(Text001);
    end;

    procedure LevelsApproval2(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Pending;
            DocumentApprovalEntry."Document Date" := DocDate;
            DocumentApprovalEntry."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2."Approval Status" := DocumentApprovalEntry2."Approval Status"::Pending;
            DocumentApprovalEntry2."Document Date" := DocDate;
            DocumentApprovalEntry2."Document Amount" := DocAmount;
            DocumentApprovalEntry2."Document Description" := DocDesc;
            DocumentApprovalEntry2."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry2.INSERT;
        END;
        MESSAGE(Text001);
    end;

    procedure LevelsApproval3(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Pending;
            DocumentApprovalEntry."Document Date" := DocDate;
            DocumentApprovalEntry."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2."Approval Status" := DocumentApprovalEntry2."Approval Status"::Pending;
            DocumentApprovalEntry2."Document Date" := DocDate;
            DocumentApprovalEntry2."Document Amount" := DocAmount;
            DocumentApprovalEntry2."Document Description" := DocDesc;
            DocumentApprovalEntry2."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry2.INSERT;

            DocumentApprovalEntry3.INIT;
            DocumentApprovalEntry3.Sequence := 3;
            DocumentApprovalEntry3."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry3."Document No." := DocNo;
            DocumentApprovalEntry3."Record ID to Approve" := RecID;
            DocumentApprovalEntry3.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry3.Approver := DocumentWorkflow."3rd Approver";
            DocumentApprovalEntry3."Approval Status" := DocumentApprovalEntry3."Approval Status"::Pending;
            DocumentApprovalEntry3."Document Date" := DocDate;
            DocumentApprovalEntry3."Document Amount" := DocAmount;
            DocumentApprovalEntry3."Document Description" := DocDesc;
            DocumentApprovalEntry3."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry3.INSERT;
        END;
        MESSAGE(Text001);
    end;

    procedure LevelsApproval4(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Pending;
            DocumentApprovalEntry."Document Date" := DocDate;
            DocumentApprovalEntry."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2."Approval Status" := DocumentApprovalEntry2."Approval Status"::Pending;
            DocumentApprovalEntry2."Document Date" := DocDate;
            DocumentApprovalEntry2."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry2."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry2.INSERT;

            DocumentApprovalEntry3.INIT;
            DocumentApprovalEntry3.Sequence := 3;
            DocumentApprovalEntry3."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry3."Document No." := DocNo;
            DocumentApprovalEntry3."Record ID to Approve" := RecID;
            DocumentApprovalEntry3.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry3.Approver := DocumentWorkflow."3rd Approver";
            DocumentApprovalEntry3."Approval Status" := DocumentApprovalEntry3."Approval Status"::Pending;
            DocumentApprovalEntry3."Document Date" := DocDate;
            DocumentApprovalEntry3."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry3."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry3.INSERT;

            DocumentApprovalEntry4.INIT;
            DocumentApprovalEntry4.Sequence := 4;
            DocumentApprovalEntry4."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry4."Document No." := DocNo;
            DocumentApprovalEntry4."Record ID to Approve" := RecID;
            DocumentApprovalEntry4.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry4.Approver := DocumentWorkflow."4th Approver";
            DocumentApprovalEntry4."Approval Status" := DocumentApprovalEntry4."Approval Status"::Pending;
            DocumentApprovalEntry4."Document Date" := DocDate;
            DocumentApprovalEntry4."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry4."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry4.INSERT;
        END;
        MESSAGE(Text001);
    end;

    procedure LevelsApproval5(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Pending;
            DocumentApprovalEntry."Document Date" := DocDate;
            DocumentApprovalEntry."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2."Approval Status" := DocumentApprovalEntry2."Approval Status"::Pending;
            DocumentApprovalEntry2."Document Date" := DocDate;
            DocumentApprovalEntry2."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry2."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry2.INSERT;

            DocumentApprovalEntry3.INIT;
            DocumentApprovalEntry3.Sequence := 3;
            DocumentApprovalEntry3."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry3."Document No." := DocNo;
            DocumentApprovalEntry3."Record ID to Approve" := RecID;
            DocumentApprovalEntry3.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry3.Approver := DocumentWorkflow."3rd Approver";
            DocumentApprovalEntry3."Approval Status" := DocumentApprovalEntry3."Approval Status"::Pending;
            DocumentApprovalEntry3."Document Date" := DocDate;
            DocumentApprovalEntry3."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry3."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry3.INSERT;

            DocumentApprovalEntry4.INIT;
            DocumentApprovalEntry4.Sequence := 4;
            DocumentApprovalEntry4."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry4."Document No." := DocNo;
            DocumentApprovalEntry4."Record ID to Approve" := RecID;
            DocumentApprovalEntry4.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry4.Approver := DocumentWorkflow."4th Approver";
            DocumentApprovalEntry4."Approval Status" := DocumentApprovalEntry4."Approval Status"::Pending;
            DocumentApprovalEntry4."Document Date" := DocDate;
            DocumentApprovalEntry4."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := DocDesc;
            DocumentApprovalEntry4."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry4.INSERT;

            DocumentApprovalEntry5.INIT;
            DocumentApprovalEntry5.Sequence := 5;
            DocumentApprovalEntry5."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry5."Document No." := DocNo;
            DocumentApprovalEntry5."Record ID to Approve" := RecID;
            DocumentApprovalEntry5.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry5.Approver := DocumentWorkflow."5th Approver";
            DocumentApprovalEntry5."Approval Status" := DocumentApprovalEntry5."Approval Status"::Pending;
            DocumentApprovalEntry5."Document Date" := DocDate;
            DocumentApprovalEntry5."Document Amount" := DocAmount;
            DocumentApprovalEntry5."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry5.INSERT;

        END;
        MESSAGE(Text001);
    end;

    local procedure LevelsApproval6(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Pending;
            DocumentApprovalEntry."Document Date" := DocDate;
            DocumentApprovalEntry."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2."Approval Status" := DocumentApprovalEntry2."Approval Status"::Pending;
            DocumentApprovalEntry2."Document Date" := DocDate;
            DocumentApprovalEntry2."Document Amount" := DocAmount;
            DocumentApprovalEntry2."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry2.INSERT;

            DocumentApprovalEntry3.INIT;
            DocumentApprovalEntry3.Sequence := 3;
            DocumentApprovalEntry3."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry3."Document No." := DocNo;
            DocumentApprovalEntry3."Record ID to Approve" := RecID;
            DocumentApprovalEntry3.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry3.Approver := DocumentWorkflow."3rd Approver";
            DocumentApprovalEntry3."Approval Status" := DocumentApprovalEntry3."Approval Status"::Pending;
            DocumentApprovalEntry3."Document Date" := DocDate;
            DocumentApprovalEntry3."Document Amount" := DocAmount;
            DocumentApprovalEntry3."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry3.INSERT;

            DocumentApprovalEntry4.INIT;
            DocumentApprovalEntry4.Sequence := 4;
            DocumentApprovalEntry4."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry4."Document No." := DocNo;
            DocumentApprovalEntry4."Record ID to Approve" := RecID;
            DocumentApprovalEntry4.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry4.Approver := DocumentWorkflow."4th Approver";
            DocumentApprovalEntry4."Approval Status" := DocumentApprovalEntry4."Approval Status"::Pending;
            DocumentApprovalEntry4."Document Date" := DocDate;
            DocumentApprovalEntry4."Document Amount" := DocAmount;
            DocumentApprovalEntry4."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry4.INSERT;

            DocumentApprovalEntry5.INIT;
            DocumentApprovalEntry5.Sequence := 5;
            DocumentApprovalEntry5."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry5."Document No." := DocNo;
            DocumentApprovalEntry5."Record ID to Approve" := RecID;
            DocumentApprovalEntry5.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry5.Approver := DocumentWorkflow."5th Approver";
            DocumentApprovalEntry5."Approval Status" := DocumentApprovalEntry5."Approval Status"::Pending;
            DocumentApprovalEntry5."Document Date" := DocDate;
            DocumentApprovalEntry5."Document Amount" := DocAmount;
            DocumentApprovalEntry5."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry5.INSERT;

            DocumentApprovalEntry6.INIT;
            DocumentApprovalEntry6.Sequence := 6;
            DocumentApprovalEntry6."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry6."Document No." := DocNo;
            DocumentApprovalEntry6."Record ID to Approve" := RecID;
            DocumentApprovalEntry6.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry6.Approver := DocumentWorkflow."6th Approver";
            DocumentApprovalEntry6."Approval Status" := DocumentApprovalEntry6."Approval Status"::Pending;
            DocumentApprovalEntry6."Document Date" := DocDate;
            DocumentApprovalEntry6."Document Amount" := DocAmount;
            DocumentApprovalEntry6."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry6.INSERT;

        END;
        MESSAGE(Text001);
    end;

    local procedure LevelsApproval7(TableID: Integer; DocNo: Code[10]; RecID: RecordID; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        IF DocumentWorkflow.GET(USERID, TableID) THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Pending;
            DocumentApprovalEntry."Document Date" := DocDate;
            DocumentApprovalEntry."Document Amount" := DocAmount;
            DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2."Approval Status" := DocumentApprovalEntry2."Approval Status"::Pending;
            DocumentApprovalEntry2."Document Date" := DocDate;
            DocumentApprovalEntry2."Document Amount" := DocAmount;
            DocumentApprovalEntry2."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry2.INSERT;

            DocumentApprovalEntry3.INIT;
            DocumentApprovalEntry3.Sequence := 3;
            DocumentApprovalEntry3."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry3."Document No." := DocNo;
            DocumentApprovalEntry3."Record ID to Approve" := RecID;
            DocumentApprovalEntry3.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry3.Approver := DocumentWorkflow."3rd Approver";
            DocumentApprovalEntry3."Approval Status" := DocumentApprovalEntry3."Approval Status"::Pending;
            DocumentApprovalEntry3."Document Date" := DocDate;
            DocumentApprovalEntry3."Document Amount" := DocAmount;
            DocumentApprovalEntry3."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry3.INSERT;

            DocumentApprovalEntry4.INIT;
            DocumentApprovalEntry4.Sequence := 4;
            DocumentApprovalEntry4."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry4."Document No." := DocNo;
            DocumentApprovalEntry4."Record ID to Approve" := RecID;
            DocumentApprovalEntry4.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry4.Approver := DocumentWorkflow."4th Approver";
            DocumentApprovalEntry4."Approval Status" := DocumentApprovalEntry4."Approval Status"::Pending;
            DocumentApprovalEntry4."Document Date" := DocDate;
            DocumentApprovalEntry4."Document Amount" := DocAmount;
            DocumentApprovalEntry4."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry4.INSERT;

            DocumentApprovalEntry5.INIT;
            DocumentApprovalEntry5.Sequence := 5;
            DocumentApprovalEntry5."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry5."Document No." := DocNo;
            DocumentApprovalEntry5."Record ID to Approve" := RecID;
            DocumentApprovalEntry5.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry5.Approver := DocumentWorkflow."5th Approver";
            DocumentApprovalEntry5."Approval Status" := DocumentApprovalEntry5."Approval Status"::Pending;
            DocumentApprovalEntry5."Document Date" := DocDate;
            DocumentApprovalEntry5."Document Amount" := DocAmount;
            DocumentApprovalEntry5."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry5.INSERT;

            DocumentApprovalEntry6.INIT;
            DocumentApprovalEntry6.Sequence := 6;
            DocumentApprovalEntry6."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry6."Document No." := DocNo;
            DocumentApprovalEntry6."Record ID to Approve" := RecID;
            DocumentApprovalEntry6.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry6.Approver := DocumentWorkflow."6th Approver";
            DocumentApprovalEntry6."Approval Status" := DocumentApprovalEntry6."Approval Status"::Pending;
            DocumentApprovalEntry6."Document Date" := DocDate;
            DocumentApprovalEntry6."Document Amount" := DocAmount;
            DocumentApprovalEntry6."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry6.INSERT;

            DocumentApprovalEntry7.INIT;
            DocumentApprovalEntry7.Sequence := 7;
            DocumentApprovalEntry7."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry7."Document No." := DocNo;
            DocumentApprovalEntry7."Record ID to Approve" := RecID;
            DocumentApprovalEntry7.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry7.Approver := DocumentWorkflow."7th Approver";
            DocumentApprovalEntry7."Approval Status" := DocumentApprovalEntry7."Approval Status"::Pending;
            DocumentApprovalEntry7."Document Date" := DocDate;
            DocumentApprovalEntry7."Document Amount" := DocAmount;
            DocumentApprovalEntry7."Document Description" := COPYSTR(DocDesc, 1, 150);
            DocumentApprovalEntry7.INSERT;

        END;
        MESSAGE(Text001);
    end;

    procedure CancelApprovalRequest(TableID: Integer; DocNo: Code[10])
    begin
        //Test if there is an existing approval
        /*
        DocumentApprovalEntry.SETCURRENTKEY(Sequence,"Document No.");
        DocumentApprovalEntry.SETRANGE("Document No.",DocNo);
        IF DocumentApprovalEntry.FINDSET THEN BEGIN
           REPEAT
             IF DocumentApprovalEntry."Approval Status" = DocumentApprovalEntry."Approval Status"::Approved THEN
               ERROR('The document has been approved already!');
           UNTIL DocumentApprovalEntry.NEXT = 0;
        END;
        */
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        IF DocumentApprovalEntry.FINDSET THEN BEGIN
            REPEAT
                IF DocumentApprovalEntry."Approval Status" <> DocumentApprovalEntry."Approval Status"::Pending THEN BEGIN
                    IF CONFIRM('The document has been approved by at least one Approver. Do you still want to cancel?', FALSE) THEN
                        DocumentApprovalEntry.DELETEALL
                    ELSE
                        ERROR(Text002);
                END;
            UNTIL DocumentApprovalEntry.NEXT = 0;
            IF DocumentApprovalEntry."Approval Status" = DocumentApprovalEntry."Approval Status"::Pending THEN
                DocumentApprovalEntry.DELETEALL;
        END ELSE
            ERROR('There is no pending approval request for this document');

    end;

    procedure ApproveDocument(DocNo: Code[10]; DocDateTime: DateTime)
    var
        Seq: Integer;
        Sender: Code[50];
        SenderEmail: Text;
        SenderName: Text;
    begin
        //to test if predecessor has approved
        Seq := 0;
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        //DocumentApprovalEntry.SETRANGE("Document Date & Time",DocDateTime);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Seq := DocumentApprovalEntry.Sequence;
            IF Seq > 1 THEN BEGIN
                DocumentApprovalEntry2.SETCURRENTKEY(Sequence, "Document No.");
                DocumentApprovalEntry2.SETRANGE(Sequence, Seq - 1);
                DocumentApprovalEntry2.SETRANGE("Document No.", DocNo);
                IF DocumentApprovalEntry2.FINDFIRST THEN
                    IF DocumentApprovalEntry2."Approval Status" = DocumentApprovalEntry2."Approval Status"::Pending THEN
                        ERROR(Text003);
            END;
        END;

        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        DocumentApprovalEntry.SETRANGE("Approval Status", DocumentApprovalEntry."Approval Status"::Pending);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Approved;
            DocumentApprovalEntry."Document Date & Time" := CURRENTDATETIME;
            DocumentApprovalEntry.MODIFY;
            Sender := DocumentApprovalEntry.Sender;
            MESSAGE(Text004);
        END ELSE
            ERROR('There is no pending approval entry for the document!');


        //Check if there is another approver and notify the next approver
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Sequence, Seq + 1);
        DocumentApprovalEntry.SETRANGE("Approval Status", DocumentApprovalEntry."Approval Status"::Pending);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            DocApprv.RESET;
            DocApprv.GET(DocumentApprovalEntry.Approver);
            //SendApprovalRequestNotification(DocApprv,DocNo,DocumentApprovalEntry."Document Description");

            //Checks first if Table ID is listed among those that
            //uses another email notification template while sending
            //for approval request
            MESSAGE('Please be informed that the next approver: %1 has been notified of this approval', DocumentApprovalEntry.Approver);
            UseAnotherApprovalNotificationTemplate(DocumentApprovalEntry."Table No.");
            IF UseAnotherMailTemplate <> TRUE THEN //If table ID is not listed,
                                                   //the default Document Workflow
                                                   //Notification template is used
                                                   //MESSAGE('');
                SendApprovalRequestNotification(DocApprv, DocNo, DocumentApprovalEntry."Document Description");
        END;

        // //send mail to the initiator if there is no pending approval
        // UserSetup.GET(Sender);
        // SenderEmail := UserSetup."E-Mail";
        // SenderName := UserSetup."Full Name";
        // SentBy.GET(USERID);
        // DocumentApprovalEntry.RESET;
        // DocumentApprovalEntry.SETCURRENTKEY("Document No.","Approval Status",Approver);
        // DocumentApprovalEntry.SETRANGE("Document No.",DocNo);
        // DocumentApprovalEntry.SETRANGE("Approval Status",DocumentApprovalEntry."Approval Status"::Pending);
        // IF NOT DocumentApprovalEntry.FINDFIRST THEN BEGIN
        //  Subject := STRSUBSTNO(Text014,DocNo);
        //  EmailMessage.CreateMessage(SentBy."Full Name",SentBy."E-Mail",SenderEmail,Subject,'',TRUE);
        //  EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + SenderName + ',')));
        //  EmailMessage.AppendToBody('<br><br>');
        //  EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text015,DocNo)));
        //  EmailMessage.AppendToBody('<br><br>');
        //  EmailMessage.AppendToBody(FORMAT(Text016));
        //  EmailMessage.AppendToBody('<br><br>');
        //  EmailMessage.AppendToBody(GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,PAGE::"Document Approval Entries",DocumentApprovalEntry,FALSE));
        //  EmailMessage.AppendToBody('<br><br>');
        //  EmailMessage.AppendToBody('Regards');
        //  EmailMessage.AppendToBody('<br><br>');
        //  EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."Full Name")));
        //  EmailMessage.AppendToBody('<HR>');
        //  EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text009)));
        //  //EmailMessage.Send;
        //  IF EmailMessage.TrySend THEN
        //  MESSAGE('%1 has been notified of this final approval.',SenderName);
        // END;
    end;

    procedure RejectDocument(DocNo: Code[10])
    var
        Seq: Integer;
        Sender: Code[50];
        SenderEmail: Text[100];
        SenderName: Text[150];
        EmailMessage: Codeunit "Email Message";
        EmailSend: Codeunit Email;
    begin
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Seq := DocumentApprovalEntry.Sequence;
            IF Seq > 1 THEN BEGIN
                DocumentApprovalEntry2.SETCURRENTKEY(Sequence, "Document No.");
                DocumentApprovalEntry2.SETRANGE(Sequence, Seq - 1);
                DocumentApprovalEntry2.SETRANGE("Document No.", DocNo);
                IF DocumentApprovalEntry2.FINDFIRST THEN
                    IF DocumentApprovalEntry2."Approval Status" = DocumentApprovalEntry2."Approval Status"::Pending THEN
                        ERROR(Text003);
            END;
        END;

        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        DocumentApprovalEntry.SETRANGE("Approval Status", DocumentApprovalEntry."Approval Status"::Pending);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            DocumentApprovalEntry."Approval Status" := DocumentApprovalEntry."Approval Status"::Rejected;
            DocumentApprovalEntry.MODIFY;
            Sender := DocumentApprovalEntry.Sender;
            MESSAGE(Text005);
        END ELSE
            ERROR('There is no pending approval entry for the document!');

        //send mail to the initiator about this rejected approval
        UserSetup.GET(Sender);
        SenderEmail := UserSetup."E-Mail";
        SenderName := UserSetup."Full Name";

        SentBy.GET(USERID);
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        IF NOT DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Subject := STRSUBSTNO(Text014, DocNo);
            EmailMessage.Create(UserSetup."E-Mail", Subject, '');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + SenderName + ',')));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text015, DocNo)));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(FORMAT(Text016));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page, PAGE::"LBSL-Document Approval Entries", DocumentApprovalEntry, FALSE));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody('Regards');
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."Full Name")));
            EmailMessage.AppendToBody('<HR>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text009)));
            //EmailMessage.Send;
            IF EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
            MESSAGE('%1 has been notified of this rejected approval.', SenderName);
        END;
    end;


    procedure ApprovalStatusCheck(TableID: Integer; DocNo: Code[10]; RecID: RecordID): Boolean
    begin
        DocumentApprovalEntry7.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry7.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry7.FINDLAST;
        IF DocumentApprovalEntry7."Approval Status" = DocumentApprovalEntry7."Approval Status"::Approved THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE)

    end;

    procedure SendApprovalRequestNotification(Recipient: Record "User Setup"; DocNo: Code[20]; Description: Text[100])

    begin
        IF SentBy.GET(USERID) THEN;
        //  WebLink :=  GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,PAGE::"Document Approval Entries",DocumentApprovalEntry,FALSE);
        Subject := STRSUBSTNO('Document No. %1 with description (%2) requires your approval.', DocNo, Description);
        EmailMessage.Create(UserSetup."E-Mail", Subject, '');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + Recipient."Full Name" + ',')));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text008, DocNo)));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page, PAGE::"LBSL-Document Approval Entries", DocumentApprovalEntry, FALSE));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody('Regards');
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."Full Name")));
        EmailMessage.AppendToBody('<HR>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text009)));
        //EmailMessage.Send;
        IF EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
    end;

    procedure ReopenApproval(DocNo: Code[10])
    begin

        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        IF DocumentApprovalEntry.FINDSET THEN
            DocumentApprovalEntry.DELETEALL;
        MESSAGE(Text017);
    end;

    procedure PendingApprovalEntryExistsForCurrUser(var DocumentApprovalEntry: Record "LBSL Document Approval Entry"; RecordID: RecordID): Boolean
    begin
        DocumentApprovalEntry.SETRANGE("Table No.", RecordID.TABLENO);
        DocumentApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        DocumentApprovalEntry.SETRANGE("Approval Status", DocumentApprovalEntry."Approval Status"::Pending);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);

        EXIT(DocumentApprovalEntry.FINDFIRST);
    end;

    procedure SendPaymentNotificationToFinance(Recipient: Record "User Setup"; DocNo: Code[20]; Description: Text[100])
    begin
        HRSetup.GET;
        HRSetup.TESTFIELD("Finance Officer Email");

        IF SentBy.GET(USERID) THEN;
        Subject := STRSUBSTNO('Document No. %1 requires your urgent payment processing.', DocNo);
        EmailMessage.Create(HRSetup."Finance Officer Email", Subject, '');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO('Dear ' + HRSetup."Finance Officer First Name" + ',')));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text018, DocNo)));
        //  EmailMessage.AppendToBody('<br><br>');
        //  EmailMessage.AppendToBody(GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,PAGE::"Document Approval Entries",DocumentApprovalEntry,FALSE));
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody('Regards');
        EmailMessage.AppendToBody('<br><br>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."Full Name")));
        EmailMessage.AppendToBody('<HR>');
        EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text009)));
        //EmailMessage.Send;
        IF EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
    end;

    local procedure UseAnotherApprovalNotificationTemplate(TableID: Integer)
    begin
        IF TableID IN [DATABASE::"LBSL-HR Transport Requisition" //DATABASE::"Stores Return",
                                                                 /* DATABASE::"Payment Requisition", DATABASE::"Welfare Requisition",
                                                                 DATABASE::"HR Leave Application", DATABASE::Retirement,
                                                                 DATABASE::"CA & Imprest Mgt.", DATABASE::"Stores Requisition",
                                                                 DATABASE::"HR Employee Requisitions", DATABASE::"Hr Interview Evaluation", DATABASE::"Vendor Payment Requisition" */]
        THEN
            UseAnotherMailTemplate := TRUE
        ELSE
            UseAnotherMailTemplate := FALSE;
    end;
}

