@isTest
public with sharing class MDOMoveProjectTaskDatesTest
{
    @isTest
    public static void testMoveProjectTasks()
    {
        pse__Proj__c projectRecord1 = new pse__Proj__c(
            Name = 'Design Project'
            );
        insert projectRecord1;
    
        pse__Project_Task__c projectTask1 = new pse__Project_Task__c(
            Name = 'Design',
            pse__Actual_End_Date_Time__c = date.parse('04/04/2015'), 
            pse__Actual_Start_Date_Time__c = date.parse('01/01/2015'), 
            End_Date1__c = date.parse('04/04/2015'), 
            pse__End_Date_Time__c = date.parse('04/04/2015'), 
            Start_Date1__c = date.parse('01/01/2015'), 
            pse__Start_Date_Time__c = date.parse('01/01/2015'),
            pse__project__c = projectRecord1.Id);
        insert projectTask1; 
        
        MDOMoveProjectTaskDates p = new MDOMoveProjectTaskDates();
        database.executeBatch(p);
    }
}