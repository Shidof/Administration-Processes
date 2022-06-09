table 50211 "LBSL-HR Drivers"
{
    DrillDownPageID = "LBSL-HRDrivers List";
    LookupPageID = "LBSL-HRDrivers List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                //HREmp.RESET;
                //HREmp.GET(Code);
                //"Driver Name":=HREmp."First Name"+' '+HREmp."Middle Name"+' '+HREmp."Last Name";

                IF UserSetup.GET(Code) THEN
                    "Driver Name" := UserSetup."Full Name";
                "Email Address" := UserSetup."E-Mail";

            end;
        }
        field(2; "Driver Name"; Text[100])
        {
        }
        field(3; "Driver License Number"; Code[20])
        {
        }
        field(4; "Last License Renewal"; Integer)
        {
        }
        field(5; "Renewal Interval"; Option)
        {
            OptionMembers = " ",Days,Weeks,Months,Quarterly,Years;

            //"Next License Renewal" := CALCDATE("Renewal Interval Value","Renewal Interval");


        }
        field(6; "Renewal Interval Value"; DateFormula)
        {

            trigger OnValidate()
            begin
                /*StrValue:='D';
                
                IF "Renewal Interval"="Renewal Interval"::Days THEN
                  BEGIN
                    StrValue:='D';
                  END
                ELSE IF "Renewal Interval"="Renewal Interval"::Weeks THEN
                  BEGIN
                    StrValue:='W';
                  END
                ELSE IF "Renewal Interval"="Renewal Interval"::Months THEN
                  BEGIN
                    StrValue:='M';
                  END
                ELSE IF "Renewal Interval"="Renewal Interval"::Quarterly THEN
                  BEGIN
                    StrValue:='Q';
                  END
                ELSE IF "Renewal Interval"="Renewal Interval"::Years THEN
                  BEGIN
                    StrValue:='Y';
                  END;
                
                "Next License Renewal":= CALCDATE(FORMAT("Renewal Interval Value") + StrValue , "Last License Renewal");
                */

            end;
        }
        field(7; "Next License Renewal"; Date)
        {
        }
        field(8; "Year Of Experience"; Decimal)
        {
        }
        field(9; Grade; Code[20])
        {
        }
        field(10; Active; Boolean)
        {
        }
        field(11; "Email Address"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Active := TRUE;
    end;

    var
        //HREmp: Record "95575";
        UserSetup: Record "User Setup";
}

