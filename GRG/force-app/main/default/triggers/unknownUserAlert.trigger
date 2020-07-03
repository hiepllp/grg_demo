trigger unknownUserAlert on User (before update) {

    for(User u : Trigger.New)
    {
        if( Trigger.oldMap.get( u.Id ).Email != Trigger.newMap.get( u.Id ).Email )
        {
            if(Trigger.oldMap.get( u.Id ).Email.contains('financialforce.com') && !Trigger.newMap.get( u.Id ).Email.contains('financialforce.com'))
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                String[] toAddresses = new String[] {'sydneyadmin@financialforce.com'};  
                mail.setToAddresses(toAddresses);  
                mail.setSubject('Non-FinancialForce Employee using MDO');  
                string messageBody = 'A copy of the MDO has just been passed over to an unknown employee. The email was changed from: ' + Trigger.oldMap.get( u.Id ).Email + ' to ' + Trigger.newMap.get( u.Id ).Email + '. The Org Id is ' + UserInfo.getOrganizationId();
                mail.SetHTMLBody(messageBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            }
        }

    }
}