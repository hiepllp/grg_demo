trigger ProjectTaskSharing on pse__Project_Task__c (before insert, before update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c)
    {
        for(pse__Project_Task__c pt : Trigger.New)
        {
            IF(pt.Account_Name__c == null)
            {
                pt.Account_Name__c = [SELECT ID, pse__Account__r.Name FROM pse__Proj__c WHERE id =: pt.pse__Project__c LIMIT 1].pse__Account__r.Name;
            }
        }
    }
}