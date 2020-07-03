//MDOUpdateCompanyLogo is before this batch
//4-19-2019: Updated "Bill Lumbergh" to "System Administrator"
global class UpdateBillLumbergh implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT id, FirstName, LastName FROM Contact WHERE FirstName = \'System\' AND LastName = \'Administrator\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> batch) {
        if (batch.size() == 1) 
        {
            //simply renaming a user
            for (Contact c : batch) 
            {  
                c.FirstName = UserInfo.getFirstName();
                c.LastName = UserInfo.getLastName();
                update batch;
            } 
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
        if(!test.isRunningTest())
        {
            //next batch
            UpdateDepreciationMethods a = new UpdateDepreciationMethods();
            database.executeBatch(a,50);
        }
        try{
            //updating the consultant tools
            ffct__Connection__c bundleconnection = [SELECT ID,NAME, ffct__Unique__c FROM ffct__Connection__c WHERE name = 'sysadmin@merlintech.demo_SameOrg' LIMIT 1];
            bundleconnection.ffct__Unique__c = 'https://login.salesforce.com/id/' + UserInfo.getOrganizationId() + '/' + UserInfo.getUserId();
            update bundleconnection;
        }catch (Exception e)
        {}
        
        //emailing me to tell me that they have spun up an org
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        String[] toAddresses = new String[] {'mbyrne@financialforce.com'};  
            mail.setToAddresses(toAddresses);  
        mail.setSubject('Trial Org Setup');  
        string messageBody = 'A trial org was just configured by <b>' + UserInfo.getName() + '</b><br/>Email: <b>' + UserInfo.getUserEmail() + '</b><br/> Username <b>'+ UserInfo.getUserName() + '</b><br/>Org ID: <b>' + UserInfo.getOrganizationId() + '</b><br/>Org Name: <b>' + UserInfo.getOrganizationName() + '</b>';
        mail.SetHTMLBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
}