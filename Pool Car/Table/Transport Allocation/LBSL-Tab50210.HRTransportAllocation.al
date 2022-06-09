table 50210 "LBSL-HRTransport Allocations"
{
    LookupPageID = "LBSL-HRTransport Allocation";

    fields
    {
        field(1; "Transport Allocation No"; Code[20])
        {
            Editable = false;
        }
        field(2; "Transport Request No"; Code[20])
        {
            TableRelation = "LBSL-HR Transport Requisition"."Application Code" WHERE(Status = CONST(Approved),
                                                                                 "Allocation Status" = FILTER(<> Allocated));

            trigger OnValidate()
            begin
                IF (Rec."Transport Request No" <> xRec."Transport Request No") AND (TrnsptRequest.GET("Transport Request No")) THEN BEGIN
                    "Trip Description" := 'From ' + TrnsptRequest."From Destination" + ' to ' + TrnsptRequest."To Destination" + ' and return';
                    "Date of Trip" := TrnsptRequest."Start Date";
                    "Purpose of Trip" := TrnsptRequest."Purpose of Trip";
                    "Time of Trip" := TrnsptRequest."Time of Trip";
                    "No of Hrs Requested" := TrnsptRequest."No. of Hours";
                    "Pick up point" := TrnsptRequest."Pickup Point";
                END;
            end;
        }
        field(3; "Trip Description"; Text[100])
        {
            Editable = false;
        }
        field(4; "Vehicle Reg Number"; Code[20])
        {
            TableRelation = "LBSL-HR Transport Vehicles"."Registration No";
        }
        field(5; "Assigned Driver"; Code[20])
        {
            TableRelation = "LBSL-HR Drivers" WHERE(Active = const(true));



            trigger OnValidate()
            begin
                HRDrivers.RESET;
                HRDrivers.SETFILTER(Code, "Assigned Driver");
                IF HRDrivers.FINDFIRST THEN
                    "Driver Name" := HRDrivers."Driver Name";
            end;
        }
        field(7; "Date of Allocation"; Date)
        {
        }
        field(8; "Vehicle Allocated by"; Code[20])
        {
        }
        field(9; "Opening Odometer Reading"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(10; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,Released,Returned,Closed,Cancelled;
        }
        field(13; "Date of Trip"; Date)
        {
            Editable = false;
        }
        field(14; "Purpose of Trip"; Text[250])
        {
            Editable = false;
        }
        field(60; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(61; Comments; Text[250])
        {
        }
        field(63; "Driver Name"; Text[100])
        {
        }
        field(66; "Time out"; Time)
        {
        }
        field(67; "Time In"; Time)
        {
        }
        field(69; "Time of Trip"; Time)
        {
            Editable = false;
        }
        field(70; "Closing Odometer Reading"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(72; "No of Hrs Requested"; Integer)
        {
            Editable = false;
        }
        field(73; "Authorized  By"; Code[20])
        {
        }
        field(76; "Pick up point"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Transport Allocation No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Transport Allocation No" = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Transport Allocation No");
            NoSeriesMgt.InitSeries(HRSetup."Transport Allocation No", xRec."No. Series", 0D, "Transport Allocation No", "No. Series");
        END;

        "Authorized  By" := USERID;
        "Date of Allocation" := TODAY;
    end;

    var
        Text0001: Label 'You cannot modify an Approved or Closed Record';
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        HRSetup: Record "LBSL-HR Setup";
        NoSeriesMgt: Codeunit 396;
        HRDrivers: Record "LBSL-HR Drivers";
        TrnsptRequest: Record "LBSL-HR Transport Requisition";
}

