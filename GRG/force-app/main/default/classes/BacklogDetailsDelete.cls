global class BacklogDetailsDelete implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'Select Id from pse__Backlog_Detail__c';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<pse__Backlog_Detail__c> scope)
    {
         delete scope;
    }   
    global void finish(Database.BatchableContext BC)
    {
    }
}