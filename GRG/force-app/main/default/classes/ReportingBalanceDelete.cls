global class ReportingBalanceDelete implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'Select Id from c2g__ReportingBalance__c ';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<c2g__ReportingBalance__c> scope)
    {
         delete scope;
    }   
    global void finish(Database.BatchableContext BC)
    {
    }
}