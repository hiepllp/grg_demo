global class DateMoveUtilization implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Historical_End_Date__c, pse__Historical_Start_Date__c, pse__Scheduled_End_Date__c, pse__Scheduled_Start_Date__c FROM pse__Utilization_Detail__c';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Utilization_Detail__c> recordsToUpdate = new List<pse__Utilization_Detail__c>();
    
    global DateMoveUtilization(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Utilization_Detail__c> scope)
    {
        for(pse__Utilization_Detail__c e: scope)
        {
            IF(e.pse__Historical_End_Date__c < Date.Today().addDays(-DAYSMOVED))
            {
                IF(e.pse__Historical_End_Date__c != null)
                e.pse__Historical_End_Date__c += DAYSMOVED;
                
                IF(e.pse__Historical_Start_Date__c != null)
                e.pse__Historical_Start_Date__c += DAYSMOVED;
    
                IF(e.pse__Scheduled_End_Date__c != null)
                e.pse__Scheduled_End_Date__c += DAYSMOVED;
    
                IF(e.pse__Scheduled_Start_Date__c != null)
                e.pse__Scheduled_Start_Date__c += DAYSMOVED;
                
                recordsToUpdate.add(e);         
            }
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
        {
            DateMoveUtilCalc batch = new DateMoveUtilCalc(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}