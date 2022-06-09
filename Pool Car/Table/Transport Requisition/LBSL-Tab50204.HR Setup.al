table 50204 "LBSL-HR Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(3; "Training Application Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(4; "Leave Application Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(6; "Disciplinary Cases Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(7; "Base Calendar"; Code[10])
        {
            TableRelation = "Base Calendar";
        }
        field(8; "Job ID Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(12; "Transport Allocation No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Transport Req Nos"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(14; "Employee Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(15; "Leave Posting Period[FROM]"; Date)
        {
        }
        field(16; "Leave Posting Period[TO]"; Date)
        {
        }
        field(17; "Job Application Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(18; "Exit Interview Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(19; "Appraisal Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(20; "Company Activities"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(21; "Default Leave Posting Template"; Code[10])
        {
            //TableRelation = "HR Leave Batches Lines"."Doucment No.";
        }
        field(22; "Default Leave Posting Batch"; Code[10])
        {
            TableRelation = "LBSL-HR Leave Batches Lines"."Line No.";
        }
        field(23; "Leave Template"; Code[10])
        {
            TableRelation = "LBSL-HR Leave Batches Lines"."Line No.";
        }
        field(24; "Leave Batch"; Code[10])
        {
            TableRelation = "LBSL-HR Leave Batches Lines"."Line No.";
        }
        field(25; "Job Interview Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(26; "Company Documents"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(27; "HR Policies"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(28; "Notice Board Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(29; "Vacation Reimbursable Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(30; "Leave Batch Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(31; "Travel Arrangement No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(32; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(33; "Induction No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(34; "DE Team E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(35; "SO Team E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(36; "CIS Team E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(37; "FA Team E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(38; "DS Team E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(39; "HR Team E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(40; "ID Card Request No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(41; "Article No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(42; "View Employee Records"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "HOD Finance Email"; Text[50])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(44; "CEO Email"; Text[50])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(45; "HOD Finance Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(46; "HOD Finance User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                UserSetup.RESET;
                IF UserSetup.GET("HOD Finance User ID") THEN
                    "HOD Finance Full Name" := UserSetup."Full Name"
                ELSE
                    "HOD Finance Full Name" := '';
            end;
        }
        field(47; "CEO Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(48; "CEO User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                UserSetup.RESET;

                IF UserSetup.GET("CEO User ID") THEN
                    "CEO Full Name" := UserSetup."Full Name"
                ELSE
                    "CEO Full Name" := '';
            end;
        }
        field(49; "PFA Batch Nos"; Code[20])
        {
            Caption = 'PFA Batch Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50; "HOD Finance First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "CEO First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52; "HR Manager First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(53; "HR Manager E-mail"; Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(54; "HR Manager Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "HR Manager ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                UserSetup.RESET;
                IF UserSetup.GET("HR Manager ID") THEN
                    "HR Manager Full Name" := UserSetup."Full Name"
                ELSE
                    "HR Manager Full Name" := '';
            end;
        }
        field(56; "Finance Officer Email"; Text[50])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(57; "Finance Officer Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(58; "Finance Officer User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                UserSetup.RESET;
                IF UserSetup.GET("Finance Officer User ID") THEN
                    "Finance Officer Full Name" := UserSetup."Full Name"
                ELSE
                    "Finance Officer Full Name" := '';
            end;
        }
        field(59; "Finance Officer First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Fin Officer Signature"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(61; "MD Signature"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(62; "HRM Signature"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(63; "Main Currency Unit"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(64; "Currency Fractional Unit"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Admin Officer First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(66; "Admin Officer E-mail"; Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(67; "Admin Officer Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(68; "Admin Officer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                UserSetup.RESET;
                IF UserSetup.GET("Admin Officer ID") THEN
                    "Admin Officer Full Name" := UserSetup."Full Name"
                ELSE
                    "Admin Officer Full Name" := '';
            end;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        UserSetup: Record "User Setup";
}

