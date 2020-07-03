public class DashboardComponentController {
    public String Component1Id {get;set;}
    public String Component2Id {get;set;}
    public String Component3Id {get;set;}
    public String Component4Id {get;set;}
    public String Component5Id {get;set;}
    public String Component6Id {get;set;}
    public String Component7Id {get;set;}
    public String Component8Id {get;set;}
    public String Component9Id {get;set;}
    public String Component10Id {get;set;}
    public String Component11Id {get;set;}
    public String Component12Id {get;set;}
    public String Component13Id {get;set;}
    public String Component14Id {get;set;}
    
    public DashboardComponentController(){
        List<Reporting_Dashboard__c > DashboardIds = [SELECT Id, Component_1_id__c, Component_2_id__c, Component_3_id__c, Component_4_id__c, Component_5_id__c, Component_6_id__c, Component_7_id__c, Component_8_id__c, Component_9_id__c, Component_10_id__c, Component_11_id__c, Component_12_id__c, Component_13_id__c, Component_14_Id__c FROM Reporting_Dashboard__c LIMIT 1];
        Component1Id = DashboardIds[0].Component_1_id__c;
        Component2Id = DashboardIds[0].Component_2_id__c;
        Component3Id = DashboardIds[0].Component_3_id__c;
        Component4Id = DashboardIds[0].Component_4_id__c;
        Component5Id = DashboardIds[0].Component_5_id__c;
        Component6Id = DashboardIds[0].Component_6_id__c;
        Component7Id = DashboardIds[0].Component_7_id__c;
        Component8Id = DashboardIds[0].Component_8_id__c;
        Component9Id = DashboardIds[0].Component_9_id__c;
        Component10Id = DashboardIds[0].Component_10_id__c;
        Component11Id = DashboardIds[0].Component_11_id__c;
        Component12Id = DashboardIds[0].Component_12_id__c;
        Component13Id = DashboardIds[0].Component_13_id__c;
        Component14Id = DashboardIds[0].Component_14_id__c;
    }
  

}