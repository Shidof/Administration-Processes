page 50202 "LBSL HR-Transport Vehicles"
{
    PageType = List;
    SourceTable = "LBSL-HR Transport Vehicles";
    Caption = 'HR Vehicles';
    ApplicationArea = All;
    UsageCategory = Administration;



    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Registration No"; Rec."Registration No")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

