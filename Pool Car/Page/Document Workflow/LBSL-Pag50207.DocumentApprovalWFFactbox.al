page 50207 "Document Approval WF FactBox"
{

    Caption = 'Document Approval Flows';
    PageType = CardPart;
    SourceTable = "LBSL Document Approval Entry";

    layout
    {
        area(content)
        {
            group(ContentArea)
            {
                field(DocumentHeading; DocumentHeading)
                {
                    ApplicationArea = Suite;
                    Caption = 'Document';
                    Editable = false;
                    ToolTip = 'Specifies the document that has been approved.';
                }
            }
            repeater(Group)
            {
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                }
                field(Sender; Rec.Sender)
                {
                    ApplicationArea = All;
                }
                field(Approver; Rec.Approver)
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Document Date & Time"; Rec."Document Date & Time")
                {
                    ApplicationArea = All;
                    Caption = 'Approved Date & Time';
                }
            }
        }
    }
    var
        DocumentHeading: Text[250];
        Text000: TextConst ENU = 'Document';

    local procedure GetDocumentHeading(DocApprovalEntry: Record "LBSL Document Approval Entry"): Text[50]
    var
        Heading: Text[50];
    begin

        Heading := Text000 + '-' + DocApprovalEntry."Document No.";
        EXIT(Heading);
    end;

    procedure UpdateApprovalEntriesFromSourceRecord(SourceRecordID: RecordID)
    var
        ApprovalEntry: Record "LBSL Document Approval Entry";
    begin
        Rec.SETRANGE("Record ID to Approve", SourceRecordID);
        ApprovalEntry.COPY(Rec);
        IF ApprovalEntry.FINDFIRST THEN
            Rec.SETFILTER(Approver, '<>%1', ApprovalEntry.Sender);
        IF Rec.FINDLAST THEN;
        CurrPage.UPDATE(FALSE);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        DocumentHeading := '';
        EXIT(Rec.FINDLAST);
    end;

    trigger OnAfterGetRecord()
    begin
        DocumentHeading := GetDocumentHeading(Rec);
    end;





}

