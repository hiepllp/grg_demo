global class DateMoveTimecards implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__End_Date__c, pse__Start_Date__c, pse__Billed__c, pse__Invoiced__c, pse__Admin_Global_Edit__c, pse__Audit_Notes__c FROM pse__Timecard_Header__c WHERE pse__Billed__c = false AND pse__Invoiced__c = false';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Timecard Date Shift';

    List<pse__Timecard_Header__c> recordsToUpdate = new List<pse__Timecard_Header__c>();
    
    global DateMoveTimecards(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Timecard_Header__c> scope)
    {
        for(pse__Timecard_Header__c e: scope)
        {
            //timecards cannot be updated if the split has been billed
            List<pse__Timecard__c> checkForBilled = [SELECT Id FROM pse__Timecard__c WHERE pse__Timecard_Header__c =: e.id AND pse__Invoice_Transaction__c != null];
            //this makes sure that there are no billed splits
            IF(checkForBilled.size() == 0)
            {
                e.pse__End_Date__c += DAYSMOVED;
                e.pse__Start_Date__c += DAYSMOVED;
                e.pse__Admin_Global_Edit__c = true;
                e.pse__Audit_Notes__c = AUDITNOTES;
    
                update e;
            }
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
    	{
            DateMoveTimecardSplit batch = new DateMoveTimecardSplit(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}