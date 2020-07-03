/*
 * Controller extension on the  Opportunity standard controller for the Cost And Revenue Plan visuaforce page.
 */
public with sharing class PSACostAndRevenuePlanOppController {
    
    public PSACostAndRevenuePlanOpp.CostAndRevenuePlanOpp costAndRevenuePlanOpp {get;set;}
    public List<OpportunityLineItem> HybridProducts {get;set;}
    public string dummyFieldName{get;private set;}
    
    /*
     * Default Extension constructor.
     */
    public PSACostAndRevenuePlanOppController(ApexPages.StandardController opportunityStandardController){

        opportunity opp = (opportunity)opportunityStandardController.getRecord();
        IF(opp.Billing_Type__c == 'Time and Materials' || opp.Billing_Type__c=='Multi-Element')
        {
            //check if resource requests exist
            Integer RRcount = [SELECT count() FROM pse__Resource_Request__c WHERE pse__Opportunity__c =: opp.id];
            IF(RRcount > 0)
            {
                // set the Cost and Revenue Plan object to an instance of extended classes dependent on billing type.
                costAndRevenuePlanOpp = new PSACostAndRevenuePlanOpp.TimeAndMaterialsCostAndRevenuePlanOpp(opp.Id);    
                if (opp.Billing_Type__c=='Multi-Element')
                {
                    HybridProducts = [select ProductName__c, ServiceDate, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where OpportunityId=:opp.Id and Include_In_Summary__c=true order by ServiceDate]; 
                }
            }
            IF(RRcount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'A ' + opp.Billing_Type__c + ' Cost and Revenue Summary is not possible without Resource Requests.'));
            }
        }
        ELSE IF(opp.Billing_Type__c == 'Fixed Price')
        {
            //check if resource requests exist
            Integer OLIcount = [SELECT count() FROM OpportunityLineItem WHERE OpportunityId =: opp.id];
            IF(OLIcount > 0)
            {
                    costAndRevenuePlanOpp = new PSACostAndRevenuePlanOpp.FixedPriceCostAndRevenuePlanOpp(opp.Id);
			}
            IF(OLIcount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'A ' + opp.Billing_Type__c + ' Cost and Revenue Summary is not possible without at least one product.'));
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