@isTest
public with sharing class MDOActualsBatch5test
{
    @isTest
    public static void testActualsBatch5()
    {
        pse__Grp__c Group1 = new pse__Grp__c(
            Name = 'Group1'
        );
        
        insert Group1;
    
        pse__Time_Period__c TimePeriod1 = new pse__Time_Period__c(
            Name = '2014/QTR1',
            pse__Type__c = 'Quarter',
            pse__Start_Date__c = date.parse('01/01/2014'),
            pse__End_Date__c = date.parse('03/31/2014')
        );
        
        insert TimePeriod1;
            
        pse__Group_Actuals__c GroupActualsRecord1 = new pse__Group_Actuals__c(
            pse__Unique_Name__c = 'Group1.id+TimePeriod1.id',
            pse__Time_Period__c = TimePeriod1.id,
            pse__Group__c = Group1.id
        );
        
        insert GroupActualsRecord1;
        
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Group__c From pse__Group_Actuals__c' ;
        MDOActualsBatch5 a = new MDOActualsBatch5(query);
        Database.executeBatch(a,50);
    }
}