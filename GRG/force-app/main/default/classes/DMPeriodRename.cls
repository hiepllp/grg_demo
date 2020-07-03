global class DMPeriodRename implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Name, c2g__StartDate__c, c2g__EndDate__c, c2g__YearName__r.Name FROM c2g__codaPeriod__c';
    List<c2g__codaPeriod__c> recordsToUpdate = new List<c2g__codaPeriod__c>();
    private Integer YEARSMOVED; 
    
    global DMPeriodRename(Integer years)
    {
        YEARSMOVED = years;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaPeriod__c> scope)
    {
        for(c2g__codaPeriod__c x: scope)
        {
            x.Name = x.c2g__YearName__r.Name + x.Name.RIGHT(4);
            x.c2g__StartDate__c = x.c2g__StartDate__c.addYears(YEARSMOVED);
            x.c2g__EndDate__c = x.c2g__EndDate__c.addYears(YEARSMOVED);

            recordsToUpdate.add(x);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        if(!Test.isRunningTest())
        {

            DMBankReconciliation nextobject = new DMBankReconciliation(YEARSMOVED);
            Id batchprocessid = database.executeBatch(nextobject) ;
        }
    }
}