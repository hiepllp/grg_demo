global class DateMoveAssignments implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Assignment_Daily_Notes_Last_Updated__c, pse__Resource_Cost_Rate_Date__c, pse__Schedule__c FROM pse__Assignment__c WHERE pse__Schedule__c  != null';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Assignment__c> recordsToUpdate = new List<pse__Assignment__c>();
    
    global DateMoveAssignments(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Assignment__c> scope)
    {
        for(pse__Assignment__c a: scope)
        {
            IF(a.pse__Assignment_Daily_Notes_Last_Updated__c != null)
            a.pse__Assignment_Daily_Notes_Last_Updated__c += DAYSMOVED;

            IF(a.pse__Resource_Cost_Rate_Date__c != null)
            a.pse__Resource_Cost_Rate_Date__c += DAYSMOVED;

            recordsToUpdate.add(a);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveExpenseReport batch = new DateMoveExpenseReport(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}