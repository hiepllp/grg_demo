global class PopulateExternalIdProduct implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String QUERY = 'SELECT ID, External_ID_Field__c FROM Product2 WHERE External_ID_Field__c = null';
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List<Product2> scope)
    {
        for(Product2 c: scope)
            {
                c.External_id_Field__c = c.Id + 'DEMO';
            }
        try{
            update scope;
        }catch (Exception e)
        {
            
        }
    }   
    global void finish(Database.BatchableContext BC)
    {
        PopulateExternalIdOpp batch = new PopulateExternalIdOpp();
        Id batchId = database.executeBatch(batch, 50);
    }
}