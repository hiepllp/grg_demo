global class DateMoveMissingTime implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Date_Timecard_Entered__c, pse__End_Date__c, pse__Start_Date__c FROM pse__Missing_Timecard__c';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Missing_Timecard__c> recordsToUpdate = new List<pse__Missing_Timecard__c>();
    
    global DateMoveMissingTime(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Missing_Timecard__c> scope)
    {
        for(pse__Missing_Timecard__c e: scope)
        {
            IF(e.pse__Date_Timecard_Entered__c != null)
            e.pse__Date_Timecard_Entered__c += DAYSMOVED;
            
            IF(e.pse__End_Date__c != null)
            e.pse__End_Date__c += DAYSMOVED;
            
            IF(e.pse__Start_Date__c != null)
            e.pse__Start_Date__c += DAYSMOVED;
      
            recordsToUpdate.add(e);
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveBillingEvent batch = new DateMoveBillingEvent(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}