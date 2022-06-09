table 50203 "LBSL Document Approval Entry"
{
    DrillDownPageID = "LBSL-Document Approval Entries";
    LookupPageID = "LBSL-Document Approval Entries";

    fields
    {
        field(1; Sequence; Integer)
        {
        }
        field(2; "Table No."; Integer)
        {
        }
        field(3; "Document No."; Code[10])
        {
        }
        field(4; Sender; Code[50])
        {
        }
        field(5; Approver; Code[50])
        {
        }
        field(7; "Approval Status"; Option)
        {
            OptionCaption = ' ,Pending,Approved,Rejected';
            OptionMembers = " ",Pending,Approved,Rejected;
        }
        field(8; "Record ID to Approve"; RecordID)
        {
        }
        field(9; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Document Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Document Date & Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Sequence, "Document No.")
        {
        }
        key(Key2; "Document No.", "Approval Status", Approver)
        {
        }
    }

    fieldgroups
    {
    }

    var
        PageManagement: Codeunit 700;

    procedure ShowRecord()
    var
        RecRef: RecordRef;
    begin
        IF NOT RecRef.GET("Record ID to Approve") THEN
            EXIT;
        RecRef.SETRECFILTER;
        PageManagement.PageRun(RecRef);
    end;
}

