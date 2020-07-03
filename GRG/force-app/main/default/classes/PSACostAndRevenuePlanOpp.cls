/*
 * Class for producing PSA Cost and Revenue Plan
 */
public with sharing class PSACostAndRevenuePlanOpp {
  
  private static final string dummySobjectType = 'Account';
  public static final string dummyFieldName = 'AnnualRevenue';
  
    /*
     * Utility method for creating a dummy sObject with a currency code and populating a currency field with amount.
     * Used as a workaround to get default display on VisualForce pages when binding to the field on the sObject.
     * We get the correct output string for the user's locale with the currency amount showing the currency specified.
     * 
     * @param  sObjectType    the sObjectType of the sObject to be returned.
     * @param  currencyIsoCode  the currency ISO code for the sObject.
     * @param  fieldName    the name of the currency field to set the amount.
     * @param  amount      the value to set for the currency field.
     * @returns          the created sObject.
     */
  private static sObject createDummySObject(string sObjectType,string currencyIsoCode,string fieldName,decimal amount){
    sObject dummyObject = Schema.getGlobalDescribe().get(sObjectType).newSObject() ;
    dummyObject.put('CurrencyIsoCode',currencyIsoCode);
    dummyObject.put(fieldName,amount);
    return dummyObject;
  }
  
    /*
     * Overloaded method.
     */
  private static sObject createDummySObject(string currencyIsoCode,decimal amount){
    return createDummySObject(dummySobjectType, currencyIsoCode, dummyFieldName, amount);
  }
  
    /*
     * Base Class to represent a Cost And Revenue Plan.
     */
  public virtual class CostAndRevenuePlanOpp{
        
        private final Id opportunityId;
        private final Opportunity opportunity;
        private list<AggregateResult> summaryRoleResults;
        private AggregateResult summary;
    public decimal totalHours{get; private set;}
    public decimal blendedCostRateTotal{get; private set;}
        public decimal blendedBillRateTotal{get;private set;}
      public sObject totalEstimatedCost{get;private set;}
      public sObject totalEstimatedRevenue{get;private set;}
        public sObject plannedMargin{get;set;}
    public list<CostPerRole> costsAndRevenuesPerRole{get;set;}
        public list<OpportunityLineItem> summaryOpportunityLineItems{get; private set;}
        
        /*
         * Default constructor.
         * @params  opportunityId  the sfdc Id of the Opportunity for which the Plan is being produced.
         */
    public CostAndRevenuePlanOpp(Id opportunityId){
            this.opportunityId = opportunityId;

            // get opportunity fields
            set<Id> opportunityIdSet = new set<Id>{opportunityId};
            this.opportunity = getOpportunitySummary(opportunityId);
            
            // get summaries per role.
      summaryRoleResults = new list<AggregateResult>();
      map<Id,list<AggregateResult>> summaryRoleResultMap = getOpportunitySummaryResultsPerRole(opportunityIdSet);
      if (!summaryRoleResultMap.isEmpty()){
        summaryRoleResults = summaryRoleResultMap.values()[0];  
      }
            
            this.totalHours = this.opportunity.Planned_Hours__c.setScale(2);
            
            // set total estimated cost and cost rate
            if(opportunity.Planned_Costs__c!=null){
               
                // set revenue totals
                this.totalEstimatedCost = createDummySObject(opportunity.Planned_Costs_Currency_Code__c, opportunity.Planned_Costs__c);
                if (this.totalHours!=0.0){
                    this.blendedCostRateTotal = (opportunity.Planned_Costs__c / this.totalHours).setScale(2);
                }
            }

            // planned margin
            if (opportunity.Planned_Revenue__c!=null && opportunity.Planned_Costs__c!=null && opportunity.Planned_Revenue_Currency_Code__c == opportunity.Planned_Costs_Currency_Code__c){
                this.plannedMargin = createDummySObject(opportunity.Planned_Revenue_Currency_Code__c,this.opportunity.Planned_Margin__c);
            }
    }

  }
  
    /*
     * Extended Class for Time and Materials specific Cost and Revenue Plan
     */
  public class TimeAndMaterialsCostAndRevenuePlanOpp extends CostAndRevenuePlanOpp{
        
    /*
         * Constructor
         * @params  opportunityId  the sfdc Id of the Opportunity for which the Plan is being produced.
         */
        public TimeAndMaterialsCostAndRevenuePlanOpp(Id opportunityId){
            super(opportunityId);

            // set total estimated revenue
            if (opportunity.Planned_Revenue__c!=null){
                this.totalEstimatedRevenue = createDummySObject(opportunity.Planned_Revenue_Currency_Code__c,opportunity.Planned_Revenue__c);
            }

            // set bill rate and add revenue lines per role to the list.
            this.costsAndRevenuesPerRole = new list<CostPerRole>();
            if (!summaryRoleResults.isEmpty()){
                for (AggregateResult result: summaryRoleResults){

                    // revenue lines per role.
                    this.costsAndRevenuesPerRole.add(new CostAndRevenuePerRole(result));
                }
                if (opportunity.Planned_Revenue__c!=null && this.totalHours!=0.0 && opportunity.Planned_Revenue_Currency_Code__c!=null){

                    // set revenue blended total.
                    this.blendedBillRateTotal = (opportunity.Planned_Revenue__c / this.totalHours).setScale(2);
                }
            }
        }  
    }
  
    /*
     * Extended Class for Fixed Price specific Cost and Revenue Plan
     */
    public class FixedPriceCostAndRevenuePlanOpp extends CostAndRevenuePlanOpp{
        
        /*
         * Constructor
         * @params  opportunityId  the sfdc Id of the Opportunity for which the Plan is being produced.
         */
        public FixedPriceCostAndRevenuePlanOpp(Id opportunityId){
            super(opportunityId);

            // set total estimated revenue using roll-up field for opportunity line items.
            if (opportunity.FIxed_Price_Planned_Revenue__c!=null){
                this.totalEstimatedRevenue = createDummySObject(opportunity.currencyIsoCode,opportunity.Fixed_Price_Planned_Revenue__c);
            }

            this.costsAndRevenuesPerRole = new list<CostPerRole>();

            // add cost lines per role to the list.
            for (AggregateResult result: summaryRoleResults){
                this.costsAndRevenuesPerRole.add(new CostPerRole(result));
            }

            // get opportunity line items for summary.
            this.summaryOpportunityLineItems = [select ProductName__c, ServiceDate, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where OpportunityId=:this.opportunityId and Include_In_Summary__c=true order by ServiceDate];

        }
        
    }
  
    /*
     * Base Class to represent Costs per role.
     */
  public virtual class CostPerRole{
        
    public Decimal totalHoursPerRole{get;set;}
    public String role{get;set;}
        public Decimal costRate{get;set;}
        public sObject cost{get; set;}
        public decimal billRate{get;set;}
    public sObject revenue{get;set;}
        
        /*
         * Constructor
         */
        public CostPerRole(AggregateResult result){
      this.role = (string)result.get('pse__Resource_Role__c');
      this.totalHoursPerRole = ((decimal)result.get('TotalHours')).setScale(2);
      this.cost = createDummySObject((string)result.get('pse__Average_Cost_Rate_Currency_Code__c'),(decimal)result.get('EstimatedCost'));
      
            // avoid division by 0
            if (this.totalHoursPerRole!=0.0){
                this.costRate = ((decimal)result.get('EstimatedCost')/this.totalHoursPerRole).setScale(2);
            }
        }
  }
  
    /*
     * Extended Class to represent Costs and Revenue per role.
     */
  public class CostAndRevenuePerRole extends CostPerRole{
        
        /*
         * Constructor
         */
    public CostAndRevenuePerRole(AggregateResult result){
      super(result);
      this.revenue = createDummySObject((string)result.get('currencyIsoCode'),(decimal)result.get('EstimatedRevenue'));

            // avoid division by 0
            if (this.totalHoursPerRole!=0.0){
             this.billRate = ((decimal)result.get('EstimatedRevenue')/this.totalHoursPerRole).setScale(2);
            }
        }
  }
    
    /*
     * Static method for updating summary fields on opportunities for a list of child resource requests.
     * @param  resourceRequests  the list of pse__resource_request__c objects to update the opportunities for.
     */
    public static void updateOpportunitiesFromResourceRequests(list<pse__resource_request__c> resourceRequests){
        
        // get set of opportunity Ids
        Set<ID> opportunityIds = new Set<ID>();
        for (pse__Resource_Request__c resourceRequest : resourceRequests) {
            if(resourceRequest.pse__Opportunity__c!=null) opportunityIds.add(resourceRequest.pse__Opportunity__c);
        }
        
        // update opportunities.
        update summariseOpportunities(opportunityIds);
    }

    /*
     * Static method for getting list of summarised opportunities from opportunity Ids.
     * @param   opportunityIds  the set of Opportunity Ids to create summarised Opportunities for.
     * @returns                 a list of Opportunities that have summary fields populated.
     */
    private static list<Opportunity> summariseOpportunities(set<Id> opportunityIds){
        
        // get Aggregate Results
        map<Id,AggregateResult> summaries = getOpportunitySummaryResults(opportunityIds);
        map<Id,string> costCurrencies = getCostCurrencyPerOpportunity(opportunityIds);
        map<Id,string> revenueCurrencies = getRevenueCurrencyPerOpportunity(opportunityIds);

        // create list of opportunities
        list<Opportunity> opportunities = new list<Opportunity>();

        for(Id opportunityId : opportunityIds){
          Opportunity opp = new Opportunity(Id=opportunityId);
          if (summaries.containsKey(opportunityId)){
            // summary returned for opportunity. ie there is at least one resource request.
            AggregateResult summary = summaries.get(opportunityId);
              string costCurrencyCode = (string)costCurrencies.get(opportunityId);
              string revenueCurrencyCode = (string)revenueCurrencies.get(opportunityId);
  
              // summarise total hours
              opp.Planned_Hours__c = (decimal)summary.get('TotalHours');
  
              // summarise estimated cost
              if(costCurrencyCode!=null){
                  opp.Planned_Costs_Currency_Code__c = costCurrencyCode;
                  opp.Planned_Costs__c = (decimal)summary.get('EstimatedCost');
              } else {
                  opp.Planned_Costs_Currency_Code__c = null;
                  opp.Planned_Costs__c = null;   
              }
  
              // summarise estimated revenue
              if(revenueCurrencyCode!=null){
                  opp.Planned_Revenue_Currency_Code__c = revenueCurrencyCode;
                  opp.Planned_Revenue__c = (decimal)summary.get('EstimatedRevenue');
              } else {
                  opp.Planned_Revenue_Currency_Code__c = null;
                  opp.Planned_Revenue__c = null;    
              }
          } else {
            // all resource requests deleted.
            opp.Planned_Revenue_Currency_Code__c = null;
              opp.Planned_Revenue__c = null;
              opp.Planned_Costs_Currency_Code__c = null;
              opp.Planned_Costs__c = null;
              opp.Planned_Hours__c = null;
          }

            opportunities.add(opp);
        }
        return opportunities;    
    }

    /*
     * Static method for getting a map of opportunity summaries based on resource request child objects.
     * @param   opportunityIds  the set of Opportunity Ids to retrieve summaries for.
     * @returns                 a map of AggregateResult records that summarise the resource requests for the opportunities.
     */
    private static map<Id,AggregateResult> getOpportunitySummaryResults(set<Id> opportunityIds){
        return new map<Id,AggregateResult>([select pse__Opportunity__c Id, sum(pse__SOW_Hours__c) TotalHours, sum(Estimated_Cost__c) EstimatedCost, sum(pse__Request_Billable_Amount__c) EstimatedRevenue 
                                      from pse__resource_request__c where pse__Opportunity__c in:opportunityIds
                                      group by pse__Opportunity__c]);
                                      
        
    }

    /*
     * Static method for getting a map of opportunity summaries based on resource request child objects, split by Role.
     * @param   opportunityIds  the set of Opportunity Ids to retrieve summaries for.
     * @returns                 a map of AggregateResult records that summarise the resource requests per role for the opportunities.
     */
    private static map<Id,list<AggregateResult>> getOpportunitySummaryResultsPerRole(set<Id> opportunityIds){
        list<AggregateResult> summaryResultsPerRole = [select pse__Opportunity__c, pse__Resource_Role__c, currencyIsoCode,pse__Average_Cost_Rate_Currency_Code__c, sum(pse__SOW_Hours__c) TotalHours, sum(Estimated_Cost__c) EstimatedCost, sum(pse__Request_Billable_Amount__c) EstimatedRevenue 
                            from pse__resource_request__c where pse__Opportunity__c in:opportunityIds
                            group by pse__Opportunity__c, pse__Resource_Role__c, CurrencyIsoCode,pse__Average_Cost_Rate_Currency_Code__c];
        map<Id, list<AggregateResult>> summaryResultsMap = new map<Id, list<AggregateResult>>();
        for (AggregateResult summaryResult : summaryResultsPerRole){
            if (summaryResultsMap.containsKey((Id)summaryResult.get('pse__Opportunity__c'))){
                summaryResultsMap.get((Id)summaryResult.get('pse__Opportunity__c')).add(summaryResult);
            } else {
                summaryResultsMap.put((Id)summaryResult.get('pse__Opportunity__c'),new List<AggregateResult>{summaryResult});
            }
        }
        return summaryResultsMap;
    }

    /*
     * Static method for getting a map of Revenue currency ISO codes for opportunities based on child resource requests.
     * If there are multiple revenue currency ISO codes amongst the resource requests then the code is set to null.
     * @param   opportunityIds  the set of Opportunity Ids to retrieve currency codes for.
     * @returns                 a map of currency ISO codes for opportunity Ids.
     */
    private static map<Id,string> getRevenueCurrencyPerOpportunity(set<Id> opportunityIds){
      list<AggregateResult> revenueCurrencies = [select count(Id), pse__Opportunity__c, CurrencyIsoCode
                                                        from pse__resource_request__c where pse__Opportunity__c in:opportunityIds 
                                                        group by pse__Opportunity__c,CurrencyIsoCode];
        map<Id,string> revenueCurrencyMap = new map<Id,string>();
        for (AggregateResult revenueCurrency : revenueCurrencies){
            if (!revenueCurrencyMap.containsKey((Id)revenueCurrency.get('pse__Opportunity__c'))){
                revenueCurrencyMap.put((Id)revenueCurrency.get('pse__Opportunity__c'),(string)revenueCurrency.get('currencyIsoCode'));
            } else {
                revenueCurrencyMap.put((Id)revenueCurrency.get('pse__Opportunity__c'),null);
            }
        }
        return revenueCurrencyMap;
    }

    /*
     * Static method for getting a map of COst currency ISO codes for opportunities based on child resource requests.
     * If there are multiple cost currency ISO codes amongst the resource requests then the code is set to null.
     * @param   opportunityIds  the set of Opportunity Ids to retrieve currency codes for.
     * @returns                 a map of currency ISO codes for opportunity Ids.
     */
    private static map<Id,string> getCostCurrencyPerOpportunity(set<Id> opportunityIds){
      list<AggregateResult> costCurrencies = [select count(Id), pse__Opportunity__c, pse__Average_Cost_Rate_Currency_Code__c
                                                    from pse__resource_request__c where pse__Opportunity__c in:opportunityIds 
                                                    group by pse__Opportunity__c, pse__Average_Cost_Rate_Currency_Code__c];
        map<Id,string> costCurrencyMap = new map<Id,string>();
        for (AggregateResult costCurrency : costCurrencies){
            if (!costCurrencyMap.containsKey((Id)costCurrency.get('pse__Opportunity__c'))){
                costCurrencyMap.put((Id)costCurrency.get('pse__Opportunity__c'),(string)costCurrency.get('pse__Average_Cost_Rate_Currency_Code__c'));
            } else {
                // more than one currency, set to null.
                costCurrencyMap.put((Id)costCurrency.get('pse__Opportunity__c'),null);
            }
        }
        return costCurrencyMap;
    }

    /*
     * Static method for getting an Opportunity object from database with summary fields populated.
     * @param   opportunityId  the Opportunity Id of the object to be returned.
     * @returns                 the opportunity object.
     */
    private static Opportunity getOpportunitySummary(Id opportunityId){
        return [select Planned_Hours__c, Planned_Costs__c, Planned_Costs_Currency_Code__c, Planned_Revenue__c, Fixed_Price_Planned_Revenue__c, Planned_Revenue_Currency_Code__c, Planned_Margin__c, Planned_Margin_Pct__c, CurrencyIsoCode from Opportunity where Id=:opportunityId];
    }
   
}