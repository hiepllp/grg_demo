//MDOActualsBatch1 ran before this
global class MDOActualsBatch2 implements Database.Batchable<sObject> {

    String query;
    
    global MDOActualsBatch2 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Project_Actuals__c> prjctActuals = (List<pse__Project_Actuals__c>)batch;
            for (pse__Project_Actuals__c actual : prjctActuals ) {
                actual.pse__Unique_Name__c = String.valueOf(actual.pse__Project__c) + '-' + String.valueOf(actual.pse__Time_Period__c) ;
            }   
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
    
      string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Region__c From pse__Regional_Actuals__c';
      
      if(!Test.isRunningTest())
      {
      MDOActualsBatch3 batchForActual = new MDOActualsBatch3(query );
      Id batchIdForActual = database.executeBatch(batchForActual );
      }
    }

}