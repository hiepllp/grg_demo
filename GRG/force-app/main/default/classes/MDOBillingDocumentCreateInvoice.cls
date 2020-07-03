//UpdateAccountDrilldown is the previous job
global class MDOBillingDocumentCreateInvoice implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Create_Invoice__c FROM fferpcore__BillingDocument__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<fferpcore__BillingDocument__c> batch) {
        
        for(fferpcore__BillingDocument__c BD : batch)
        {
            BD.Create_Invoice__c = null;
        }
        update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
        
        MDOCongaLicense b = new MDOCongaLicense();
        database.executeBatch(b);
    }
}