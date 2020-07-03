public class ManagedServicesLightningController {
    
    public string projectID {get;set;}
    public string status {get;set;}
    public string statusMessage {get;set;}
    
    public ManagedServicesLightningController(ApexPages.StandardController controller )
    {
        status = '';
        statusMessage = '';
        projectID = System.currentPageReference().getParameters().get('Id');
    }
    public PageReference createMonthlyMilestone() {
        pse__Proj__c project = [Select id, pse__Planned_Hours__c, pse__Billing_Type__c, pse__Bookings__c, Managed_Service_Term_Calculated__c, pse__Start_Date__c from pse__Proj__c where id = :projectID];
        if(project.pse__Billing_Type__c != 'Managed Services' || project.Managed_Service_Term_Calculated__c < 1 || project.pse__Bookings__c == null ) {  
            status = 'FAIL';
            statusMessage = 'The project does not meet one or more criteria. Billing Type = Managed Services, Manages Service Term Calculation < 1, Bookings = null.';
            return null;
        }
        
        Decimal amount = project.pse__Bookings__c / project.Managed_Service_Term_Calculated__c;
        Decimal plannedhours = 0;
        IF(project.pse__Planned_Hours__c != null)
        {
            plannedhours = project.pse__Planned_Hours__c / project.Managed_Service_Term_Calculated__c;
        }
        List<pse__Milestone__c> milestones = new List<pse__Milestone__c>();
        for(Integer i = 0; i< project.Managed_Service_Term_Calculated__c; i++) {
            pse__Milestone__c milestone = new pse__Milestone__c();
            milestone.pse__Project__c = project.Id;
            milestone.pse__Milestone_Amount__c = amount;
            milestone.pse__Planned_Hours__c = plannedhours;
            milestone.pse__Estimated_Time_To_Completion__c = plannedhours;
            milestone.ffrr_exp__StartDate__c = project.pse__Start_Date__c.addMonths(i);
            milestone.pse__Target_Date__c = project.pse__Start_Date__c.addMonths(i+1) - 1;
            //        milestone.pse__WBS__c = String.valueOf(i + 1) + '.0';
            //        milestone.Sort__c = i + 1;
            milestone.pse__Status__c = 'Planned';
            milestone.Name = 'Monthly Milestone ' + String.valueOf(i + 1);
            milestones.add(milestone);
        }  
        if(milestones.size() > 0) {
            insert milestones;
            status = 'SUCCESS';
            statusMessage = milestones.size() + ' Milestones were created.';
            return null;
        }
        else
            status = 'FAIL';
        statusMessage = 'No Milestones were created.';
        return null;
    }
}