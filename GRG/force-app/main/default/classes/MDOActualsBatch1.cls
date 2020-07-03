//MDOProjectBatch4 ran before this
//this class runs the first actuals batch then prudges the accounting currency
global class MDOActualsBatch1 implements Database.Batchable<sObject> {

    String query;
    
    global MDOActualsBatch1 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Resource_Actuals__c> resActuals = (List<pse__Resource_Actuals__c>)batch;
            for (pse__Resource_Actuals__c actual : resActuals) {
                actual.pse__Unique_Name__c = String.valueOf(actual.pse__Resource__c) + '-' + String.valueOf(actual.pse__Time_Period__c) ;
            }
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Project__c From pse__Project_Actuals__c';

        if(!Test.isRunningTest())
        {
        //we must firstly purdge the accounting currency cache. This is instant so no batch created.
        c2g.CODAAccountingCurrencyService.purgeCache();
        
        //then we start the next actuals batch.
        MDOActualsBatch2 batchForActual = new MDOActualsBatch2(query );
        Id batchIdForActual = database.executeBatch(batchForActual );
        }
    
    }

}