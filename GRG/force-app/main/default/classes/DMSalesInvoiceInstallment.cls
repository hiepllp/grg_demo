global class DMSalesInvoiceInstallment implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__DueDate__c FROM c2g__codaInvoiceInstallmentLineItem__c';
	private Integer YEARSMOVED; 
	List<c2g__codaInvoiceInstallmentLineItem__c> recordsToUpdate = new List<c2g__codaInvoiceInstallmentLineItem__c>();

	global DMSalesInvoiceInstallment(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaInvoiceInstallmentLineItem__c> scope)
	{
		for(c2g__codaInvoiceInstallmentLineItem__c x: scope)
		{
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
			DMSalesInvoiceLine nextobject = new DMSalesInvoiceLine(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject);
		}
	}
}