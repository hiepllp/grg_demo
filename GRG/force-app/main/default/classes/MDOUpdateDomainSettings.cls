//this is the first of many batch jobs to configure the org
global class MDOUpdateDomainSettings implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT ID, Domain_Name__c FROM Domain_Settings__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Domain_Settings__c> batch) {
        for(Domain_Settings__c cs : batch)
        {
            //we find the domain name
            cs.Domain_Name__c = URL.getSalesforceBaseUrl().getHost();
        }
        update batch;
    }
    
    global void finish(Database.BatchableContext BC) {
        
        MDOUpdateCompanyLogo a = new MDOUpdateCompanyLogo();
        database.executeBatch(a,50);        
    }
}