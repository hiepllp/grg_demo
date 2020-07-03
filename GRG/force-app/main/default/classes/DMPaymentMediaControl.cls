global class DMPaymentMediaControl implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__PaymentDate__c FROM c2g__codaPaymentMediaControl__c';
	private Integer YEARSMOVED; 
	List<c2g__codaPaymentMediaControl__c> recordsToUpdate = new List<c2g__codaPaymentMediaControl__c>();

	global DMPaymentMediaControl(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaPaymentMediaControl__c> scope)
	{
		for(c2g__codaPaymentMediaControl__c x: scope)
		{
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

			DMPaymentMediaDetail nextobject = new DMPaymentMediaDetail(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}