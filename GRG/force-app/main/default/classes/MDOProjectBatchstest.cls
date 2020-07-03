@isTest
public with sharing class MDOProjectBatchstest
{
    @isTest
    public static void testProjectBatch1()
    {
        pse__Proj__c Project1 = new pse__Proj__c(
            Name = 'Project1',
            pse__Project_ID_Chain__c = ''
        );
        
        insert Project1;
                    
        string query1 = 'Select pse__Project_ID_Chain__c, Id From pse__Proj__c'; 
        MDOProjectBatch1 batchObject1 = new MDOProjectBatch1(query1);
        Database.executeBatch(batchObject1,50);
    }
    @isTest
    public static void testProjectBatch2()
    {
        pse__Region__c Region1 = new pse__Region__c(
            Name = 'Region1',
            pse__Region_ID_Chain__c = ''
        );
        
        insert Region1;
                    
        string query2 = 'Select pse__Region_ID_Chain__c From pse__Region__c'; 
        MDOProjectBatch2 batchObject2 = new MDOProjectBatch2(query2);
        Database.executeBatch(batchObject2,50);
    }
    @isTest
    public static void testProjectBatch3()
    {
        pse__Practice__c Practice1 = new pse__Practice__c(
            Name = 'Practice1',
            pse__Practice_ID_Chain__c = ''
        );
        
        insert Practice1;
                    
        string query3 = 'Select pse__Practice_ID_Chain__c From pse__Practice__c'; 
        MDOProjectBatch3 batchObject3 = new MDOProjectBatch3(query3);
        Database.executeBatch(batchObject3,50);
    }
    @isTest
    public static void testProjectBatch4()
    {
        pse__Grp__c Group1 = new pse__Grp__c(
            Name = 'Group1',
            pse__Group_ID_Chain__c = ''
        );
        
        insert Group1;
                    
        string query4 = 'Select pse__Group_ID_Chain__c From pse__Grp__c'; 
        MDOProjectBatch4 batchObject4 = new MDOProjectBatch4(query4);
        Database.executeBatch(batchObject4,50);
    }
}