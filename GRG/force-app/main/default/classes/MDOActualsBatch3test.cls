@isTest
public with sharing class MDOActualsBatch3test
{
    @isTest
    public static void testActualsBatch3()
    {
        pse__Region__c Region1 = new pse__Region__c(
            Name = 'Region1'
        );
        
        insert Region1;
    
        pse__Time_Period__c TimePeriod1 = new pse__Time_Period__c(
            Name = '2014/QTR1',
            pse__Type__c = 'Quarter',
            pse__Start_Date__c = date.parse('01/01/2014'),
            pse__End_Date__c = date.parse('03/31/2014')
        );
        
        insert TimePeriod1;
            
        pse__Regional_Actuals__c RegionActualsRecord1 = new pse__Regional_Actuals__c(
            pse__Unique_Name__c = 'Project1.id+TimePeriod1.id',
            pse__Time_Period__c = TimePeriod1.id,
            pse__Region__c = Region1.id
        );
        
        insert RegionActualsRecord1;
        
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Region__c From pse__Regional_Actuals__c' ;
        MDOActualsBatch3 a = new MDOActualsBatch3(query);
        Database.executeBatch(a,50);
    }
}