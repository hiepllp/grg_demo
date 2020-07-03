global class MDOUpdateInquiryTemplateSignFilter implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Source_ID__c FROM c2g__InquiryTemplateSignFilter__c';
    private static final String SEPARATOR = 'NEWRECORD';

    private List< c2g__OnlineInquiriesPersonalSetting__c > personalSettings = [SELECT Id, Source_ID__c, c2g__Settings__c FROM c2g__OnlineInquiriesPersonalSetting__c];

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List<c2g__InquiryTemplateSignFilter__c> scope)
    {
        String combined = '';

        for (c2g__OnlineInquiriesPersonalSetting__c settingsRecord: personalSettings)
        {
            combined = combined + settingsRecord.c2g__Settings__c + SEPARATOR;
        }
            
        for(c2g__InquiryTemplateSignFilter__c inquiryTemplateSignFilterRecord: scope)
        {
            combined = combined.replaceAll(inquiryTemplateSignFilterRecord.Source_ID__c, inquiryTemplateSignFilterRecord.Id);
        }

        List<String> splitup = combined.split(SEPARATOR);

        for (integer i=0;i<personalSettings.size() ;i++ ) 
        {
            personalSettings[i].c2g__Settings__c = splitup[i];
        }
        update personalSettings;
    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
            MDORefreshBudgetHashCodes a = new MDORefreshBudgetHashCodes();
            database.executeBatch(a,50);
        }
    }
}