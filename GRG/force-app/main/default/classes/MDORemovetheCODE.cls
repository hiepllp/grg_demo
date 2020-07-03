global class MDORemovetheCODE implements Database.Batchable<sObject>
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
        List <ffr__DataView__c> DataView = [SELECT Id, Source_ID__c FROM ffr__DataView__c WHERE Source_ID__c != null];
        List <ffr__DataViewJoin__c> DataViewJoin = [SELECT Id, Source_ID__c FROM ffr__DataViewJoin__c WHERE Source_ID__c != null];
        List <ffr__DataViewAction__c> DataViewAction = [SELECT Id, Source_ID__c FROM ffr__DataViewAction__c WHERE Source_ID__c != null];
        List <ffr__DataViewField__c> DataViewField = [SELECT Id, Source_ID__c FROM ffr__DataViewField__c WHERE Source_ID__c != null];
        List <ffr__DataViewJoinFilter__c> DataViewJoinFilter = [SELECT Id, Source_ID__c FROM ffr__DataViewJoinFilter__c WHERE Source_ID__c != null];
        List <ffr__DataViewTransposeItem__c> DataViewTransposeItem = [SELECT Id, Source_ID__c FROM ffr__DataViewTransposeItem__c WHERE Source_ID__c != null];

        
        for(ffr__DataView__c DataViewRecords: DataView)
        {
            DataViewRecords.Source_ID__c = DataViewRecords.Source_ID__c.substring(0,18);
        } update DataView;
        
        for(ffr__DataViewJoin__c DataViewJoinRecords: DataViewJoin)
        {
            DataViewJoinRecords.Source_ID__c = DataViewJoinRecords.Source_ID__c.substring(0,18);
        } update DataViewJoin;
        
        for(ffr__DataViewAction__c DataViewActionRecords: DataViewAction)
        {
            DataViewActionRecords.Source_ID__c = DataViewActionRecords.Source_ID__c.substring(0,18);
        } update DataViewAction;
        
        for(ffr__DataViewField__c DataViewFieldRecords: DataViewField)
        {
            DataViewFieldRecords.Source_ID__c = DataViewFieldRecords.Source_ID__c.substring(0,18);
        } update DataViewField;
        
        for(ffr__DataViewJoinFilter__c DataViewJoinFilterRecords: DataViewJoinFilter)
        {
            DataViewJoinFilterRecords.Source_ID__c = DataViewJoinFilterRecords.Source_ID__c.substring(0,18);
        } update DataViewJoinFilter;
        
        for(ffr__DataViewTransposeItem__c DataViewTransposeItemRecords: DataViewTransposeItem)
        {
            DataViewTransposeItemRecords.Source_ID__c = DataViewTransposeItemRecords.Source_ID__c.substring(0,18);
        } update DataViewTransposeItem;
                    
        if(!Test.isRunningTest())
        {
        MDORemovetheCODE2 b = new MDORemovetheCODE2();
        database.executeBatch(b);
        }
    }
}