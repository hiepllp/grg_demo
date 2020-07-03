global class DMSalesCreditNote implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__CreditNoteDate__c, c2g__DueDate__c, c2g__InvoiceDate__c FROM c2g__codaCreditNote__c';
	private Integer YEARSMOVED; 
	List<c2g__codaCreditNote__c> recordsToUpdate = new List<c2g__codaCreditNote__c>();

	global DMSalesCreditNote(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaCreditNote__c> scope)
	{
		for(c2g__codaCreditNote__c x: scope)
		{
			if(x.c2g__CreditNoteDate__c != null)
				x.c2g__CreditNoteDate__c = x.c2g__CreditNoteDate__c.addYears(YEARSMOVED);

			if(x.c2g__DueDate__c != null)
				x.c2g__DueDate__c = x.c2g__DueDate__c.addYears(YEARSMOVED);

			if(x.c2g__InvoiceDate__c != null)
				x.c2g__InvoiceDate__c = x.c2g__InvoiceDate__c.addYears(YEARSMOVED);

			recordsToUpdate.add(x);         
		}    
	}   
	global void finish(Database.BatchableContext BC)
	{
		update recordsToUpdate;
		if(!Test.isRunningTest())
		{

			DMSalesInvoice nextobject = new DMSalesInvoice(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}