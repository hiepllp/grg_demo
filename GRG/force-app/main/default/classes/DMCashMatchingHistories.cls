global class DMCashMatchingHistories implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__DiscountDate__c, c2g__MatchingDate__c FROM c2g__codaCashMatchingHistory__c';
	private Integer YEARSMOVED; 
	List<c2g__codaCashMatchingHistory__c> recordsToUpdate = new List<c2g__codaCashMatchingHistory__c>();

	global DMCashMatchingHistories(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaCashMatchingHistory__c> scope)
	{
		for(c2g__codaCashMatchingHistory__c x: scope)
		{
			if(x.c2g__DiscountDate__c != null)
				x.c2g__DiscountDate__c = x.c2g__DiscountDate__c.addYears(YEARSMOVED);

			if(x.c2g__MatchingDate__c != null)
				x.c2g__MatchingDate__c = x.c2g__MatchingDate__c.addYears(YEARSMOVED);

			recordsToUpdate.add(x);         
		}    
	}   
	global void finish(Database.BatchableContext BC)
	{
		update recordsToUpdate;
		if(!Test.isRunningTest())
		{

			DMJournals nextobject = new DMJournals(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}