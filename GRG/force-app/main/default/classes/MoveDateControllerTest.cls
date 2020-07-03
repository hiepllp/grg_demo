@isTest
public with sharing class MoveDateControllerTest
{   
    @isTest(SeeAllData=true)
    public static void controllerTest()
    {
        PageReference pageRef = Page.MoveDate;
        Test.setCurrentPageReference(pageRef);

        MoveDateController controller = new MoveDateController();
        
        controller.numberOfDays = 8;
        controller.MoveDates();
        controller.numberOfDays = 7;
        controller.MoveDates();
    }

    @isTest(SeeAllData=true)
    public static void DateMoveOpportunitiesTest()
    {  
        DateMoveOpportunities a = new DateMoveOpportunities(7);
        Database.executeBatch(a,200);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveProjectsTest()
    {  
        DateMoveProjects a = new DateMoveProjects(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveResourceRequestsTest()
    {  
        DateMoveResourceRequests a = new DateMoveResourceRequests(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveAssignmentsTest()
    {  
        DateMoveAssignments a = new DateMoveAssignments(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveExpenseReportTest()
    {  
        DateMoveExpenseReport a = new DateMoveExpenseReport(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveExpenseTest()
    {  
        DateMoveExpense a = new DateMoveExpense(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveScheduleEndTest()
    {  
        DateMoveScheduleEnd a = new DateMoveScheduleEnd(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveScheduleStartTest()
    {  
        DateMoveScheduleStart a = new DateMoveScheduleStart(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveScheduleExcTest()
    {  
        DateMoveScheduleExc a = new DateMoveScheduleExc(7);
        Database.executeBatch(a,200);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveTimecardsTest()
    {  
        DateMoveTimecards a = new DateMoveTimecards(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveTimecardSplitTest()
    {  
        DateMoveTimecardSplit a = new DateMoveTimecardSplit(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveMissingTimeTest()
    {  
        DateMoveMissingTime a = new DateMoveMissingTime(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveBillingEventTest()
    {  
        DateMoveBillingEvent a = new DateMoveBillingEvent(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveBillingItemTest()
    {  
        DateMoveBillingItem a = new DateMoveBillingItem(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveMilestoneTest()
    {  
        DateMoveMilestone a = new DateMoveMilestone(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveMiscAdjTest()
    {  
        DateMoveMiscAdj a = new DateMoveMiscAdj(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveRateCardTest()
    {  
        DateMoveRateCard a = new DateMoveRateCard(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveBudgetTest()
    {  
        DateMoveBudget a = new DateMoveBudget(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveUtilizationTest()
    {  
        DateMoveUtilization a = new DateMoveUtilization(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveUtilCalcTest()
    {  
        DateMoveUtilCalc a = new DateMoveUtilCalc(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveEstvsActTest()
    {  
        DateMoveEstvsAct a = new DateMoveEstvsAct(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveProjectTaskTest()
    {  
        DateMoveProjectTask a = new DateMoveProjectTask(7);
        Database.executeBatch(a,5);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveTaskTimeTest()
    {  
        DateMoveTaskTime a = new DateMoveTaskTime(7);
        Database.executeBatch(a,10);
    }
    
    @isTest(SeeAllData=true)
    public static void DateMoveContactTest()
    {  
        DateMoveContact a = new DateMoveContact(7);
        Database.executeBatch(a,200);
    }
}