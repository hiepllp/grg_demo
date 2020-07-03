global class DMJournals implements Database.Batchable<sObject>, Database.Stateful
{
	private static final String QUERY = 'SELECT Id, c2g__JournalDate__c FROM c2g__codaJournal__c';
	private Integer YEARSMOVED; 
	List<c2g__codaJournal__c> recordsToUpdate = new List<c2g__codaJournal__c>();

	global DMJournals(Integer years)
	{
		YEARSMOVED = years;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QUERY);
	}

	global void execute(Database.BatchableContext BC, List< c2g__codaJournal__c> scope)
	{
		for(c2g__codaJournal__c x: scope)
		{
			if(x.c2g__JournalDate__c != null)
				x.c2g__JournalDate__c = x.c2g__JournalDate__c.addYears(YEARSMOVED);

			recordsToUpdate.add(x);         
		}    
	}   
	global void finish(Database.BatchableContext BC)
	{
		update recordsToUpdate;
		if(!Test.isRunningTest())
		{

			DMPayableCreditNotes nextobject = new DMPayableCreditNotes(YEARSMOVED);
			Id batchprocessid = database.executeBatch(nextobject) ;
		}
	}
}