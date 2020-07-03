/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_pse_Project_TaskTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_pse_Project_TaskTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new pse__Project_Task__c());
    }
}