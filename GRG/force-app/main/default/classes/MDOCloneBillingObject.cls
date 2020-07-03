//this batch is used to clone the records from the custom billing object into the ffdcmdo1 based one for use on dashboards.
global class MDOCloneBillingObject implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Account__c, Business_Type__c, Billing_Date_Override__c , Contract_Active__c , Contract_Annual_Value__c , Contract_Description__c , Contract_Length__c , Contract_Start_Date__c , Opportunity__c , Status__c  FROM Billing_Contract__c';

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< Billing_Contract__c> scope)
    {
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    Schema.SObjectType t = gd.get('ffdcmdo1__Billing_Contract__c');
    if(t != null) 
        {
            for(Billing_Contract__c c: scope)
            {
        sObject newRecord = Schema.getGlobalDescribe().get('ffdcmdo1__Billing_Contract__c').newSObject() ;  
                newRecord.put('ffdcmdo1__Account__c' , c.Account__c) ;  
                newRecord.put('ffdcmdo1__Billing_Date_Override__c' , c.Billing_Date_Override__c) ;
                newRecord.put('ffdcmdo1__Contract_Active__c' , c.Contract_Active__c) ;
                newRecord.put('ffdcmdo1__Contract_Annual_Value__c' , c.Contract_Annual_Value__c) ;
                newRecord.put('ffdcmdo1__Contract_Description__c' , c.Contract_Description__c) ;
                newRecord.put('ffdcmdo1__Contract_Length__c' , c.Contract_Length__c) ;
                newRecord.put('ffdcmdo1__Contract_Start_Date__c' , c.Contract_Start_Date__c) ;
                newRecord.put('ffdcmdo1__Opportunity__c' , c.Opportunity__c) ;
                newRecord.put('ffdcmdo1__Business_Type__c' , c.Business_Type__c) ;
                insert newRecord ;                 
      }        
        }
        else
        {
            // Email the User that the dashboards package has not been installed.  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            String[] toAddresses = new String[] {UserInfo.getUserEmail()};  
            mail.setToAddresses(toAddresses);  
            mail.setSubject('MDO Dashboards Package Missing');  
            string messageBody = '<html><body>In order for the rest of the configuration to be carried out you must install the MDO Dashboards using the button found in the Demo Setup tab. </body></html>';
            mail.SetHTMLBody(messageBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
    }   
    global void finish(Database.BatchableContext BC)
    {
        MDODashboardFields a = new MDODashboardFields();
        database.executeBatch(a,30);
    }
}