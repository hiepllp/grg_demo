global class DMSalesInvoice implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__FirstDueDate__c, c2g__DueDate__c, c2g__InvoiceDate__c, c2g__StartDate__c FROM c2g__codaInvoice__c';
	private Integer YEARSMOVED; 
	List<c2g__codaInvoice__c> recordsToUpdate = new List<c2g__codaInvoice__c>();

	global DMSalesInvoice(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaInvoice__c> scope)
	{
		for(c2g__codaInvoice__c x: scope)
		{
			if(x.c2g__FirstDueDate__c != null)
				x.c2g__FirstDueDate__c = x.c2g__FirstDueDate__c.addYears(YEARSMOVED);

			if(x.c2g__DueDate__c != null)
				x.c2g__DueDate__c = x.c2g__DueDate__c.addYears(YEARSMOVED);

			if(x.c2g__InvoiceDate__c != null)
				x.c2g__InvoiceDate__c = x.c2g__InvoiceDate__c.addYears(YEARSMOVED);

			if(x.c2g__StartDate__c != null)
				x.c2g__StartDate__c = x.c2g__StartDate__c.addYears(YEARSMOVED);

			recordsToUpdate.add(x);         
		}    
	}   
	global void finish(Database.BatchableContext BC)
	{
		update recordsToUpdate;
		if(!Test.isRunningTest())
		{

			DMSalesInvoiceInstallment nextobject = new DMSalesInvoiceInstallment(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}