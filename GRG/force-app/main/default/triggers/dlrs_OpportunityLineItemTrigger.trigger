/**
* Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
**/
trigger dlrs_OpportunityLineItemTrigger on OpportunityLineItem
(before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        dlrs.RollupService.triggerHandler();
    }
}