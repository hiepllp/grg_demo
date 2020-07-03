global class DateMoveContact implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Start_Date__c FROM Contact';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<Contact> recordsToUpdate = new List<Contact>();
    
    global DateMoveContact(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< Contact> scope)
    {
        for(Contact e: scope)
        {
            IF(e.pse__Start_Date__c  != null)
            e.pse__Start_Date__c  += DAYSMOVED;
            
            recordsToUpdate.add(e);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
            String userEmail = UserInfo.getUserEmail();

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            List<String> toAddresses = new List<String> {userEmail};  
            mail.setToAddresses(toAddresses); 
            mail.setSubject('PSA Date Move Successful');  
            string messageBody = '<html><body>The dates for all PSA objects have been successfully moved ' + DAYSMOVED + ' days</body></html>';
            mail.SetHTMLBody(messageBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}