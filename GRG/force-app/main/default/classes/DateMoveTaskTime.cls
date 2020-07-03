global class DateMoveTaskTime implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Start_Date__c FROM pse__Task_Time__c';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Task_Time__c> recordsToUpdate = new List<pse__Task_Time__c>();
    
    global DateMoveTaskTime(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Task_Time__c> scope)
    {
        for(pse__Task_Time__c e: scope)
        {
            e.pse__Start_Date__c += DAYSMOVED;

            recordsToUpdate.add(e);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveContact batch = new DateMoveContact(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}