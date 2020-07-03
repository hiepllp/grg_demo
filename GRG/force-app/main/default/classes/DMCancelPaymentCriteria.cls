global class DMCancelPaymentCriteria implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, c2g__PaymentRefundDate__c, c2g__UndoMatchDate__c FROM c2g__codaVoidPaymentCriteria__c';
	private Integer YEARSMOVED; 
    List<c2g__codaVoidPaymentCriteria__c> recordsToUpdate = new List<c2g__codaVoidPaymentCriteria__c>();
    
    global DMCancelPaymentCriteria(Integer years)
    {
        YEARSMOVED = years;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaVoidPaymentCriteria__c> scope)
    {
        for(c2g__codaVoidPaymentCriteria__c x: scope)
        {
        	if(x.c2g__PaymentRefundDate__c != null)
            x.c2g__PaymentRefundDate__c = x.c2g__PaymentRefundDate__c.addYears(YEARSMOVED);

        	if(x.c2g__UndoMatchDate__c != null)
            x.c2g__UndoMatchDate__c = x.c2g__UndoMatchDate__c.addYears(YEARSMOVED);

            recordsToUpdate.add(x);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        if(!Test.isRunningTest())
        {

            DMCashEntries nextobject = new DMCashEntries(YEARSMOVED);
            Id batchprocessid = database.executeBatch(nextobject) ;
        }
    }
}