//MDORefreshBudgetHashCodes is the previous job
global class UpdateAccountDrilldown implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT id, Name FROM Report WHERE Name = \'Account Balance Report\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Report> batch) {
        
        //this is used to see if account settings already exist
        List<c2g__AccountSettings__c> settingsCheck1 = [SELECT id, c2g__AccountBalanceReportURL__c FROM c2g__AccountSettings__c LIMIT 1];
        
        //if no account settings already exist then we create them
        IF(settingsCheck1.size() == 0)
        {
            c2g__AccountSettings__c customsettings = new c2g__AccountSettings__c();
            customsettings.c2g__AccountBalanceReportURL__c = '/' + batch[0].id;
        
            insert customsettings;
        }
        ELSE //otherwise if they did exist then we update them with the correct report
        {
            settingsCheck1[0].c2g__AccountBalanceReportURL__c = '/' + batch[0].id;
            update settingsCheck1[0];
        }


        Report profitabilityReport = new Report();
        //this finds the Profitability Report
        profitabilityReport = [SELECT id, Name FROM Report WHERE Name = 'Profitability Report'];
        
        //this is used to see if account settings already exist
        List< c2g__codaAccountingSettings__c > settingsCheck2 = [SELECT id, c2g__ProfitabilityReportId__c FROM c2g__codaAccountingSettings__c LIMIT 1];
        
        //if no account settings already exist then we create them
        IF(settingsCheck2.size() == 0)
        {
            c2g__codaAccountingSettings__c customsettings = new c2g__codaAccountingSettings__c();
            customsettings.c2g__ProfitabilityReportId__c = profitabilityReport.id;
        
            insert customsettings;
        }
        ELSE //otherwise if they did exist then we update them with the correct report
        {
            settingsCheck2[0].c2g__ProfitabilityReportId__c = profitabilityReport.id;
            update settingsCheck2[0];
        }


    }
            
    global void finish(Database.BatchableContext BC) {
            
            MDOBillingDocumentCreateInvoice b = new MDOBillingDocumentCreateInvoice();
            database.executeBatch(b);
            
        // Email the Batch Job's submitter that the Job is finished.  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        String[] toAddresses = new String[] {UserInfo.getUserEmail()};  
        mail.setToAddresses(toAddresses);  
        mail.setSubject('Required Configuration Processing Complete');  
        string messageBody = '<html><body>Your automated setup has been completed.<br><br>Return to the Demo Setup tab if more steps need to be carried out. </body></html>';
        mail.SetHTMLBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
}