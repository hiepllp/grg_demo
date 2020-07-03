//MDOUpdateFilterElement ran before this
global class MDOUpdateInquiryTemplate implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Source_id__c FROM ffr__InquiryTemplate__c';
    private static final String SEPARATOR = 'NEWRECORD';

    private List< ffr__ActionViewsPersonalSetting__c > personalSettings = [SELECT Id, ffr__Settings__c FROM ffr__ActionViewsPersonalSetting__c];

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< ffr__InquiryTemplate__c > scope)
    {
        String combined = '';

        for(ffr__ActionViewsPersonalSetting__c settingRecord: personalSettings)
        {
            combined = combined + settingRecord.ffr__Settings__c + SEPARATOR;
        }

        for(ffr__InquiryTemplate__c inquiryTemplateRecord: scope)
        {
            combined = combined.replaceAll(inquiryTemplateRecord.Source_id__c,inquiryTemplateRecord.Id);
        }

        List<String> splitup = combined.split(SEPARATOR);

        for(integer i = 0; i < personalSettings.size(); i++)
        {
            personalSettings[i].ffr__Settings__c = splitup[i];
        }
        update personalSettings;
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
            MDOUpdateInquiryTemplateColumn a = new MDOUpdateInquiryTemplateColumn();
            database.executeBatch(a,50);
        }

    }
}