//MDOProjectBatch2 runs before this
global class MDOProjectBatch3 implements Database.Batchable<sObject>, Database.Stateful {

    String query;
    
    global MDOProjectBatch3 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Practice__c> practiceList = (List<pse__Practice__c>)batch;
            for (pse__Practice__c obj : practiceList ) {
                obj.pse__Practice_ID_Chain__c = null;
            }   
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
    
        string query = 'Select pse__Group_ID_Chain__c From pse__Grp__c' ;
        if(!Test.isRunningTest())
        {

        MDOProjectBatch4 batchObject = new MDOProjectBatch4(query);
        Id batchprocessid = database.executeBatch(batchObject) ;
        }
    }

}