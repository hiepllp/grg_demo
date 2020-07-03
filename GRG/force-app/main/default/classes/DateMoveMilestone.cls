global class DateMoveMilestone implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Actual_Date__c, pse__Target_Date__c, pse__Admin_Global_Edit__c, pse__Audit_Notes__c, pse__Billed__c, pse__Invoiced__c  FROM pse__Milestone__c WHERE pse__Billed__c = false AND pse__Invoiced__c = false';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';
    
    global DateMoveMilestone(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Milestone__c> scope)
    {
        for(pse__Milestone__c e: scope)
        {
            IF(e.pse__Actual_Date__c != null)
            e.pse__Actual_Date__c += DAYSMOVED;
            
            IF(e.pse__Target_Date__c != null)
            e.pse__Target_Date__c += DAYSMOVED;
            
            e.pse__Admin_Global_Edit__c = true;
            e.pse__Audit_Notes__c = AUDITNOTES;

        }    
        update scope;
    }   
    global void finish(Database.BatchableContext BC)
    {        
        if(!Test.isRunningTest())
    	{
            DateMoveMiscAdj batch = new DateMoveMiscAdj(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}