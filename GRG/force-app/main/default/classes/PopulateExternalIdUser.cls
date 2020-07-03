global class PopulateExternalIdUser implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String QUERY = 'SELECT ID, External_ID_Field__c, Source_ID__c FROM User';
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List<User> scope)
    {
        for(User c: scope)
            {
                IF(c.External_id_Field__c == null)
                {
                    c.External_id_Field__c = c.Id + 'DEMO';
                }
                c.Source_ID__c = c.Id + 'SUPPORT';
            }
        try{
            update scope;
        }catch (Exception e)
        {
            
        }
    }   
    global void finish(Database.BatchableContext BC)
    {
        PopulateExternalId batch = new PopulateExternalId(367);
        Id batchId = database.executeBatch(batch, 50);
    }
}