@isTest
public with sharing class MDOActualsBatch4test
{
    @isTest
    public static void testActualsBatch4()
    {
        pse__Practice__c Practice1 = new pse__Practice__c(
            Name = 'Practice1'
        );
        
        insert Practice1;
    
        pse__Time_Period__c TimePeriod1 = new pse__Time_Period__c(
            Name = '2014/QTR1',
            pse__Type__c = 'Quarter',
            pse__Start_Date__c = date.parse('01/01/2014'),
            pse__End_Date__c = date.parse('03/31/2014')
        );
        
        insert TimePeriod1;
            
        pse__Practice_Actuals__c PracticeActualsRecord1 = new pse__Practice_Actuals__c(
            pse__Unique_Name__c = 'Project1.id+TimePeriod1.id',
            pse__Time_Period__c = TimePeriod1.id,
            pse__Practice__c = Practice1.id
        );
        
        insert PracticeActualsRecord1;
        
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Practice__c From pse__Practice_Actuals__c' ;
        MDOActualsBatch4 a = new MDOActualsBatch4(query);
        Database.executeBatch(a,50);
    }
}