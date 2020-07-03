//MDOUpdateInquiryTemplateColumn ran before this
global class MDOUpdateInquiryTemplateFilter implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Source_ID__c FROM ffr__InquiryTemplateFilter__c';
    private static final String SEPARATOR = 'NEWRECORD';

    private List< ffr__ActionViewsPersonalSetting__c > personalSettings = [SELECT Id, ffr__Settings__c FROM ffr__ActionViewsPersonalSetting__c];

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List<ffr__InquiryTemplateFilter__c> scope)
    {
        String combined = '';

        for(ffr__ActionViewsPersonalSetting__c settingsRecord: personalSettings)
        {
            combined = combined + settingsRecord.ffr__Settings__c + SEPARATOR;
        }
        
        for(ffr__InquiryTemplateFilter__c inquiryTemplateFilterRecord: scope)
        {
            combined = combined.replaceAll(inquiryTemplateFilterRecord.Source_id__c, inquiryTemplateFilterRecord.Id);
        }

        List<String> splitup = combined.split(SEPARATOR);

        for(integer i = 0; i< personalSettings.size(); i++)
        {
            personalSettings[i].ffr__Settings__c = splitup[i];
        }
        update personalSettings;
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
            MDOUpdateInquiryTemplateRCP a = new MDOUpdateInquiryTemplateRCP();
            database.executeBatch(a,50);
        }

    }
}