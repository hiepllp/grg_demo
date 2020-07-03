global class DMPayableCreditNoteLine implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__DateFrom__c, c2g__DateTo__c FROM c2g__codaPurchaseCreditNoteLineItem__c';
	private Integer YEARSMOVED; 
	List<c2g__codaPurchaseCreditNoteLineItem__c> recordsToUpdate = new List<c2g__codaPurchaseCreditNoteLineItem__c>();

	global DMPayableCreditNoteLine(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaPurchaseCreditNoteLineItem__c> scope)
	{
		for(c2g__codaPurchaseCreditNoteLineItem__c x: scope)
		{
			if(x.c2g__DateFrom__c != null)
				x.c2g__DateFrom__c = x.c2g__DateFrom__c.addYears(YEARSMOVED);

			if(x.c2g__DateTo__c != null)
				x.c2g__DateTo__c = x.c2g__DateTo__c.addYears(YEARSMOVED);

			recordsToUpdate.add(x);         
		}    
	}   
	global void finish(Database.BatchableContext BC)
	{
		update recordsToUpdate;
		if(!Test.isRunningTest())
		{

			DMPayableInvoices nextobject = new DMPayableInvoices(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}