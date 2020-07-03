//MDOProjectBatch3 runs before this
//this batch is the last of the project batches. It also rebuilds the tax cache
global class MDOProjectBatch4 implements Database.Batchable<sObject>, Database.Stateful {

    String query;
    
    global MDOProjectBatch4 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Grp__c> grpList = (List<pse__Grp__c>)batch;
            for (pse__Grp__c obj : grpList ) {
                obj.pse__Group_ID_Chain__c = null;
            }
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Resource__c From pse__Resource_Actuals__c' ;
        
        if(!Test.isRunningTest())
        {        
        //we are going to start by rebuilding the cache for tax
        c2g.CODATaxCacheBatchMethods.rebuildCache();
        
        //then the first actuals batch process.
        MDOActualsBatch1 batchForActual = new MDOActualsBatch1(query);
        Id batchIdForActual = database.executeBatch(batchForActual);
        }
    }

}