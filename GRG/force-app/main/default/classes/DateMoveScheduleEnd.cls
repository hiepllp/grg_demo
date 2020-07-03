global class DateMoveScheduleEnd implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__End_Date__c ,pse__Start_Date__c FROM pse__Schedule__c' ;

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Schedule__c> recordsToUpdate = new List<pse__Schedule__c>();
    
    global DateMoveScheduleEnd(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Schedule__c> scope)
    {
        for(pse__Schedule__c s: scope)
        {
            s.pse__End_Date__c += DAYSMOVED;

            recordsToUpdate.add(s);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        if(!Test.isRunningTest())
    	{
                DateMoveScheduleExc batch = new DateMoveScheduleExc(DAYSMOVED);
                Id batchId = database.executeBatch(batch, 10 );
        }

    }
}