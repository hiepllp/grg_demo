global class DateMoveScheduleExc implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__End_Date__c ,pse__Date__c FROM pse__Schedule_Exception__c ORDER BY pse__End_Date__c DESC' ;

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';
    
    global DateMoveScheduleExc(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Schedule_Exception__c> scope)
    {
        for(pse__Schedule_Exception__c s: scope)
        {
            s.pse__End_Date__c += DAYSMOVED;
            s.pse__Date__c += DAYSMOVED;
        }    
        update scope;
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
                DateMoveScheduleStart batch = new DateMoveScheduleStart(DAYSMOVED);
                Id batchId = database.executeBatch(batch, 10 );
        }

    }
}