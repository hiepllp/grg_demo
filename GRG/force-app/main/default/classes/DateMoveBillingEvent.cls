global class DateMoveBillingEvent implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Date__c, pse__Invoice_Date__c FROM pse__Billing_Event__c';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Billing_Event__c> recordsToUpdate = new List<pse__Billing_Event__c>();
    
    global DateMoveBillingEvent(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Billing_Event__c> scope)
    {
        for(pse__Billing_Event__c e: scope)
        {
            IF(e.pse__Date__c != null)
            e.pse__Date__c += DAYSMOVED;
            
            IF(e.pse__Invoice_Date__c != null)
            e.pse__Invoice_Date__c += DAYSMOVED;

            recordsToUpdate.add(e);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveBillingItem batch = new DateMoveBillingItem(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}