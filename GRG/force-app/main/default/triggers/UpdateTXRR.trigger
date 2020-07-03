/*Populates Transaction with WIP Recognition Template*/
trigger UpdateTXRR on pse__Transaction__c (Before Insert, Before Update) 
{
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        /*query for id of the "Timecard - WIP Costs" Recognition Template*/
        List<ffrr__Template__c> rtList = [SELECT Id FROM ffrr__Template__c WHERE Name = 'Timecard - WIP Costs' order by Name limit 1];
        ID rtId = null;
        if (rtList.size() > 0) rtId = rtList[0].Id;
        
        for (pse__Transaction__c  TXRT: Trigger.new){
            /*trigger fies if "Is Wip" is true*/
            if ( TXRT.Is_WIP__c ) TXRT.ffrrtemplate__c = rtId;
        }
    }
}