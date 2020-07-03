@isTest
public with sharing class MDOActualsBatch2test
{
    @isTest
    public static void testActualsBatch2()
    {
        pse__Proj__c Project1 = new pse__Proj__c(
            Name = 'Project1'
        );
        
        insert Project1;
    
        pse__Time_Period__c TimePeriod1 = new pse__Time_Period__c(
            Name = '2014/QTR1',
            pse__Type__c = 'Quarter',
            pse__Start_Date__c = date.parse('01/01/2014'),
            pse__End_Date__c = date.parse('03/31/2014')
        );
        
        insert TimePeriod1;
            
        pse__Project_Actuals__c ProjectActualsRecord1 = new pse__Project_Actuals__c(
            pse__Unique_Name__c = 'Project1.id+TimePeriod1.id',
            pse__Time_Period__c = TimePeriod1.id,
            pse__Project__c = Project1.id
        );
        
        insert ProjectActualsRecord1;
        
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Project__c From pse__Project_Actuals__c' ;
        MDOActualsBatch2 a = new MDOActualsBatch2(query);
        Database.executeBatch(a,50);
    }
}