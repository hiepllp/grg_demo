//MDOActualsBatch4 ran before this
global class MDOActualsBatch5 implements Database.Batchable<sObject> {

    String query;
    
    global MDOActualsBatch5 (String initialQuery) {
        query = initialQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> batch) {

            List<pse__Group_Actuals__c> groupActuals = (List<pse__Group_Actuals__c>)batch;
            for (pse__Group_Actuals__c actual : groupActuals ) {
                actual.pse__Unique_Name__c = String.valueOf(actual.pse__Group__c) + '-' + String.valueOf(actual.pse__Time_Period__c) ;
            }
            update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
   
        if(!Test.isRunningTest())
        {
        MDORemovetheCODE2 b = new MDORemovetheCODE2();
        database.executeBatch(b);
        }
    }

}