//MDOUpdateFilter ran before this
global class MDOUpdateFilterElement implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Source_id__c FROM ffr__FilterElement__c';
    private static final String SEPARATOR = 'NEWRECORD';

    private List<ffr__ActionViewsPersonalSetting__c> personalSettings = [SELECT Id, ffr__Settings__c FROM ffr__ActionViewsPersonalSetting__c];

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< ffr__FilterElement__c > scope)
    {
        
        String combined = '';

        for(ffr__ActionViewsPersonalSetting__c settingsRecord: personalSettings)
        {
            combined = combined + settingsRecord.ffr__Settings__c + SEPARATOR;
        }

        for(ffr__FilterElement__c dataviewRecord: scope)
        {
            combined = combined.replaceAll(dataviewRecord.Source_id__c,dataviewRecord.Id);
        }

        List<String> splitup = combined.split(SEPARATOR);

        for(Integer i=0;i<personalSettings.size();i++)
        {
            personalSettings[i].ffr__Settings__c = splitup[i];
        }
        update personalSettings;

    }   
    global void finish(Database.BatchableContext BC)
    {                
        if(!Test.isRunningTest())
        {
            MDOUpdateInquiryTemplate a = new MDOUpdateInquiryTemplate();
            database.executeBatch(a,50);
        }

    }
}