//this batch updates the timecard lines

global class MDOMoveTimecardSplitDates implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Billed__c, pse__Billing_Event__c,  pse__End_Date__c, pse__Invoiced__c, pse__Start_Date__c, pse__Timecard_Header__c FROM pse__Timecard__c WHERE pse__Billed__c = false AND pse__Invoiced__c = false AND pse__Billing_Event__c = null AND pse__Timecard_Header__r.pse__Assignment__r.pse__Schedule__c != null';

    private static final Integer DAYSMOVED = 91;
    private static final String AUDITNOTES = 'Date Shift';
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< pse__Timecard__c> scope)
    {
        for(pse__Timecard__c  t: scope)
        {
            t.pse__End_Date__c += DAYSMOVED;
            t.pse__Start_Date__c += DAYSMOVED;
        }
        update scope;

    }   
    global void finish(Database.BatchableContext BC)
    {
    }
}