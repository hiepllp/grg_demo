public with sharing class PSACostAndRevenuePlanForProject {
    public PSACostAndRevenuePlan.CostAndRevenuePlan costAndRevenuePlan{get;set;}
    public string dummyFieldName{get;private set;}
    public List<pse__Milestone__c> HybridProducts {get;set;}
    
    /*
     * Default Extension constructor.
     */
    public PSACostAndRevenuePlanForProject(ApexPages.StandardController projectStandardController){

        pse__Proj__c project = (pse__Proj__c)projectStandardController.getRecord();
        IF(project.pse__Billing_Type__c == 'Time and Materials' || project.pse__Billing_Type__c=='Multi-Element')
        {
            //check if resource requests exist
            Integer RRcount = [SELECT count() FROM pse__Resource_Request__c WHERE pse__Project__c =: project.id];
            IF(RRcount > 0)
            {
                // set the Cost and Revenue Plan object to an instance of extended classes dependent on billing type.
                costAndRevenuePlan = new PSACostAndRevenuePlan.TimeAndMaterialsCostAndRevenuePlan(project.id, 'pse__Proj__c');    
                if (project.pse__Billing_Type__c=='Multi-Element')
                {
                    HybridProducts = [select Name, pse__Milestone_Amount__c, pse__Target_Date__c from pse__Milestone__c where pse__Project__c=:project.Id]; 
                }
            }
            IF(RRcount == 0)
            {
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'A Cost and Revenue Summary is not possible without at least one resource request.'));
            }
        }
        ELSE IF(project.pse__Billing_Type__c == 'Fixed Price')
        {
            //check if resource requests exist
            Integer RRcount = [SELECT count() FROM pse__Resource_Request__c WHERE pse__Project__c =: project.id];
            IF(RRcount > 0)
            {
                    costAndRevenuePlan = new PSACostAndRevenuePlan.FixedPriceCostAndRevenuePlan(project.Id, 'pse__Proj__c');
			}
            IF(RRcount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'A ' + project.pse__Billing_Type__c + ' Cost and Revenue Summary is not possible without at least one resource request.'));
            }
        }
        ELSE
        {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The Billing Type must be Time and Materials, Fixed Price, or Multi-Element.'));
        }

        //get the dummy name field for displaying currencies from the static field on the cost and revenue plan class.
        dummyFieldName = PSACostAndRevenuePlan.dummyFieldName;
    
    }
}