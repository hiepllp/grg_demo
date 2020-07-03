global class DateMoveMiscAdj implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Admin_Global_Edit__c, pse__Audit_Notes__c, pse__Effective_Date__c, pse__Bill_Date__c, pse__Invoice_Date__c, pse__Invoiced__c, pse__Billed__c, pse__Include_In_Financials__c FROM pse__Miscellaneous_Adjustment__c WHERE pse__Include_In_Financials__c = false';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Miscellaneous_Adjustment__c> recordsToUpdate = new List<pse__Miscellaneous_Adjustment__c>();
    
    global DateMoveMiscAdj(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Miscellaneous_Adjustment__c> scope)
    {
        for(pse__Miscellaneous_Adjustment__c e: scope)
        {
            e.pse__Effective_Date__c += DAYSMOVED;
            
            IF(e.pse__Bill_Date__c != null)
                e.pse__Bill_Date__c += DAYSMOVED;
            
            IF(e.pse__Invoice_Date__c != null)
                e.pse__Invoice_Date__c += DAYSMOVED;
            
            e.pse__Admin_Global_Edit__c = true;
      		e.pse__Audit_Notes__c = AUDITNOTES;

            recordsToUpdate.add(e);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        if(!Test.isRunningTest())
    	{
            DateMoveRateCard batch = new DateMoveRateCard(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}