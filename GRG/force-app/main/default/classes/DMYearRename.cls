global class DMYearRename implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Name, c2g__StartDate__c, c2g__EndDate__c, c2g__YearEndDate__c FROM c2g__codaYear__c';
	private Integer YEARSMOVED; 
    List<c2g__codaYear__c> recordsToUpdate = new List<c2g__codaYear__c>();
    
    global DMYearRename(Integer years)
    {
        YEARSMOVED = years;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaYear__c> scope)
    {
        for(c2g__codaYear__c x: scope)
        {
            x.Name = String.valueOf(integer.valueOf(x.Name) + YEARSMOVED);
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

            DMPeriodRename nextobject = new DMPeriodRename(YEARSMOVED);
            Id batchprocessid = database.executeBatch(nextobject) ;
        }
    }
}