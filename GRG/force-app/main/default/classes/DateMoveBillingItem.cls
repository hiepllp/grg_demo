global class DateMoveBillingItem implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Date__c FROM pse__Billing_Event_Item__c';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Billing_Event_Item__c> recordsToUpdate = new List<pse__Billing_Event_Item__c>();
    
    global DateMoveBillingItem(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Billing_Event_Item__c> scope)
    {
        for(pse__Billing_Event_Item__c e: scope)
        {
            IF(e.pse__Date__c != null)
            e.pse__Date__c += DAYSMOVED;
                        
            recordsToUpdate.add(e);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveMilestone batch = new DateMoveMilestone(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}