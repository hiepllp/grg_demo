@isTest
public with sharing class UpdateAccountDrilldownTest
{
    //have had to use seeAllData as it is not possible to create reports via API and the account balance report is required in this batch apex.
    @isTest(seeAllData=true)
    public static void testWithoutSettings()
    {              
        List<c2g__AccountSettings__c> customSettings = [SELECT ID FROM c2g__AccountSettings__c];
        delete customSettings;
      
        UpdateAccountDrilldown a = new UpdateAccountDrilldown();
        database.executeBatch(a,30);
    }
    
    @isTest(seeAllData=true)
    public static void testWithSettings()
    {                    
        UpdateAccountDrilldown a = new UpdateAccountDrilldown();
        database.executeBatch(a,30);
    }
}