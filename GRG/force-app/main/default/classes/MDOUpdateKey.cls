//MDORemovetheCODE2 ran before this
global class MDOUpdateKey implements Database.Batchable<sObject>
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, ffr__Key__c, ffr__InquiryTemplate__c FROM ffr__ActionViewsPersonalSetting__c';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List< ffr__ActionViewsPersonalSetting__c > scope)
    {
        List< User > UserRecords = [SELECT Id, Source_Id__c FROM User WHERE IsActive = true AND Source_Id__c != null];
        List <ffr__InquiryTemplate__c> InquiryTemplate = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplate__c];
        
        for(ffr__InquiryTemplate__c InquiryTemplateRecord: InquiryTemplate)
        {

            for(ffr__ActionViewsPersonalSetting__c SettingRecords: scope)
            {
                    //replace any occurances of the inquiry template source id with the new id.
                SettingRecords.ffr__Key__c = SettingRecords.ffr__Key__c.replaceAll(InquiryTemplateRecord.Source_ID__c,InquiryTemplateRecord.Id);
                    //make it all uppercase
                SettingRecords.ffr__Key__c = SettingRecords.ffr__Key__c.toUpperCase();
            }  
        }
        update scope;

        for(User UserSettings: UserRecords)
        {
            for(ffr__ActionViewsPersonalSetting__c SettingRecords: scope)
            {
                    //replace any occurances of the users source id to the new id.
                SettingRecords.ffr__Key__c = SettingRecords.ffr__Key__c.replaceAll(UserSettings.Source_ID__c,UserSettings.Id);
            }   
            try{
                update scope;
            }catch (Exception e)
            {}

        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
        MDOUpdateDataview b = new MDOUpdateDataview();
        database.executeBatch(b);
        }

    }
}