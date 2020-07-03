//MDOActualsBatch2 ran before this
global class MDOActualsBatch3 implements Database.Batchable<sObject> {

    String query;
    
    global MDOActualsBatch3 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Regional_Actuals__c> regionActuals = (List<pse__Regional_Actuals__c>)batch;
            for (pse__Regional_Actuals__c actual : regionActuals ) {
                actual.pse__Unique_Name__c = String.valueOf(actual.pse__Region__c) + '-' + String.valueOf(actual.pse__Time_Period__c) ;
            }
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {

      string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Practice__c From pse__Practice_Actuals__c';
      
      if(!Test.isRunningTest())
      {
      MDOActualsBatch4 batchForActual = new MDOActualsBatch4(query );
      Id batchIdForActual = database.executeBatch(batchForActual );
      }
    }

}