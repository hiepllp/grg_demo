@isTest
public with sharing class MDOActualsBatch1test
{
    @isTest
    public static void testActualsBatch1()
    {
        Contact Resource1 = new Contact(
            FirstName = 'Matt',
            LastName = 'Byrne'
        );
        
        insert Resource1;
    
        pse__Time_Period__c TimePeriod1 = new pse__Time_Period__c(
            Name = '2014/QTR1',
            pse__Type__c = 'Quarter',
            pse__Start_Date__c = date.parse('01/01/2014'),
            pse__End_Date__c = date.parse('03/31/2014')
        );
        
        insert TimePeriod1;
            
        pse__Resource_Actuals__c ResourceActualsRecord1 = new pse__Resource_Actuals__c(
            pse__Unique_Name__c = 'Resource1.id+TimePeriod1.id',
            pse__Time_Period__c = TimePeriod1.id,
            pse__Resource__c = Resource1.id
        );
        
        insert ResourceActualsRecord1;
        
        string query = 'Select pse__Unique_Name__c, pse__Time_Period__c, pse__Resource__c From pse__Resource_Actuals__c' ;
        MDOActualsBatch1 a = new MDOActualsBatch1(query);
        Database.executeBatch(a,50);
        
    }
}