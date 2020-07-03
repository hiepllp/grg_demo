global class DateMoveRateCard implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Start_Date__c , pse__End_Date__c FROM pse__Rate_Card__c ';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Rate_Card__c > recordsToUpdate = new List<pse__Rate_Card__c >();
    
    global DateMoveRateCard(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Rate_Card__c > scope)
    {
        for(pse__Rate_Card__c  e: scope)
        {
            IF(e.pse__Start_Date__c  != null)
            e.pse__Start_Date__c  += DAYSMOVED;
            
            IF(e.pse__End_Date__c != null)
            e.pse__End_Date__c += DAYSMOVED;
                  
            recordsToUpdate.add(e);
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveBudget batch = new DateMoveBudget(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}