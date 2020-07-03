global class DMBankStatementLines implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, c2g__Date__c FROM c2g__codaBankStatementLineItem__c';
	private Integer YEARSMOVED; 
    List<c2g__codaBankStatementLineItem__c> recordsToUpdate = new List<c2g__codaBankStatementLineItem__c>();
    
    global DMBankStatementLines(Integer years)
    {
        YEARSMOVED = years;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaBankStatementLineItem__c> scope)
    {
        for(c2g__codaBankStatementLineItem__c x: scope)
        {
            x.c2g__Date__c = x.c2g__Date__c.addYears(YEARSMOVED);
            
            recordsToUpdate.add(x);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        if(!Test.isRunningTest())
        {

            DMCancelPaymentCriteria nextobject = new DMCancelPaymentCriteria(YEARSMOVED);
            Id batchprocessid = database.executeBatch(nextobject) ;
        }
    }
}