global class DateMoveOpportunities implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, CloseDate FROM Opportunity';

    private Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<Opportunity> recordsToUpdate = new List<Opportunity>();
    
    global DateMoveOpportunities(Integer days)
    {
        DAYSMOVED = days;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< Opportunity> scope)
    {
        for(Opportunity o: scope)
        {
            IF(o.CloseDate != null)
            o.CloseDate += DAYSMOVED;

            recordsToUpdate.add(o);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveProjects batch = new DateMoveProjects(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}