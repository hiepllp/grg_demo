//MDOUpdateDomainSettings is before this batch
global class MDOUpdateCompanyLogo implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT ID, Name, c2g__LogoURL__c FROM c2g__codaCompany__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<c2g__codaCompany__c> batch) {
        
        //the id of the company logo changes between orgs so we need to find it to update the companies
        List<Document> logodoc = [select Id, DeveloperName from Document WHERE DeveloperName = 'Merlin_Tech_Logo'];
        
        IF(!logodoc.isEmpty())
        {
            for(c2g__codaCompany__c comp : batch)
            {
                comp.c2g__LogoURL__c = 'https://' + URL.getSalesforceBaseUrl().getHost().substringBefore('.') + '.content.force.com/servlet/servlet.ImageServer?id='+logodoc[0].Id + '&oid=' + UserInfo.getOrganizationId();
            }
            update batch;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
        UpdateBillLumbergh a = new UpdateBillLumbergh();
        database.executeBatch(a,50);        
    }
}