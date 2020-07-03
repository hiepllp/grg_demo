global class DateMoveProjects implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id , pse__Actuals_Last_Update_Date__c, pse__Backlog_Last_Update_Date__c, pse__Billing_Eligible_Last_Updated__c, pse__Current_Time_Period_End_Date__c, pse__End_Date__c, pse__Scheduled_Backlog_Calculated_Date__c, pse__Scheduled_Backlog_End_Date__c, pse__Start_Date__c FROM pse__Proj__c';

    private Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';
    
    List<pse__Proj__c> recordsToUpdate = new List<pse__Proj__c>();

    global DateMoveProjects(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< pse__Proj__c> scope)
    {
        for(pse__Proj__c p: scope)
        {
            IF(p.pse__Actuals_Last_Update_Date__c != null)
            p.pse__Actuals_Last_Update_Date__c += DAYSMOVED;

            IF(p.pse__Backlog_Last_Update_Date__c != null)
            p.pse__Backlog_Last_Update_Date__c += DAYSMOVED;

            IF(p.pse__Billing_Eligible_Last_Updated__c != null)
            p.pse__Billing_Eligible_Last_Updated__c += DAYSMOVED;

            IF(p.pse__Current_Time_Period_End_Date__c != null)
            p.pse__Current_Time_Period_End_Date__c += DAYSMOVED;

            IF(p.pse__End_Date__c != null)
            p.pse__End_Date__c += DAYSMOVED;

            IF(p.pse__Scheduled_Backlog_Calculated_Date__c != null)
            p.pse__Scheduled_Backlog_Calculated_Date__c += DAYSMOVED;

            IF(p.pse__Scheduled_Backlog_End_Date__c != null)
            p.pse__Scheduled_Backlog_End_Date__c += DAYSMOVED;

            IF(p.pse__Start_Date__c != null)
            p.pse__Start_Date__c += DAYSMOVED;    
                        
            recordsToUpdate.add(p);
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveResourceRequests batch = new DateMoveResourceRequests(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }

    }
}