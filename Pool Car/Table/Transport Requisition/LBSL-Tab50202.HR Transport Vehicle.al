table 50202 "LBSL-HR Transport Vehicles"
{
    DrillDownPageID = "LBSL HR-Transport Vehicles";
    LookupPageID = "LBSL HR-Transport Vehicles";

    fields
    {
        field(1; "Registration No"; Code[20])
        {
        }
        field(2; Name; Text[50])
        {
        }
        field(3; Model; Text[70])
        {
        }
    }

    keys
    {
        key(Key1; "Registration No")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Registration No", Name, Model)
        {
        }
    }

    var
        //HREmp: Record "95575";
        HRTransportRequests: Record "LBSL-HR Transport Requisition";
}

