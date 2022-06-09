page 50203 "LBSL-HR Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = false;
    SourceTable = 50204;
    Caption = 'HR Setup';


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
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
                field("Transport Allocation No"; Rec."Transport Allocation No")
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
                field("Job ID Nos."; Rec."Job ID Nos.")
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
                field("Notice Board Nos."; Rec."Notice Board Nos.")
                {
                    ApplicationArea = All;
                }
                field("Company Documents"; Rec."Company Documents")
                {
                    ApplicationArea = All;
                }
                field("HR Policies"; Rec."HR Policies")
                {
                    ApplicationArea = All;
                }
                field("Vacation Reimbursable Nos."; Rec."Vacation Reimbursable Nos.")
                {
                    ApplicationArea = All;
                }
                field("Travel Arrangement No"; Rec."Travel Arrangement No")
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
                field("PFA Batch Nos"; Rec."PFA Batch Nos")
                {
                    ApplicationArea = All;
                }
            }
            group("Notification Details")
            {
                Caption = 'Notification Details';
                field("Finance Officer User ID"; Rec."Finance Officer User ID")
                {
                    ApplicationArea = All;
                }
                field("Finance Officer First Name"; Rec."Finance Officer First Name")
                {
                    ApplicationArea = All;
                }
                field("Finance Officer Full Name"; Rec."Finance Officer Full Name")
                {
                    ApplicationArea = All;
                }
                field("Finance Officer Email"; Rec."Finance Officer Email")
                {
                    ApplicationArea = All;
                }
                field("HOD Finance User ID"; Rec."HOD Finance User ID")
                {
                    ApplicationArea = All;
                }
                field("HOD Finance Full Name"; Rec."HOD Finance Full Name")
                {
                    ApplicationArea = All;
                }
                field("HOD Finance First Name"; Rec."HOD Finance First Name")
                {
                    ApplicationArea = All;
                }
                field("HOD Finance Email"; Rec."HOD Finance Email")
                {
                    ApplicationArea = All;
                }
                field("HR Manager ID"; Rec."HR Manager ID")
                {
                    ApplicationArea = All;
                }
                field("HR Manager Full Name"; Rec."HR Manager Full Name")
                {
                    ApplicationArea = All;
                }
                field("HR Manager First Name"; Rec."HR Manager First Name")
                {
                    ApplicationArea = All;
                }
                field("HR Manager E-mail"; Rec."HR Manager E-mail")
                {
                    ApplicationArea = All;
                }
                field("Admin Officer First Name"; Rec."Admin Officer First Name")
                {
                    ApplicationArea = All;
                }
                field("Admin Officer E-mail"; Rec."Admin Officer E-mail")
                {
                    ApplicationArea = All;
                }
                field("Admin Officer Full Name"; Rec."Admin Officer Full Name")
                {
                    ApplicationArea = All;
                }
                field("Admin Officer ID"; Rec."Admin Officer ID")
                {
                    ApplicationArea = All;
                }
                field("CEO User ID"; Rec."CEO User ID")
                {
                    ApplicationArea = All;
                }
                field("CEO Full Name"; Rec."CEO Full Name")
                {
                    ApplicationArea = All;
                }
                field("CEO First Name"; Rec."CEO First Name")
                {
                    ApplicationArea = All;
                }
                field("CEO Email"; Rec."CEO Email")
                {
                    ApplicationArea = All;
                }
                field("HR Team E-mail"; Rec."HR Team E-mail")
                {
                    ApplicationArea = All;
                }
            }
            group(Signatures)
            {
                Caption = 'Signatures';
                field("Fin Officer Signature"; Rec."Fin Officer Signature")
                {
                    ApplicationArea = All;
                }
                field("MD Signature"; Rec."MD Signature")
                {
                    ApplicationArea = All;
                }
                field("HRM Signature"; Rec."HRM Signature")
                {
                    ApplicationArea = All;
                }
            }
            group("Local Currency Details")
            {
                Caption = 'Local Currency Details';
                field("Main Currency Unit"; Rec."Main Currency Unit")
                {
                    Caption = 'Main Currency Unit Description';
                    ApplicationArea = All;
                }
                field("Currency Fractional Unit"; Rec."Currency Fractional Unit")
                {
                    Caption = 'Currency Fractional Unit Description';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
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

