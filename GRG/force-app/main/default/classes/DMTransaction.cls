global class DMTransaction implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, c2g__TransactionDate__c FROM c2g__codaTransaction__c';
    private Integer YEARSMOVED; 
    List<c2g__codaTransaction__c> recordsToUpdate = new List<c2g__codaTransaction__c>();

    global DMTransaction(Integer years)
    {
        YEARSMOVED = years;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaTransaction__c> scope)
    {
        for(c2g__codaTransaction__c x: scope)
        {
            if(x.c2g__TransactionDate__c != null)
                x.c2g__TransactionDate__c = x.c2g__TransactionDate__c.addYears(YEARSMOVED);

            recordsToUpdate.add(x);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;

        if(!Test.isRunningTest())
        {
            DMTransactionLine nextobject = new DMTransactionLine(YEARSMOVED,'10');
            Id batchprocessid = database.executeBatch(nextobject, 40);
        }
    }
}