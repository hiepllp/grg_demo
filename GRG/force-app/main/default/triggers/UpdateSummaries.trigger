/*
* Apex trigger that fires when milestones are updated, created, delted.
* Summarizes the Planned Revenue on Project
*/
trigger UpdateSummaries on pse__Milestone__c (after delete, after insert, after undelete, after update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        if(trigger.isDelete) {
            PSACostAndRevenuePlan.summarizeMilestones(trigger.old);
        } else
            PSACostAndRevenuePlan.summarizeMilestones(trigger.new);
    }
}