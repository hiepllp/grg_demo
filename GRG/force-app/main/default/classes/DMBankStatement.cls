global class DMBankStatement implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, c2g__StatementDate__c FROM c2g__codaBankStatement__c';
	private Integer YEARSMOVED; 
    List<c2g__codaBankStatement__c> recordsToUpdate = new List<c2g__codaBankStatement__c>();
    
    global DMBankStatement(Integer years)
    {
        YEARSMOVED = years;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaBankStatement__c> scope)
    {
        for(c2g__codaBankStatement__c x: scope)
        {
            x.c2g__StatementDate__c = x.c2g__StatementDate__c.addYears(YEARSMOVED);
            
            recordsToUpdate.add(x);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        if(!Test.isRunningTest())
        {

            DMBankStatementLines nextobject = new DMBankStatementLines(YEARSMOVED);
            Id batchprocessid = database.executeBatch(nextobject) ;
        }
    }
}