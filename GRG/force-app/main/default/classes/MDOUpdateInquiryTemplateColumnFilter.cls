global class MDOUpdateInquiryTemplateColumnFilter implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Source_ID__c FROM c2g__InquiryTemplateColumnFilter__c';
    private static final String SEPARATOR = 'NEWRECORD';

    private List< c2g__OnlineInquiriesPersonalSetting__c > personalSettings = [SELECT Id, Source_ID__c, c2g__Settings__c FROM c2g__OnlineInquiriesPersonalSetting__c];

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List<c2g__InquiryTemplateColumnFilter__c> scope)
    {
        String combined = '';

        for(c2g__OnlineInquiriesPersonalSetting__c settingsRecord: personalSettings)
        {
            combined = combined + settingsRecord.c2g__Settings__c + SEPARATOR;
        }
        
        for(c2g__InquiryTemplateColumnFilter__c inquiryTemplateColumnFilterRecord: scope)
        {
            combined = combined.replaceAll(inquiryTemplateColumnFilterRecord.Source_ID__c,inquiryTemplateColumnFilterRecord.Id);
        }

        List<String> splitup = combined.split(SEPARATOR);

        for(integer i =0; i < personalSettings.size(); i++)
        {
            personalSettings[i].c2g__Settings__c = splitup[i];
        }
        update personalSettings;
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
            MDOUpdateInquiryTemplateFilter a = new MDOUpdateInquiryTemplateFilter();
            database.executeBatch(a,50);
        }

    }
}