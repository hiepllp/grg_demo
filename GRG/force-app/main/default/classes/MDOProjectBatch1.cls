//UpdateDepreciationMethods runs before this
//this is the first of 4 project batches along with the purdge of tax cache
global class MDOProjectBatch1 implements Database.Batchable<sObject>, Database.Stateful {

    String query;
    
    global MDOProjectBatch1 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Proj__c> projList = (List<pse__Proj__c>)batch;
            for (pse__Proj__c obj : projList ) {
                obj.pse__Project_ID_Chain__c = null;
            }
        
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
        string query = 'Select pse__Region_ID_Chain__c From pse__Region__c' ;
        
        if(!Test.isRunningTest())
        {
        //it now starts the purge of tax cache
        c2g.CODATaxCacheBatchMethods.purgeCache();
        
        //then starts the next batch for regions
        MDOProjectBatch2 batchObject = new MDOProjectBatch2(query);
        Id batchprocessid = database.executeBatch(batchObject) ;
        }
    }

}