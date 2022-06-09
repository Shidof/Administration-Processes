page 50215 "HRSetup List"
{
    CardPageID = "LBSL-HR Setup";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Administration';
    RefreshOnActivate = false;
    SourceTable = "LBSL-HR Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'HR Setup';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leave Posting Period[FROM]"; Rec."Leave Posting Period[FROM]")
                {
                    ApplicationArea = All;
                }
                field("Leave Posting Period[TO]"; Rec."Leave Posting Period[TO]")
                {
                    ApplicationArea = All;
                }
                field("Default Leave Posting Template"; Rec."Default Leave Posting Template")
                {
                    ApplicationArea = All;
                }
                field("Default Leave Posting Batch"; Rec."Default Leave Posting Batch")
                {
                    ApplicationArea = All;
                }
                field("Training Application Nos."; Rec."Training Application Nos.")
                {
                    ApplicationArea = All;
                }
                field("Leave Application Nos."; Rec."Leave Application Nos.")
                {
                    ApplicationArea = All;
                }
                field("Disciplinary Cases Nos."; Rec."Disciplinary Cases Nos.")
                {
                    ApplicationArea = All;
                }
                field("Transport Req Nos"; Rec."Transport Req Nos")
                {
                    ApplicationArea = All;
                }
                field("Employee Requisition Nos."; Rec."Employee Requisition Nos.")
                {
                    ApplicationArea = All;
                }
                field("Job Application Nos"; Rec."Job Application Nos")
                {
                    ApplicationArea = All;
                }
                field("Exit Interview Nos"; Rec."Exit Interview Nos")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Nos"; Rec."Appraisal Nos")
                {
                    ApplicationArea = All;
                }
                field("Company Activities"; Rec."Company Activities")
                {
                    ApplicationArea = All;
                }
                field("Job Interview Nos"; Rec."Job Interview Nos")
                {
                    ApplicationArea = All;
                }
                field("Leave Batch Nos"; Rec."Leave Batch Nos")
                {
                    ApplicationArea = All;
                }
                field("Base Calendar"; Rec."Base Calendar")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            /*  action("HR Policies")
             {
                 Caption = 'HR Policies';
                 Image = Planning;
                 Promoted = true;
                 PromotedCategory = Category4;
                 RunObject = Page 95580;
             } */
            action("E-Mail Parameters")
            {/* 
                Caption = 'E-Mail Parameters';
                Image = Email;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 95612; */
            }
            action(Calendar)
            {
                Caption = 'Calendar';
                Image = Calendar;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 7600;
            }
            /*  action("Leave Periods")
             {
                 Caption = 'Leave Periods';
                 Image = AccountingPeriods;
                 Promoted = true;
                 PromotedCategory = Category4;
                 RunObject = Page 95652;
             } */
        }
    }

    trigger OnOpenPage()
    begin

        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;
}

