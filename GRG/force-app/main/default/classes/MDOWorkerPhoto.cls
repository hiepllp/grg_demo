global class MDOWorkerPhoto implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT id FROM Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> batch) {
        update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
    	
        if(!Test.isRunningTest())
        {
            MDOBillingDocumentCreateInvoice b = new MDOBillingDocumentCreateInvoice();
            database.executeBatch(b);
        }

    }
}