global class PopulateExternalIdContact implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String QUERY = 'SELECT ID, External_ID_Field__c FROM Contact WHERE External_ID_Field__c = null';
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        for(Contact c: scope)
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
        PopulateExternalIdProduct batch = new PopulateExternalIdProduct();
        Id batchId = database.executeBatch(batch, 50);
    }
}