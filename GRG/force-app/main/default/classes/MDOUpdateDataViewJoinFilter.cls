//MDOUpdateDataViewField ran before this
global class MDOUpdateDataViewJoinFilter implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Source_id__c FROM ffr__DataViewJoinFilter__c';
    private static final String SEPARATOR = 'NEWRECORD';

    private List< ffr__ActionViewsPersonalSetting__c > personalSettings = [SELECT Id, ffr__Settings__c FROM ffr__ActionViewsPersonalSetting__c];

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< ffr__DataViewJoinFilter__c > scope)
    {
        String combined = '';

        for(ffr__ActionViewsPersonalSetting__c settingsRecord: personalSettings)
        {
            combined = combined + settingsRecord.ffr__Settings__c + SEPARATOR;
        }
        
        for(ffr__DataViewJoinFilter__c dataViewJoinFilterRecord: scope)
        {
            combined = combined.replaceAll(dataViewJoinFilterRecord.Source_id__c,dataViewJoinFilterRecord.Id);
        }

        List<String> splitup = combined.split(SEPARATOR);

        for(integer i =0; i < personalSettings.size(); i++)
        {
            personalSettings[i].ffr__Settings__c = splitup[i];
        }
        update personalSettings;

    }   
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest())
        {
            MDOUpdateDataViewTransposeItem a = new MDOUpdateDataViewTransposeItem();
            database.executeBatch(a,50);
        }
    }
}