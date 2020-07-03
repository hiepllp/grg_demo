global class DateMoveExpenseReport implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__First_Expense_Date__c, pse__Last_Expense_Date__c, pse__Billed__c, pse__Invoiced__c, pse__Admin_Global_Edit__c, pse__Audit_Notes__c FROM pse__Expense_Report__c WHERE pse__Billed__c = false AND pse__Invoiced__c = false';

    private  Integer DAYSMOVED;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Expense_Report__c> recordsToUpdate = new List<pse__Expense_Report__c>();
    
    global DateMoveExpenseReport(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Expense_Report__c> scope)
    {
        for(pse__Expense_Report__c e: scope)
        {
            IF(e.pse__First_Expense_Date__c != null)
            e.pse__First_Expense_Date__c += DAYSMOVED;
            
            IF(e.pse__Last_Expense_Date__c != null)
            e.pse__Last_Expense_Date__c += DAYSMOVED;
            
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
            DateMoveExpense batch = new DateMoveExpense(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }
    }
}