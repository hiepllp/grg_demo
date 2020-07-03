/*
* Apex trigger that fires when resource requests are updated.
* Updates summary fields on the opportunity.
*/
trigger ResourceRequestUpdateOpportunitiesTrigger on pse__Resource_Request__c (after delete, after insert, after undelete, after update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        if (Trigger.isDelete){
            PSACostAndRevenuePlan.updateOpportunitiesFromResourceRequests(Trigger.old);
        } else {
            PSACostAndRevenuePlan.updateOpportunitiesFromResourceRequests(Trigger.new);
        }
    }
}