global class DMCashEntries implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, c2g__Date__c FROM c2g__codaCashEntry__c';
	private Integer YEARSMOVED; 
    List<c2g__codaCashEntry__c> recordsToUpdate = new List<c2g__codaCashEntry__c>();
    
    global DMCashEntries(Integer years)
    {
        YEARSMOVED = years;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaCashEntry__c> scope)
    {
        for(c2g__codaCashEntry__c x: scope)
        {
        	if(x.c2g__Date__c != null)
            x.c2g__Date__c = x.c2g__Date__c.addYears(YEARSMOVED);

            recordsToUpdate.add(x);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        if(!Test.isRunningTest())
        {

            DMCashMatchingHistories nextobject = new DMCashMatchingHistories(YEARSMOVED);
            Id batchprocessid = database.executeBatch(nextobject) ;
        }
    }
}