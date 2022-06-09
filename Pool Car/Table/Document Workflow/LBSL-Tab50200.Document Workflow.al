table 50200 "Document Workflow"
{

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Table No."; Integer)
        {
            TableRelation = AllObj."Object ID" WHERE("Object Type" = FILTER(Table));

            trigger OnValidate()
            begin
                IF AllObj.GET(AllObj."Object Type"::Table, "Table No.") THEN
                    "Table Name" := AllObj."Object Name"
                ELSE
                    "Table Name" := '';
            end;
        }
        field(3; "Table Name"; Text[30])
        {
        }
        field(4; "1st Approver"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(5; "2nd Approver"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(6; "3rd Approver"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(7; "4th Approver"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(8; Enable; Boolean)
        {

            trigger OnValidate()
            begin

                IF "1st Approver" = '' THEN
                    ERROR('At least one approver must be configured for you. Contact your system administrator!');
            end;
        }
        field(9; "5th Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(10; "6th Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(11; "7th Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
    }

    keys
    {
        key(Key1; "User ID", "Table No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AllObj: Record "AllObj";
}

