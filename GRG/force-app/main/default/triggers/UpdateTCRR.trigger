/*Populates Timecard with WIP Recognition Template*/
trigger UpdateTCRR on pse__Timecard__c (Before Insert, Before Update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        /*query for id of the "Timecard - WIP Revenue" Recognition Template*/
        List<ffrr__Template__c> rtList = [SELECT Id FROM ffrr__Template__c WHERE Name = 'Timecard - WIP Revenue' order by Name limit 1];
        ID rtId = null;
        if (rtList.size() > 0) rtId = rtList[0].Id;
        
        for (pse__Timecard__c  TCRT: Trigger.new){
            /*trigger fies if "Is Wip" is true*/
            if ( TCRT.Is_WIP__c ) TCRT.ffrrtemplate__c = rtId;
        }
    }
}