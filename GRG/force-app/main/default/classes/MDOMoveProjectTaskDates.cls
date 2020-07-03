//this batch updates project tasks

global class MDOMoveProjectTaskDates implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, pse__Actual_End_Date_Time__c, pse__Actual_Start_Date_Time__c, End_Date1__c, pse__End_Date_Time__c, pse__Project__c, Start_Date1__c, pse__Start_Date_Time__c, pse__Summary__c FROM pse__Project_Task__c WHERE pse__Project__c != null AND pse__Summary__c = false';

    private static final Integer DAYSMOVED = 364;
    private static final String AUDITNOTES = 'Date Shift';
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List< pse__Project_Task__c> scope)
    {
        for(pse__Project_Task__c t: scope)
        {
            IF(t.pse__Actual_End_Date_Time__c != null)
            t.pse__Actual_End_Date_Time__c += DAYSMOVED;
            
            IF(t.pse__Actual_Start_Date_Time__c != null)
            t.pse__Actual_Start_Date_Time__c += DAYSMOVED;
            
            IF(t.End_Date1__c != null)
            t.End_Date1__c += DAYSMOVED;
            
            IF(t.pse__End_Date_Time__c != null)
            t.pse__End_Date_Time__c += DAYSMOVED;
            
            IF(t.Start_Date1__c != null)
            t.Start_Date1__c += DAYSMOVED;
            
            IF(t.pse__Start_Date_Time__c != null)
            t.pse__Start_Date_Time__c += DAYSMOVED;
            
            update t;
        }    
    }   
    global void finish(Database.BatchableContext BC)
    {
    }
}