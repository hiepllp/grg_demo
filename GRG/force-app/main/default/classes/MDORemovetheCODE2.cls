//MDOActualsBatch5 ran before this
global class MDORemovetheCODE2 implements Database.Batchable<sObject>
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, Source_ID__c FROM User WHERE Source_ID__c != null';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List< User > scope)
    {
    }   
    global void finish(Database.BatchableContext BC)
    {
        List <ffr__Filter__c> Filter = [SELECT Id, Source_ID__c FROM ffr__Filter__c WHERE Source_ID__c != null];
        List <ffr__FilterElement__c> FilterElement = [SELECT Id, Source_ID__c FROM ffr__FilterElement__c WHERE Source_ID__c != null];

        List <ffr__InquiryTemplate__c> InquiryTemplate = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplate__c WHERE Source_ID__c != null];
        List <ffr__InquiryTemplateColumn__c> InquiryTemplateColumn = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateColumn__c WHERE Source_ID__c != null];
        List <ffr__InquiryTemplateFilter__c> InquiryTemplateFilter = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateFilter__c WHERE Source_ID__c != null];
        List <ffr__InquiryTemplateRCP__c> InquiryTemplateRCP = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateRCP__c WHERE Source_ID__c != null];
        List <ffr__InquiryTemplateSortItem__c> InquiryTemplateSortItem = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateSortItem__c WHERE Source_ID__c != null];

        List <User> UserRecord = [SELECT Id, Source_ID__c FROM User WHERE Source_ID__c != null];

        for(ffr__Filter__c FilterRecords: Filter)
        {
            FilterRecords.Source_ID__c = FilterRecords.Source_ID__c.substring(0,18);
        } update Filter;
        
        for(ffr__FilterElement__c FilterElementRecords: FilterElement)
        {
            FilterElementRecords.Source_ID__c = FilterElementRecords.Source_ID__c.substring(0,18);
        } update FilterElement;

        for(ffr__InquiryTemplate__c InquiryTemplateRecords: InquiryTemplate)
        {
            InquiryTemplateRecords.Source_ID__c = InquiryTemplateRecords.Source_ID__c.substring(0,18);
        } update InquiryTemplate;
        
        for(ffr__InquiryTemplateColumn__c InquiryTemplateColumnRecords: InquiryTemplateColumn)
        {
            InquiryTemplateColumnRecords.Source_ID__c = InquiryTemplateColumnRecords.Source_ID__c.substring(0,18);
        } update InquiryTemplateColumn;
                
        for(ffr__InquiryTemplateFilter__c InquiryTemplateFilterRecords: InquiryTemplateFilter)
        {
            InquiryTemplateFilterRecords.Source_ID__c = InquiryTemplateFilterRecords.Source_ID__c.substring(0,18);
        } update InquiryTemplateFilter;
        
        for(ffr__InquiryTemplateRCP__c InquiryTemplateRCPRecords: InquiryTemplateRCP)
        {
            InquiryTemplateRCPRecords.Source_ID__c = InquiryTemplateRCPRecords.Source_ID__c.substring(0,18);
        } update InquiryTemplateRCP;
        
        for(ffr__InquiryTemplateSortItem__c InquiryTemplateSortItemRecords: InquiryTemplateSortItem)
        {
            InquiryTemplateSortItemRecords.Source_ID__c = InquiryTemplateSortItemRecords.Source_ID__c.substring(0,18);
        } update InquiryTemplateSortItem;

        for(User UserSettings: UserRecord)
        {
            UserSettings.Source_ID__c = UserSettings.Source_ID__c.substring(0,18);
        } update UserRecord;    
                            
        if(!Test.isRunningTest())
        {
            MDOUpdateKey b = new MDOUpdateKey();
            database.executeBatch(b,5);
        }
    }
}