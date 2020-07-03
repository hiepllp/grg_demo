/*
* Apex trigger that fires when rOLI are created, updated, deleted.
* Synchs the milestones with the OLIs
*/
trigger UpdateMilestones on OpportunityLineItem (after delete, after insert, after update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        PSACostAndRevenuePlan.updateMilestones(trigger.oldMap, trigger.newMap, trigger.isInsert, trigger.isUpdate, trigger.isDelete);
    }
}