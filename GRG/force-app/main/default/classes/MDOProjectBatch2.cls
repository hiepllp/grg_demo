//MDOProjectBatch1 runs before this
global class MDOProjectBatch2 implements Database.Batchable<sObject>, Database.Stateful {

    String query;
    
    global MDOProjectBatch2 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Region__c> regionList = (List<pse__Region__c>)batch;
            for (pse__Region__c obj : regionList) {
                obj.pse__Region_ID_Chain__c = null;
            }
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
    
        string query = 'Select pse__Practice_ID_Chain__c From pse__Practice__c';
        if(!Test.isRunningTest())
        {
        MDOProjectBatch3 batchObject = new MDOProjectBatch3(query);
        Id batchprocessid = database.executeBatch(batchObject) ;
        }
     }

}