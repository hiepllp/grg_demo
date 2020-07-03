public with sharing class DemoSetupBundlesController
{    
    
    public DemoSetupBundlesController()
    {
    }
        
    //these are the bundle jobs
    public List<ffct__BundleJob__c > getbundlejobs(){
        List<ffct__BundleJob__c > jobs = [SELECT Id, Name, Post_Install_Class_Name__c, Author__c, Documentation_Link__c, Short_Description__c FROM ffct__BundleJob__c ORDER BY CreatedDate DESC];
        return jobs;
    }
}