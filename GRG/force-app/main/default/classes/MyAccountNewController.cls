public with sharing class MyAccountNewController {
    
	public static Account getUserAccount()
    {
        List<Contact> contactrecord = [SELECT Id, Account.Fax, Account.Description, Name, Email, Account.Id, Account.Name, Account.Phone, Account.Website FROM Contact WHERE FirstName =: UserInfo.getFirstName() AND LastName =: UserInfo.getLastName()];
        List<Contact> laurenrecord = [SELECT Id, Account.Fax, Account.Description, Name, Email, Account.Id, Account.Name, Account.Phone, Account.Website FROM Contact WHERE FirstName = 'Tim' LIMIT 1];

        IF(!contactrecord.isEmpty())
        {
            return contactrecord[0].Account;
        }
        else
        {
            return laurenrecord[0].Account;
        }
    }
    
    public static List<pse__Proj__c> getProjects()
    {
        List< pse__Proj__c > projectList = [SELECT ID, Name, Status__c, Financial__c, Schedule__c, pse__Account__c, pse__Start_Date__c, pse__End_Date__c, pse__Stage__c  FROM pse__Proj__c];
        return projectList;
    }
    
    public static integer getProjectsCompleted()
    {
        List< pse__Proj__c > projectList = [SELECT ID  FROM pse__Proj__c WHERE pse__Stage__c = 'Completed'];
        return projectList.size();
    }
    
    public static integer getProjectsProgress()
    {
        List< pse__Proj__c > projectList = [SELECT ID  FROM pse__Proj__c WHERE pse__Stage__c = 'In Progress'];
        return projectList.size();
    }
    
    public static integer getProjectsHold()
    {
        List< pse__Proj__c > projectList = [SELECT ID  FROM pse__Proj__c WHERE pse__Stage__c = 'On Hold'];
        return projectList.size();
    }
    
    public static integer getProjectsCanceled()
    {
        List< pse__Proj__c > projectList = [SELECT ID  FROM pse__Proj__c WHERE pse__Stage__c = 'Canceled'];
        return projectList.size();
    }

    public static integer getProjectsPlanned()
    {
        List< pse__Proj__c > projectList = [SELECT ID  FROM pse__Proj__c WHERE pse__Stage__c = 'Planned'];
        return projectList.size();
    }

}