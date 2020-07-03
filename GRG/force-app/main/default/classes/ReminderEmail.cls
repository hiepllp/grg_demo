public with sharing class ReminderEmail implements Schedulable
{    
    public void execute(SchedulableContext ctx) 
    {        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        List<String> toAddresses = new List<String> {UserInfo.getUserEmail()};  
        mail.setToAddresses(toAddresses); 
        mail.setSubject('Organization Expiring');  
        string messageBody = '<html><body><p>This email is being sent to remind you (' + UserInfo.getUserName() + ' that your org with Id: ' + UserInfo.getOrganizationId() + ' will expire in the next 20 days unless you create a case with Salesforce to extend the license.</p><li>Copy your Org id.</li><li>Log into the Salesforce <a href="https://partners.salesforce.com">Partner Portal</a>.</li><li>Log a case with Salesforce asking them to extend your org.</li></body></html>';
        mail.SetHTMLBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}