global class DateMoveTimecardSplit implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Billed__c, pse__Billing_Event__c,  pse__End_Date__c, pse__Invoiced__c, pse__Start_Date__c, pse__Timecard_Header__c, pse__Invoice_Transaction__c FROM pse__Timecard__c WHERE pse__Billed__c = false AND pse__Invoiced__c = false AND pse__Billing_Event__c = null AND pse__Timecard_Header__r.pse__Assignment__r.pse__Schedule__c != null AND pse__Invoice_Transaction__c = null';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Timecard__c> recordsToUpdate = new List<pse__Timecard__c>();
    
    global DateMoveTimecardSplit(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Timecard__c> scope)
    {
        for(pse__Timecard__c e: scope)
        {
            e.pse__End_Date__c += DAYSMOVED;
            e.pse__Start_Date__c += DAYSMOVED;
            
            recordsToUpdate.add(e);
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
        {
            DateMoveMissingTime batch = new DateMoveMissingTime(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}