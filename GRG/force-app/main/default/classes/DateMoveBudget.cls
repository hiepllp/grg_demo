global class DateMoveBudget implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Admin_Global_Edit__c, pse__Audit_Notes__c, pse__Invoice_Date__c, pse__Effective_Date__c, pse__Bill_Date__c FROM pse__Budget__c';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Budget__c> recordsToUpdate = new List<pse__Budget__c>();
    
    global DateMoveBudget(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Budget__c> scope)
    {
        for(pse__Budget__c e: scope)
        {
            IF(e.pse__Invoice_Date__c != null)
            e.pse__Invoice_Date__c += DAYSMOVED;
            
            IF(e.pse__Effective_Date__c != null)
            e.pse__Effective_Date__c += DAYSMOVED;
            
            IF(e.pse__Bill_Date__c != null)
            e.pse__Bill_Date__c += DAYSMOVED;
            
            e.pse__Admin_Global_Edit__c = true;
            e.pse__Audit_Notes__c = AUDITNOTES;

      
            recordsToUpdate.add(e);
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveUtilization batch = new DateMoveUtilization(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}