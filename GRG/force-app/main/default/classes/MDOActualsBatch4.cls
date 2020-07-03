//MDOActualsBatch3 ran before this
global class MDOActualsBatch4 implements Database.Batchable<sObject> {

    String query;
    
    global MDOActualsBatch4 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Practice_Actuals__c> practiceActuals = (List<pse__Practice_Actuals__c>)batch;
            for (pse__Practice_Actuals__c actual : practiceActuals ) {
                actual.pse__Unique_Name__c = String.valueOf(actual.pse__Practice__c) + '-' + String.valueOf(actual.pse__Time_Period__c) ;
            }
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Group__c From pse__Group_Actuals__c';
          
        if(!Test.isRunningTest())
        {
        MDOActualsBatch5 batchForActual = new MDOActualsBatch5(query );
        Id batchIdForActual = database.executeBatch(batchForActual );
        }
    }

}