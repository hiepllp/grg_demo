public class ProjectMassDeleteController {
    
    public string projectID {get;set;}
    public string status {get;set;}
    public string statusMessage {get;set;}
    
    public ProjectMassDeleteController(ApexPages.StandardController controller )
    {
        status = '';
        statusMessage = '';
        projectID = System.currentPageReference().getParameters().get('Id');
    }
    
    public PageReference massdelete()
    {
        try{
            delete [SELECT ID FROM pse__Timecard_Header__c WHERE pse__Project__c =: projectID];
            delete [SELECT ID FROM pse__Expense_Report__c WHERE pse__Project__c =: projectID];
            delete [SELECT ID FROM pse__Milestone__c WHERE pse__Project__c =: projectID];
            delete [SELECT ID FROM pse__Project_Task__c WHERE pse__Project__c =: projectID];
            delete [SELECT ID FROM pse__Resource_Request__c WHERE pse__Project__c =: projectID];
            delete [SELECT ID FROM pse__Budget__c WHERE pse__Project__c =: projectID];
            delete [SELECT ID FROM pse__Miscellaneous_Adjustment__c WHERE pse__Project__c =: projectID];
            delete [SELECT ID FROM pse__Assignment__c WHERE pse__Project__c =: projectID];
        	delete [SELECT ID FROM pse__Proj__c WHERE Id =: projectID];
            status = 'Gone';
            statusMessage = '';
            return null;
        } catch (Exception e)
        {
            status = 'Error';
            statusMessage = e.getMessage();
            return null;
        }
    }

}