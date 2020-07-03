global class DateMoveResourceRequests implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__End_Date__c, pse__Related_Resource_Request_Staffed_On__c, pse__Start_Date__c FROM pse__Resource_Request__c';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Resource_Request__c> recordsToUpdate = new List<pse__Resource_Request__c>();
    
    global DateMoveResourceRequests(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Resource_Request__c> scope)
    {
        for(pse__Resource_Request__c r: scope)
        {
            IF(r.pse__Start_Date__c != null)
            r.pse__Start_Date__c += DAYSMOVED;

            IF(r.pse__Related_Resource_Request_Staffed_On__c != null)
            r.pse__Related_Resource_Request_Staffed_On__c += DAYSMOVED;

            IF(r.pse__End_Date__c != null)
            r.pse__End_Date__c += DAYSMOVED;

            recordsToUpdate.add(r);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveAssignments batch = new DateMoveAssignments(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}