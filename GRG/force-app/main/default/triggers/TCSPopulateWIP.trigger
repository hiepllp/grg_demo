//Populates Timecard with WIP Recognition Template
trigger TCSPopulateWIP on pse__Timecard__c (Before Insert, Before Update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        for(pse__Timecard__c t: Trigger.New)
        {
            List<pse__Proj__c> Projects = [SELECT ID, ffpsai__ServicesProduct__c, pse__Region__r.Name, pse__Practice__r.Name, pse__Group__r.Name FROM pse__Proj__c WHERE ffpsai__ServicesProduct__r.Name = 'SVCS: Professional Services WIP'];
            
            for(pse__Proj__c pr :Projects)
            {
                if(t.pse__Project__c == pr.Id)
                {
                    t.Include_in_Rev_Rec__c = true;
                    t.Product__c = 'SVCS: Professional Services WIP';
                    t.Project_Region__c = pr.pse__Region__r.Name;
                    t.Project_Practice__c = pr.pse__Practice__r.Name;
                    t.Project_Group__c = pr.pse__Group__r.Name;
                    t.Revenue_General_Ledger_Account__c = '1320 - WIP';
                }
            }
        }
    }
}