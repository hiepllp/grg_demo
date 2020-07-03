global class DateMoveExpense implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Billed__c, pse__Expense_Date__c, pse__Invoiced__c, pse__Admin_Global_Edit__c, pse__Audit_Notes__c FROM pse__Expense__c WHERE pse__Invoiced__c = false AND pse__Billed__c = false' ;

    private Integer DAYSMOVED;
    private String modeStart;
    private static final String AUDITNOTES = 'Date Shift';

    List<pse__Expense__c> recordsToUpdate = new List<pse__Expense__c>();
    
    global DateMoveExpense(Integer days)
    {
        DAYSMOVED = days;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< pse__Expense__c> scope)
    {
    
    List<appirio_core__Config_Value__c> calculationmode = [SELECT Id, Name, appirio_core__Value__c, appirio_core__Config_Option__r.Name  FROM appirio_core__Config_Value__c WHERE appirio_core__Config_Option__r.Name = 'CalculationMode'];
    
    IF(calculationmode != null)
    {
        modeStart = calculationmode[0].appirio_core__Value__c;
        calculationmode[0].appirio_core__Value__c = 'Scheduled';
        update calculationmode;
    }
        for(pse__Expense__c e: scope)
        {
            e.pse__Expense_Date__c += DAYSMOVED;
            e.pse__Admin_Global_Edit__c = true;
            e.pse__Audit_Notes__c = AUDITNOTES;

            recordsToUpdate.add(e);         
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
        update recordsToUpdate;
        
        List<appirio_core__Config_Value__c> calculationmode = [SELECT Id, Name, appirio_core__Value__c, appirio_core__Config_Option__r.Name  FROM appirio_core__Config_Value__c WHERE appirio_core__Config_Option__r.Name = 'CalculationMode'];
        
        IF(calculationmode != null)
        {
            calculationmode[0].appirio_core__Value__c = modeStart;
            update calculationmode;
        }
        
        if(!Test.isRunningTest())
    	{
            DateMoveScheduleEnd batch = new DateMoveScheduleEnd(DAYSMOVED);
            Id batchId = database.executeBatch(batch, 10 );
        }

    }
}