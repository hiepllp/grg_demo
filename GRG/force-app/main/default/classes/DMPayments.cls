global class DMPayments implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__DueDate__c, c2g__PaymentDate__c FROM c2g__codaPayment__c';
	private Integer YEARSMOVED; 
	List<c2g__codaPayment__c> recordsToUpdate = new List<c2g__codaPayment__c>();

	global DMPayments(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaPayment__c> scope)
	{
		for(c2g__codaPayment__c x: scope)
		{
			if(x.c2g__DueDate__c != null)
				x.c2g__DueDate__c = x.c2g__DueDate__c.addYears(YEARSMOVED);

			if(x.c2g__PaymentDate__c != null)
				x.c2g__PaymentDate__c = x.c2g__PaymentDate__c.addYears(YEARSMOVED);
			
			recordsToUpdate.add(x);         
		}    
	}   
	global void finish(Database.BatchableContext BC)
	{
		update recordsToUpdate;
		if(!Test.isRunningTest())
		{

			DMPaymentLine nextobject = new DMPaymentLine(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}