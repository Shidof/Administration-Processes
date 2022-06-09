page 50205 "LBSL-Document Approval Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = "LBSL Document Approval Entry";
    SourceTableView = SORTING(Sequence, "Document No.")
                      ORDER(Ascending)
                      WHERE("Approval Status" = FILTER(<> Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                    Caption = 'Table No.';
                    ToolTip = 'Specifies the record Table No.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the record Document No.';
                }
                field(Sender; Rec.Sender)
                {
                    ApplicationArea = All;
                    Caption = 'Sender';
                    ToolTip = 'Specifies the Sender';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the record Document Date';
                }
                field("Document Amount"; Rec."Document Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Document Amount';
                    ToolTip = 'Specifies the record Document Amount';
                }
                field("Document Description"; Rec."Document Description")
                {
                    ApplicationArea = All;
                    Caption = 'Document Description';
                    ToolTip = 'Specifies the record Document Description';
                }
                field(Approver; Rec.Approver)
                {
                    ApplicationArea = All;
                    Caption = 'Approver';
                    ToolTip = 'Specifies the record Approver';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the record Approval Status';
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    Caption = 'Sequence';
                    ToolTip = 'Specifies the record sequence of approval';
                }
            }
        }

        area(factboxes)
        {
            part(Change; "Workflow Change List FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                UpdatePropagation = SubPart;
            }
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                Image = View;
                action("View Record to Approve")
                {
                    ApplicationArea = Suite;
                    Caption = 'View Record to Approve';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Open the document that the approval request is for.';

                    trigger OnAction()
                    begin
                        Rec.ShowRecord;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View or add comments.';
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                    begin
                    end;
                }
                action("O&verdue Entries")
                {
                    ApplicationArea = Suite;
                    Caption = 'O&verdue Entries';
                    Image = OverdueEntries;
                    ToolTip = 'View approval requests that are overdue.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.SETFILTER("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Pending);
                        Rec.SETFILTER("Document Date", '<%1', TODAY);
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Delegate")
            {
                AccessByPermission = TableData 454 = M;
                ApplicationArea = Suite;
                Caption = '&Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Delegate the approval request to another approver that has been set up as your substitute approver.';
                Visible = false;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RecRef: RecordRef;
    begin
    end;

    trigger OnOpenPage()
    begin
        IF Usersetup.GET(USERID) THEN
            Rec.SETCURRENTKEY("Document No.", "Approval Status", Approver);
        Rec.SETRANGE(Approver, Usersetup."User ID");
        Rec.SETRANGE("Approval Status", Rec."Approval Status"::Pending);
    end;

    var
        Usersetup: Record "User Setup";
}

