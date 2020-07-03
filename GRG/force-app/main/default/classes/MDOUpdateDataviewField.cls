//MDOUpdateDataViewAction ran before this
global class MDOUpdateDataviewField implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Source_ID__c FROM ffr__DataViewField__c';
    private static final String SEPARATOR = 'NEWRECORD';

    private List< ffr__ActionViewsPersonalSetting__c > personalSettings = [SELECT Id, ffr__Settings__c FROM ffr__ActionViewsPersonalSetting__c ORDER BY Id];

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List<ffr__DataViewField__c> scope)
    {
        String combined = '';

        for(ffr__ActionViewsPersonalSetting__c settingsRecord: personalSettings)
        {
            combined = combined + settingsRecord.ffr__Settings__c + SEPARATOR;
        }
        
        for(ffr__DataViewField__c dataviewFieldRecord: scope)
        {
            combined = combined.replaceAll(dataviewFieldRecord.Source_ID__c,dataviewFieldRecord.Id);
        }

        List<String> splitup = combined.split(SEPARATOR);

        for(integer i =0; i < personalSettings.size() ; i++)
        {
            personalSettings[i].ffr__Settings__c = splitup[i];
        }
        update personalSettings;

    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
            MDOUpdateDataViewJoinFilter a = new MDOUpdateDataViewJoinFilter();
            database.executeBatch(a,50);
        }
    }
}