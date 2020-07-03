global class PopulateExternalId implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{
    private  Integer counter;
    private  Integer objectAPI;
    List<String> objectList = new List<String>();
    String objectName;
    
    global PopulateExternalId(Integer count)
    {
        counter = count;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String QUERY = '';
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
        objectName = (String)gd[counter].getDescribe().getName();
        
        do{
            counter = counter + 1;
            objectName = (String)gd[counter].getDescribe().getName();
        }while(objectName.containsIgnoreCase('__history') || objectName.containsIgnoreCase('__feed') || objectName.containsIgnoreCase('__share'));

        IF(objectName.containsIgnoreCase('__c') && !objectName.containsIgnoreCase('__mdt') && !objectName.containsIgnoreCase('__history') && !objectName.containsIgnoreCase('__feed') && !objectName.containsIgnoreCase('__share') && !objectName.containsIgnoreCase('ReportingBalance'))
        {
        QUERY = 'SELECT ID, External_ID_Field__c FROM ' + objectName + ' WHERE External_ID_Field__c = null';
        }
        ELSE
        {
        QUERY = 'SELECT ID FROM ' + objectName + ' LIMIT 1';
        }
        
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<sObject> recordsToUpdate = new List<sObject>();
        IF(objectName.containsIgnoreCase('__c') && !objectName.containsIgnoreCase('__mdt') && !objectName.containsIgnoreCase('__history') && !objectName.containsIgnoreCase('__feed') && !objectName.containsIgnoreCase('__share') && !objectName.containsIgnoreCase('ReportingBalance'))
        {
    	for(sObject c: scope)
            {
            sObject newRecord = Schema.getGlobalDescribe().get(objectName).newSObject();
                    newRecord.put('External_ID_Field__c' , c.Id + 'DEMO');
                    newRecord.put('Id' , c.Id);
                    recordsToUpdate.add(newRecord);
            }
        }
        try{
            update recordsToUpdate;
        }catch (Exception e)
        {
            
        }
    }   
    global void finish(Database.BatchableContext BC)
    {
      	//check to find the next object that needs updating
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
        //we need a query that will return 0
        string query = 'SELECT count() FROM User WHERE Id = null';
        //this is to avoid the query limit.
        Integer loopcount = 0;
        do {
            counter = counter + 1;
            loopcount = loopcount + 1;
            objectName = (String)gd[counter].getDescribe().getName();
            IF(objectName.containsIgnoreCase('__c') && !objectName.containsIgnoreCase('__mdt') && !objectName.containsIgnoreCase('__history') && !objectName.containsIgnoreCase('__feed') && !objectName.containsIgnoreCase('__share') && !objectName.containsIgnoreCase('ReportingBalance'))
            {
                query = 'SELECT count() FROM ' + objectName + ' WHERE External_ID_Field__c = null';
            }
        } while(database.countQuery(query)==0 && loopcount < 90 && counter < 1965);

        IF(counter < 1965)
        {
	        PopulateExternalId batch = new PopulateExternalId(counter);
    	    Id batchId = database.executeBatch(batch, 50);
        }
        ELSE
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            String[] toAddresses = new String[] {UserInfo.getUserEmail()};  
            mail.setToAddresses(toAddresses);  
            mail.setSubject('Trial Org Ready for Template');  
            string messageBody = 'All External Ids have been populated. The org is now ready to be templated.';
            mail.SetHTMLBody(messageBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
    }
}