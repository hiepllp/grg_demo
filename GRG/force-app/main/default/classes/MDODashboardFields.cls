//this batch is used to update field values recieved from the dashboard package.
global class MDODashboardFields implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT id, Desired_Go_Live__c, Earned_Revenue__c FROM pse__Proj__c';

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< pse__Proj__c> scope)
    {
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    Schema.SObjectType t = gd.get('ffdcmdo1__Billing_Contract__c');
    if(t != null) 
        {
            for(pse__Proj__c record : scope)
            {
                record.put('ffdcmdo1__Desired_Go_Live__c',record.Desired_Go_Live__c);
                record.put('ffdcmdo1__Earned_Revenue__c',record.Earned_Revenue__c);
            }
        }
        update scope;
    }   
    global void finish(Database.BatchableContext BC)
    {
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