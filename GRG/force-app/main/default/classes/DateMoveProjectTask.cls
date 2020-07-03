global class DateMoveProjectTask implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Actual_End_Date_Time__c , pse__Actual_Start_Date_Time__c , pse__End_Date_Time__c , pse__Start_Date_Time__c  FROM pse__Project_Task__c WHERE pse__Project__c != null AND pse__Summary__c = false';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';
    
    global DateMoveProjectTask(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Project_Task__c> scope)
    {
        for(pse__Project_Task__c e: scope)
        {
            IF(e.pse__Actual_End_Date_Time__c  != null)
            e.pse__Actual_End_Date_Time__c  += DAYSMOVED;
            
            IF(e.pse__Actual_Start_Date_Time__c  != null)
            e.pse__Actual_Start_Date_Time__c  += DAYSMOVED;

            IF(e.pse__End_Date_Time__c  != null)
            e.pse__End_Date_Time__c  += DAYSMOVED;

            IF(e.pse__Start_Date_Time__c  != null)
            e.pse__Start_Date_Time__c  += DAYSMOVED;
                        
            update e;         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
    	{
            DateMoveTaskTime batch = new DateMoveTaskTime(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}