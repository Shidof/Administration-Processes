table 50201 "LBSL-HR Transport Requisition"
{
    DrillDownPageID = "LBSL-HRTransport Requests List";
    LookupPageID = "LBSL-HRTransport Requests List";

    fields
    {
        field(1; "Application Code"; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                //TEST IF MANUAL NOs ARE ALLOWED
                IF "Application Code" <> xRec."Application Code" THEN BEGIN
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Transport Req Nos");
                    "No series" := '';
                END;
            end;
        }
        /* field(4; "Days Applied"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                // TESTFIELD("Leave Type");
                // CALCULATE THE END DATE AND RETURN DATE
                BEGIN
                    IF ("Days Applied" <> 0) AND ("Start Date" <> 0D) THEN
                        "Return Date" := DetermineTransportReturnDate("Start Date", "Days Applied");
                    "End Date" := DeterminethisTransportEndDate("Return Date");
                    MODIFY;
                END;
            end;
        } */
        field(5; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                IF "Start Date" = 0D THEN BEGIN
                    "Return Date" := 0D;
                    EXIT;
                END ELSE BEGIN
                    //      IF DetermineIfIsNonWorking("Start Date")= TRUE THEN BEGIN;
                    //      ERROR('Start date must be a working day');
                END;
                //VALIDATE("Days Applied");
            end;
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
            Editable = false;
        }
        field(7; "Request Date"; Date)
        {
            Editable = false;
        }
        field(8; "No. of Hours"; Integer)
        {
        }
        field(9; "End Date"; Date)
        {
            Editable = false;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = ' ,Pending Approval,Approved,Rejected';
            OptionMembers = " ","Pending Approval",Approved,Rejected;
        }
        field(15; "Applicant Comments"; Text[250])
        {
        }
        field(17; "No series"; Code[30])
        {
        }
        field(28; Selected; Boolean)
        {
        }
        field(3940; Names; Text[100])
        {
        }
        field(3955; "Supervisor Email"; Text[30])
        {
        }
        field(3958; "Job Title"; Text[50])
        {
        }
        field(3959; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(3961; "Employee No"; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                IF EmpRec.GET("Employee No") THEN BEGIN
                    "Job Title" := EmpRec."Job Title";
                    Names := EmpRec.FullName;
                    Department := EmpRec."Department Code";
                    Message(EmpRec."Department Code");
                END;
            end;
        }
        field(3962; Supervisor; Code[20])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                IF UserSetup.GET(Supervisor) THEN
                    "Supervisor Name" := UserSetup."Full Name";
                "Supervisor Email" := UserSetup."E-Mail";
            end;
        }
        field(3965; "Purpose of Trip"; Text[100])
        {
        }
        field(3966; "Transport type"; Code[10])
        {
            //ableRelation = "HR Lookup Values".Type WHERE(Type = FILTER("Transport Type"));
        }
        field(3967; "Time of Trip"; Time)
        {
        }
        field(3968; "Pickup Point"; Text[30])
        {
        }
        field(3969; "From Destination"; Text[30])
        {
        }
        field(3970; "To Destination"; Text[30])
        {
        }
        field(3971; "Allocation Status"; Option)
        {
            OptionCaption = ' ,Allocated,On-hold,Rescheduled';
            OptionMembers = " ",Allocated,"On-hold",Rescheduled;
        }
        field(3972; Vehicle; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LBSL-HR Transport Vehicles"."Registration No";

            trigger OnValidate()
            begin
                VehReq.GET(Vehicle);
                "Vehicle Name" := VehReq.Name;
            end;
        }
        field(3973; "Vehicle Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3974; "Supervisor Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(3975; Department; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3976; "Current Pending Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Application Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Status <> Status::" " THEN
            ERROR(mcontent + ' ' + "Application Code" + ' ' + mcontent2);

        /*LVApplicants.RESET;
        LVApplicants.SETRANGE(LVApplicants."Application Code","Application Code");
        IF LVApplicants.FINDFIRST THEN
          BEGIN
                IF (LVApplicants.Status=LVApplicants.Status::Approved) OR
                (LVApplicants.Status=LVApplicants.Status::"Pending Approval") THEN
               ERROR('You Cannot Delete this record, this record if status is not pending');
          END;
          */

    end;

    trigger OnInsert()
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        IF "Application Code" = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Transport Req Nos");
            NoSeriesMgt.InitSeries(HRSetup."Transport Req Nos", xRec."No series", 0D, "Application Code", "No series");
        END;

        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Employee No." = '' THEN
                ERROR('User ID - ' + USERID + ' ' + 'is not assigned to any employee. Consult the HR Officer so as to be setup as an employee');
            VALIDATE("Employee No", UserSetup."Employee No.");
            VALIDATE(Supervisor, UserSetup."Approver ID");
            "User ID" := USERID;
        END ELSE
            ERROR('You are not authorized to perform this operation!');


        //GET LEAVE APPROVER DETAILS FROM USER SETUP TABLE COPY THEM TO THE LEAVE APPLICATION TABLE
        // UserSetup.RESET;
        // IF UserSetup.GET(USERID)THEN BEGIN

        // END;
        //POPULATE FIELDS
        "Request Date" := TODAY;
        "Start Date" := TODAY;
    end;

    trigger OnModify()
    begin
        /*ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.",No);
        IF ImprestHeader.FINDFIRST THEN
          BEGIN
                IF (ImprestHeader.Status=ImprestHeader.Status::Approved) OR
                (ImprestHeader.Status=ImprestHeader.Status::Posted)OR
                (ImprestHeader.Status=ImprestHeader.Status::"Pending Approval") THEN
               ERROR('You Cannot Delete this record its status is not Pending');
          END;
          TESTFIELD(Committed,FALSE);
         */

    end;

    var
        HRSetup: Record "LBSL-HR Setup";
        NoSeriesMgt: Codeunit 396;
        UserSetup: Record "User Setup";
        //HREmp: Record "95575";
        BaseCalendarChange: Record "Base Calendar Change";
        ReturnDateLoop: Boolean;
        mSubject: Text[250];
        ApplicantsEmail: Text[30];
        SMTP: Codeunit "Email Message";
        "LineNo.": Integer;
        ApprovalComments: Record "Approval Comment Line";
        URL: Text[500];
        sDate: Record "Date";
        //Customized: Record "95614";
        HREmailParameters: Record "LBSL-HR E-Mail Parameters";
        TrapReq: Record "LBSL-HR Transport Requisition";
        mcontent: Label 'Status must be new on Transport Application No.';
        mcontent2: Label '. Please cancel the approval request and try again';
        DaysApplied: Integer;
        EmpRec: Record Employee;
        VehReq: Record "LBSL-HR Transport Vehicles";

    /*procedure DetermineTransportReturnDate(var fBeginDate: Date; var fDays: Decimal) fReturnDate: Date
    begin
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        REPEAT
          IF DetermineIfIncludesNonWorking("Leave Type") =FALSE THEN BEGIN
            fReturnDate := CALCDATE('1D', fReturnDate);
            IF DetermineIfIsNonWorking(fReturnDate) THEN
              varDaysApplied := varDaysApplied + 1
            ELSE
              varDaysApplied := varDaysApplied;
            varDaysApplied := varDaysApplied - 1
          END
          ELSE BEGIN
            fReturnDate := CALCDATE('1D', fReturnDate);
            varDaysApplied := varDaysApplied - 1;
          END;
        UNTIL varDaysApplied = 0;
        EXIT(fReturnDate);
        

    end;*/

    procedure DeterminethisTransportEndDate(var fDate: Date) fEndDate: Date
    begin
        // ReturnDateLoop := TRUE;
        // fEndDate := fDate;
        // IF fEndDate <> 0D THEN BEGIN
        //  fEndDate := CALCDATE('-1D', fEndDate);
        //  WHILE (ReturnDateLoop) DO BEGIN
        //  IF DetermineIfIsNonWorking(fEndDate) THEN
        //    fEndDate := CALCDATE('-1D', fEndDate)
        //   ELSE
        //    ReturnDateLoop := FALSE;
        //  END
        //  END;
        // EXIT(fEndDate);
    end;

    procedure CreateTransportLedgerEntries()
    begin



        EmpRec.Get("Employee No");
        EmpRec.TestField(EmpRec."Company E-Mail");

        RESET;
        SETRANGE(Selected, TRUE);
        IF FIND('-') THEN
            //REPEAT
            Selected := FALSE;
        MODIFY;

        //POPULATE JOURNAL LINES
        // LeaveGjline.RESET;
        // LeaveGjline.SETRANGE("Journal Template Name",'ISSUE');
        // LeaveGjline.SETRANGE("Journal Batch Name",'LEAVE');
        // LeaveGjline.DELETEALL;
        //
        //
        // "LineNo.":=10000;
        // LeaveGjline.INIT;
        // LeaveGjline."Journal Template Name":='ISSUE';
        // LeaveGjline."Journal Batch Name":='LEAVE';
        // LeaveGjline."Line No.":="LineNo.";
        // LeaveGjline."Leave Period":='2013';
        // LeaveGjline."Document No.":="Application Code";
        // LeaveGjline."Staff No.":="Employee No";
        // //LeaveGjline."Staff Name"
        // LeaveGjline.VALIDATE(LeaveGjline."Staff No.");
        // LeaveGjline."Posting Date":=TODAY;
        // LeaveGjline."Leave Entry Type":=LeaveGjline."Leave Entry Type"::Negative;
        // LeaveGjline."Leave Approval Date":=TODAY;
        // LeaveGjline.Description:='Leave Taken';
        //LeaveGjline."Leave Type":="Leave Type";
        //------------------------------------------------------------
        // HRSetup.RESET;
        // HRSetup.FIND('-');
        // HRSetup.TESTFIELD(HRSetup."Leave Posting Period[FROM]");
        // HRSetup.TESTFIELD(HRSetup."Leave Posting Period[TO]");
        // //------------------------------------------------------------
        // LeaveGjline."Leave Period Start Date":=HRSetup."Leave Posting Period[FROM]";
        // LeaveGjline."Leave Period End Date":=HRSetup."Leave Posting Period[TO]";
        // //--------------------------------------------------------------------------
        // ApprovalComments.RESET;
        // ApprovalComments.SETRANGE(ApprovalComments."Document No.","Application Code");
        // ApprovalComments.SETRANGE(ApprovalComments."User ID",Supervisor);
        // IF ApprovalComments.FIND('-') THEN
        //ApprovalComments.TESTFIELD(ApprovalComments."Aproved Days");

        //LeaveGjline."No. of Days":=ApprovalComments."Approved Days";

        //MESSAGE(FORMAT(ApprovalComments."Approved Days"));

        //LeaveGjline.INSERT(TRUE);
        //MESSAGE('Lines copied to HR Journal');


        //Post Journal

        // LeaveGjline.RESET;
        // LeaveGjline.SETRANGE("Journal Template Name",'ISSUE');
        // LeaveGjline.SETRANGE("Journal Batch Name",'LEAVE');
        // IF LeaveGjline.FIND('-') THEN BEGIN
        // CODEUNIT.RUN(CODEUNIT::"HR Leave Jnl.-Post",LeaveGjline);
        // END;

        /*END ELSE BEGIN
        ERROR('You must specify no of days');
        END;
        END;*/
        //NotifyApplicant;

    end;

    /* procedure NotifyApplicant()
    begin
        HREmp.GET("Employee No");

        //GET E-MAIL PARAMETERS FOR GENERAL E-MAILS
        HREmailParameters.RESET;
        HREmailParameters.SETRANGE(HREmailParameters."Associate With", HREmailParameters."Associate With"::General);
        IF HREmailParameters.FIND('-') THEN BEGIN
            //REPEAT
            HREmp.TESTFIELD(HREmp."Company E-Mail");
            SMTP.CreateMessage(HREmailParameters."Sender Name", HREmailParameters."Sender Address", HREmp."Company E-Mail",
            HREmailParameters.Subject, 'Dear' + ' ' + HREmp."First Name" + ' ' +
            HREmailParameters.Body + ' ' + "Application Code" + ' ' + HREmailParameters."Body 2", TRUE);
            SMTP.Send();
            //UNTIL HREmp.NEXT=0;

            MESSAGE('Transport Requester has been notified');
        END;
    end; */
}

