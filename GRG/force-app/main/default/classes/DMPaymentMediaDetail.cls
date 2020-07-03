global class DMPaymentMediaDetail implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__DocumentDate__c, c2g__DueDate__c FROM c2g__codaPaymentMediaDetail__c';
	private Integer YEARSMOVED; 
	List<c2g__codaPaymentMediaDetail__c> recordsToUpdate = new List<c2g__codaPaymentMediaDetail__c>();

	global DMPaymentMediaDetail(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaPaymentMediaDetail__c> scope)
	{
		for(c2g__codaPaymentMediaDetail__c x: scope)
		{
			if(x.c2g__DocumentDate__c != null)
				x.c2g__DocumentDate__c = x.c2g__DocumentDate__c.addYears(YEARSMOVED);

			if(x.c2g__DueDate__c != null)
				x.c2g__DueDate__c = x.c2g__DueDate__c.addYears(YEARSMOVED);

			recordsToUpdate.add(x);         
		}    
	}   
	global void finish(Database.BatchableContext BC)
	{
		update recordsToUpdate;
		if(!Test.isRunningTest())
		{

			DMSalesCreditNote nextobject = new DMSalesCreditNote(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}