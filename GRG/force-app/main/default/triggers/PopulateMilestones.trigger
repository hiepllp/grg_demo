/*
* Apex trigger that fires when projects are created
* Creates Milestones for Fixed Price Projects.
*/
trigger PopulateMilestones on pse__Proj__c (after insert) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        PSACostAndRevenuePlan.createMilestones(trigger.new);
    }
}