/*
 * Class for producing PSA Cost and Revenue Plan
 */
public with sharing class PSACostAndRevenuePlan {
    
    private static final string dummySobjectType = 'Account';
    public static final string dummyFieldName = 'AnnualRevenue';
    
    private static Boolean milestoneProcessed = false;
    /*
     * Utility method for creating a dummy sObject with a currency code and populating a currency field with amount.
     * Used as a workaround to get default display on VisualForce pages when binding to the field on the sObject.
     * We get the correct output string for the user's locale with the currency amount showing the currency specified.
     * 
     * @param   sObjectType     the sObjectType of the sObject to be returned.
     * @param   currencyIsoCode the currency ISO code for the sObject.
     * @param   fieldName       the name of the currency field to set the amount.
     * @param   amount          the value to set for the currency field.
     * @returns                 the created sObject.
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
    public virtual class CostAndRevenuePlan{
        
        private final Id objectId;
        private final Opportunity opportunity;
        private final pse__Proj__c project;
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
        public list<pse__Milestone__c> summaryMilestones{get; private set;}
        
        /*
         * Default constructor.
         * @params  objectId    the sfdc Id of the Opportunity for which the Plan is being produced.
         */
        public CostAndRevenuePlan(Id objectId, String objectAPI){
            this.objectId = objectId;
            if(objectAPI.equalsIgnoreCase('Opportunity')) {
                // get opportunity fields
                set<Id> opportunityIdSet = new set<Id>{objectId};
                this.opportunity = getOpportunitySummary(objectId);
                
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
            } else {
                // get project fields
                set<Id> projectIdSet = new set<Id>{objectId};
                this.project = getProjectSummary(objectId);
                
                // get summaries per role.
                summaryRoleResults = new list<AggregateResult>();
                map<Id,list<AggregateResult>> summaryRoleResultMap = getProjectSummaryResultsPerRole(projectIdSet);
                system.debug('summaryRoleResultMap====>>>>'+summaryRoleResultMap);
                if (summaryRoleResultMap != null && summaryRoleResultMap.size() > 0){
                    summaryRoleResults = summaryRoleResultMap.get(objectId);    
                }
                
                this.totalHours = this.project.pse__Planned_Hours__c;
                
                // set total estimated cost and cost rate
                if(project.Planned_Costs__c!=null){
                   
                    // set revenue totals
                    this.totalEstimatedCost = createDummySObject(project.Planned_Costs_Currency_Code__c, project.Planned_Costs__c);
                    if (this.totalHours!=0.0){
                        this.blendedCostRateTotal = (project.Planned_Costs__c / this.totalHours).setScale(2);
                    }
                }
    
                // planned margin
                if (project.Planned_Revenue__c!=null && project.Planned_Costs__c!=null && project.Planned_Revenue_Currency_Code__c == project.Planned_Costs_Currency_Code__c){
                    this.plannedMargin = createDummySObject(project.Planned_Revenue_Currency_Code__c,this.project.Planned_Margin__c);
                }
            }
        }

    }
    
    /*
     * Extended Class for Time and Materials specific Cost and Revenue Plan
     */
    public class TimeAndMaterialsCostAndRevenuePlan extends CostAndRevenuePlan{
        
        /*
         * Constructor
         * @params  objectId    the sfdc Id of the Opportunity for which the Plan is being produced.
         */
        public TimeAndMaterialsCostAndRevenuePlan(Id objectId, String objectAPI){
            super(objectId, objectAPI);
            if(objectAPI.equalsIgnoreCase('Opportunity')) {
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
            } else {
                
                // set total estimated revenue
                if (project.Planned_Revenue__c!=null){
                    this.totalEstimatedRevenue = createDummySObject(project.Planned_Revenue_Currency_Code__c,project.Planned_Revenue__c);
                }
    
                // set bill rate and add revenue lines per role to the list.
                this.costsAndRevenuesPerRole = new list<CostPerRole>();
                if (!summaryRoleResults.isEmpty()){
                    for (AggregateResult result: summaryRoleResults){
    
                        // revenue lines per role.
                        this.costsAndRevenuesPerRole.add(new CostAndRevenuePerRole(result));
                    }
                    if (project.Planned_Revenue__c!=null && this.totalHours!=0.0 && project.Planned_Revenue_Currency_Code__c!=null){
    
                        // set revenue blended total.
                        this.blendedBillRateTotal = (project.Planned_Revenue__c / this.totalHours).setScale(2);
                    }
                }
            
            }
        }
    }
    
    /*
     * Extended Class for Fixed Price specific Cost and Revenue Plan
     */
    public class FixedPriceCostAndRevenuePlan extends CostAndRevenuePlan{
        
        /*
         * Constructor
         * @params  objectId    the sfdc Id of the Opportunity for which the Plan is being produced.
         *          objectAPI   the API name of the concerned object
         */
        public FixedPriceCostAndRevenuePlan(Id objectId, String objectAPI){
            super(objectId, objectAPI);
            if(objectAPI.equalsIgnoreCase('Opportunity')) {
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
                this.summaryOpportunityLineItems = [select Name, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where opportunityId=:this.objectId and Include_In_Summary__c=true];
    
            } else {
                
                // set total estimated revenue using roll-up field for opportunity line items.
                if (project.Fixed_Price_Planned_Revenue__c!=null){
                    this.totalEstimatedRevenue = createDummySObject(project.currencyIsoCode,project.FIxed_Price_Planned_Revenue__c);
                }
    
                this.costsAndRevenuesPerRole = new list<CostPerRole>();
    
                // add cost lines per role to the list.
                for (AggregateResult result: summaryRoleResults){
                    this.costsAndRevenuesPerRole.add(new CostPerRole(result));
                }
    
                // get summaryMilestones for summary.
                this.summaryMilestones = [select Name, pse__Target_Date__c, pse__Milestone_Amount__c from pse__Milestone__c where pse__Project__c = :this.objectId and Include_In_Summary__c=true];
            
            }
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
     * @param   resourceRequests    the list of pse__resource_request__c objects to update the opportunities for.
     */
    public static void updateOpportunitiesFromResourceRequests(list<pse__resource_request__c> resourceRequests){
        
        // get set of opportunity Ids
        Set<ID> opportunityIds = new Set<ID>();
        set<ID> projectIds = new set<ID>();
        for (pse__Resource_Request__c resourceRequest : resourceRequests) {
            if(resourceRequest.pse__Opportunity__c!=null) opportunityIds.add(resourceRequest.pse__Opportunity__c);
            if(resourceRequest.pse__Project__c!=null) projectIds.add(resourceRequest.pse__Project__c);
        }
        
        // update opportunities.
        update summariseOpportunities(opportunityIds);
        update summariseProjects(projectIds);
    }

/* Opportunity specific methods start here*/
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
/* Opportunity specific methods end here*/

/* Project specific methods start here*/
    /*
     * Static method for getting an Project object from database with summary fields populated.
     * @param   projectId  the Project Id of the object to be returned.
     * @returns                 the project object.
     */
    private static pse__Proj__c getProjectSummary(Id projectId){
        return [SELECT pse__Planned_Hours__c, Fixed_Price_Planned_Revenue__c, Planned_Costs__c, Planned_Costs_Currency_Code__c, Planned_Revenue__c, Planned_Revenue_Currency_Code__c, Planned_Margin__c, Planned_Margin_Pct__c, CurrencyIsoCode from pse__Proj__c where Id=:projectId];
    }
    
    /*
     * Static method for getting list of summarised projects from project Ids.
     * @param   projectIds  the set of project Ids to create summarised projects for.
     * @returns                 a list of projects that have summary fields populated.
     */
    private static list<pse__Proj__c> summariseProjects(set<Id> projectIds){
        
        // get Aggregate Results
        map<Id,AggregateResult> summaries = getProjectSummaryResults(projectIds);
        map<Id,string> costCurrencies = getCostCurrencyPerProject(projectIds);
        map<Id,string> revenueCurrencies = getRevenueCurrencyPerProject(projectIds);

        // create list of opportunities
        list<pse__Proj__c> projects = new list<pse__Proj__c>();

        for(Id projectId : projectIds){
            pse__Proj__c project = new pse__Proj__c(Id=projectId);
            if (summaries.containsKey(projectId)){
                // summary returned for opportunity. ie there is at least one resource request.
                AggregateResult summary = summaries.get(projectId);
                string costCurrencyCode = (string)costCurrencies.get(projectId);
                string revenueCurrencyCode = (string)revenueCurrencies.get(projectId);
    
                // summarise total hours
                project.pse__Planned_Hours__c = (decimal)summary.get('TotalHours');
    
                // summarise estimated cost
                if(costCurrencyCode!=null){
                    project.Planned_Costs_Currency_Code__c = costCurrencyCode;
                    project.Planned_Costs__c = (decimal)summary.get('EstimatedCost');
                } else {
                    project.Planned_Costs_Currency_Code__c = null;
                    project.Planned_Costs__c = null;   
                }
    
                // summarise estimated revenue
                if(revenueCurrencyCode!=null){
                    project.Planned_Revenue_Currency_Code__c = revenueCurrencyCode;
                    project.Planned_Revenue__c = (decimal)summary.get('EstimatedRevenue');
                } else {
                    project.Planned_Revenue_Currency_Code__c = null;
                    project.Planned_Revenue__c = null;    
                }
            } else {
                // all resource requests deleted.
                project.Planned_Revenue_Currency_Code__c = null;
                project.Planned_Revenue__c = null;
                project.Planned_Costs_Currency_Code__c = null;
                project.Planned_Costs__c = null;
                project.pse__Planned_Hours__c = null;
            }

            projects.add(project);
        }
        return projects;    
    }
    
    /*
     * Static method for getting a map of project summaries based on resource request child objects.
     * @param   projectIds  the set of project Ids to retrieve summaries for.
     * @returns                 a map of AggregateResult records that summarise the resource requests for the projects.
     */
    private static map<Id,AggregateResult> getProjectSummaryResults(set<Id> projectIds){
        return new map<Id,AggregateResult>([select pse__Project__c Id, sum(pse__SOW_Hours__c) TotalHours, sum(Estimated_Cost__c) EstimatedCost, sum(pse__Request_Billable_Amount__c) EstimatedRevenue 
                                                from pse__resource_request__c where pse__Project__c in:projectIds
                                                group by pse__Project__c]);
                                                
            
    }
    
    /*
    * Static method for getting a map of project summaries based on resource request child objects, split by Role.
    * @param   projectIds  the set of Opportunity Ids to retrieve summaries for.
    * @returns                 a map of AggregateResult records that summarise the resource requests per role for the opportunities.
    */
    private static map<Id,list<AggregateResult>> getProjectSummaryResultsPerRole(set<Id> projectIds){
        list<AggregateResult> summaryResultsPerRole = [select pse__Project__c, pse__Resource_Role__c, currencyIsoCode,pse__Average_Cost_Rate_Currency_Code__c, sum(pse__SOW_Hours__c) TotalHours, sum(Estimated_Cost__c) EstimatedCost, sum(pse__Request_Billable_Amount__c) EstimatedRevenue 
                            from pse__resource_request__c where pse__Project__c in:projectIds
                            group by pse__Project__c, pse__Resource_Role__c, CurrencyIsoCode,pse__Average_Cost_Rate_Currency_Code__c];
        map<Id, list<AggregateResult>> summaryResultsMap = new map<Id, list<AggregateResult>>();
        for (AggregateResult summaryResult : summaryResultsPerRole){
            if (summaryResultsMap.containsKey((Id)summaryResult.get('pse__Project__c'))){
                summaryResultsMap.get((Id)summaryResult.get('pse__Project__c')).add(summaryResult);
            } else {
                summaryResultsMap.put((Id)summaryResult.get('pse__Project__c'),new list<AggregateResult>{summaryResult});
            }
        }
        return summaryResultsMap;
    }
    
    /*
     * Static method for getting a map of Revenue currency ISO codes for projects based on child resource requests.
     * If there are multiple revenue currency ISO codes amongst the resource requests then the code is set to null.
     * @param   projectIds  the set of project Ids to retrieve currency codes for.
     * @returns                 a map of currency ISO codes for project Ids.
     */
    private static map<Id,string> getRevenueCurrencyPerProject(set<Id> projectIds){
      list<AggregateResult> revenueCurrencies = [select count(Id), pse__Project__c, CurrencyIsoCode
                                                        from pse__resource_request__c where pse__Project__c in:projectIds 
                                                        group by pse__Project__c,CurrencyIsoCode];
        map<Id,string> revenueCurrencyMap = new map<Id,string>();
        for (AggregateResult revenueCurrency : revenueCurrencies){
            if (!revenueCurrencyMap.containsKey((Id)revenueCurrency.get('pse__Project__c'))){
                revenueCurrencyMap.put((Id)revenueCurrency.get('pse__Project__c'),(string)revenueCurrency.get('currencyIsoCode'));
            } else {
                revenueCurrencyMap.put((Id)revenueCurrency.get('pse__Project__c'),null);
            }
        }
        return revenueCurrencyMap;
    }

     /*
     * Static method for getting a map of COst currency ISO codes for projects based on child resource requests.
     * If there are multiple cost currency ISO codes amongst the resource requests then the code is set to null.
     * @param   projectIds  the set of project Ids to retrieve currency codes for.
     * @returns                 a map of currency ISO codes for project Ids.
     */
    private static map<Id,string> getCostCurrencyPerProject(set<Id> projectIds){
      list<AggregateResult> costCurrencies = [select count(Id), pse__Project__c, pse__Average_Cost_Rate_Currency_Code__c
                                                    from pse__resource_request__c where pse__Project__c in:projectIds 
                                                    group by pse__Project__c, pse__Average_Cost_Rate_Currency_Code__c];
        map<Id,string> costCurrencyMap = new map<Id,string>();
        for (AggregateResult costCurrency : costCurrencies){
            if (!costCurrencyMap.containsKey((Id)costCurrency.get('pse__Project__c'))){
                costCurrencyMap.put((Id)costCurrency.get('pse__Project__c'),(string)costCurrency.get('pse__Average_Cost_Rate_Currency_Code__c'));
            } else {
                // more than one currency, set to null.
                costCurrencyMap.put((Id)costCurrency.get('pse__Project__c'),null);
            }
        }
        return costCurrencyMap;
    }
    
    /*
     * Static method for creating the milestones whenever a project is created.
     * @param   projectList  the list of newly created Projects
     */
    public static void createMilestones(list<pse__Proj__c> projectList) {
        if(!milestoneProcessed) { //to avoid recurrance
            map<Id,Id> opportunityToMileStoneIdMap = new map<Id,Id>();
            //fetch the Fixed Price Projects
            for(pse__Proj__c project: projectList) {
                if((project.pse__Billing_Type__c == 'Fixed Price' || project.pse__Billing_Type__c == 'Multi-Element') && project.pse__Opportunity__c != null) {
                        opportunityToMileStoneIdMap.put(project.pse__Opportunity__c, project.id);
                }
            }
            if(opportunityToMileStoneIdMap.size() > 0) {
                //fetch respective OppLineItems
                list<OpportunityLineItem> opliList = [select id, Name, ServiceDate, Planned_Hours__c, TotalPrice, ProductName__c, OpportunityId, CurrencyIsoCode from OpportunityLineItem where opportunityId IN :opportunityToMileStoneIdMap.keySet() and Include_In_Summary__c=true];
                
                list<pse__Milestone__c> milestoneCreateList = new list<pse__Milestone__c>();
                
                //create milestone for each OLI
                for(OpportunityLineItem opli: opliList) {
                    pse__Milestone__c milestone = new pse__Milestone__c(Name = opli.ProductName__c,
                                                                            pse__Target_Date__c = opli.ServiceDate,
                                                                            pse__Milestone_Amount__c = opli.TotalPrice,
                                                                            CurrencyIsoCode = opli.CurrencyIsoCode,
                                                                            Include_In_Summary__c = true,
                                                                            OPLI_Id__c = opli.id,
                                                                            pse__Planned_Hours__c = opli.Planned_Hours__c,
                                                                            pse__Project__c = opportunityToMileStoneIdMap.get(opli.OpportunityId));
                    milestoneCreateList.add(milestone);
                }
                insert milestoneCreateList;
            }
            milestoneProcessed = true; //static flag to avoid recurssion
        }
    }
    
    /*
     * Static method for updating the milestion whever an OLI is created, updated or deleted
     * @param   oldMap  trigger.oldMap for the OLI
     *          newMap  trigger.newMap for the OLI
     *          isInsert    trigger.isInsert
     *          isUpdate    trigger.isUpdate
     *          isDelete    trigger.isDelete
     */
    public static void updateMilestones(map<Id, OpportunityLineItem> oldMap, map<Id, OpportunityLineItem> newMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete) {
        list<pse__Milestone__c> deleteMilestoneList = new list<pse__Milestone__c>();
        list<pse__Milestone__c> upsertMilestoneList = new list<pse__Milestone__c>();
        map<Id,list<Id>> opportunityToMileStoneIdMap = new map<Id,list<Id>>();
        
        //fetch the respective projects in case of insert/update
        if(isInsert || isUpdate) {
            set<Id> opportunityId = new set<Id>();
            for(OpportunityLineItem opli: newMap.values()) {
                opportunityId.add(opli.opportunityId);
            }
            if(opportunityId.size() > 0) {
                list<pse__Proj__c> projectList = [Select id, pse__Billing_Type__c, pse__Opportunity__c FROM pse__Proj__c WHERE pse__Opportunity__c IN : opportunityId];
                
                if(projectList.size() > 0) {
                    for(pse__Proj__c project: projectList) {
                        if((project.pse__Billing_Type__c == 'Fixed Price' || project.pse__Billing_Type__c == 'Multi-Element') && project.pse__Opportunity__c != null) {
                                if(opportunityToMileStoneIdMap.containsKey(project.pse__Opportunity__c)) {
                                    list<Id> projectId = opportunityToMileStoneIdMap.get(project.pse__Opportunity__c);
                                    projectId.add(project.id);
                                    opportunityToMileStoneIdMap.put(project.pse__Opportunity__c, projectId);
                                } else {
                                    opportunityToMileStoneIdMap.put(project.pse__Opportunity__c, new list<Id> {project.id});
                                }
                        }
                    }
                }
            }
             
        }
        if(isInsert) {
            //In case of insert, simply insert a Milestone
            for(OpportunityLineItem opli: newMap.values()) {
                if(opli.Include_In_Summary__c) {
                    if(opportunityToMileStoneIdMap.containsKey(opli.OpportunityId)) {
                        for(Id projectId: opportunityToMileStoneIdMap.get(opli.OpportunityId)) {
                            pse__Milestone__c milestone = new pse__Milestone__c(Name = opli.ProductName__c,
                                                                                    pse__Target_Date__c = opli.ServiceDate,
                                                                                    pse__Milestone_Amount__c = opli.TotalPrice,
                                                                                    CurrencyIsoCode = opli.CurrencyIsoCode,
                                                                                    Include_In_Summary__c = true,
                                                                                    OPLI_Id__c = opli.id,
                                                                                    pse__Project__c = projectId);
                            upsertMilestoneList.add(milestone);
                        }
                    }
                }
            }
        } else if(isUpdate){
            //In case of update, firstly update the Milestone
            map<id, OpportunityLineItem> oliMap = new map<id, OpportunityLineItem>([Select Name, ServiceDate, TotalPrice, CurrencyIsoCode, id, OpportunityId FROM OpportunityLineItem WHERE  Id IN : newMap.keyset()]);
            map<id,pse__Milestone__c> opliToMilestoneMap = new map<id,pse__Milestone__c>(); 
            list<pse__Milestone__c> milestoneList = [SELECT id, Name, pse__Target_Date__c, pse__Milestone_Amount__c, Include_In_Summary__c, OPLI_Id__c, pse__Project__c FROM pse__Milestone__c WHERE OPLI_id__c IN: newMap.keyset()];
            if(milestoneList.size() > 0) {
                for(pse__Milestone__c milestone: milestoneList) {
                    OpportunityLineItem opli = newMap.get(milestone.OPLI_Id__c);
                    milestone.Name = opli.ProductName__c;
                    milestone.pse__Target_Date__c = opli.ServiceDate;
                    milestone.pse__Milestone_Amount__c = opli.TotalPrice;
                    milestone.pse__Planned_Hours__c = opli.Planned_Hours__c;
                    milestone.Include_In_Summary__c = opli.Include_In_Summary__c ;
                    opliToMilestoneMap.put(milestone.OPLI_Id__c, milestone);
                    upsertMilestoneList.add(milestone);
                }
            }
            for(Id id: oldMap.keyset()) {
                //If the IncludeInSummary flag is modified, create/delete the Milestone accordingly
                if(oldMap.get(id).Include_In_Summary__c == false && newMap.get(id).Include_In_Summary__c == true) {
                    //create new milestone
                    OpportunityLineItem opli = oliMap.get(id);
                    for(Id projectId: opportunityToMileStoneIdMap.get(opli.OpportunityId)) {
                        pse__Milestone__c milestone = new pse__Milestone__c(Name = opli.ProductName__c,
                                                                                pse__Target_Date__c = opli.ServiceDate,
                                                                                pse__Milestone_Amount__c = opli.TotalPrice,
                                                                                CurrencyIsoCode = opli.CurrencyIsoCode,
                                                                                Include_In_Summary__c = true,
                                                                                OPLI_Id__c = opli.id,
                                                                                pse__Project__c = projectId);
                        system.debug('upsertMilestoneList===>>'+upsertMilestoneList);
                        upsertMilestoneList.add(milestone);
                        system.debug('upsertMilestoneList===>>'+upsertMilestoneList);
                    }
                } else if(oldMap.get(id).Include_In_Summary__c == true && newMap.get(id).Include_In_Summary__c == false) {
                    if(opliToMilestoneMap.containsKey(id))
                        deleteMilestoneList.add(opliToMilestoneMap.get(id));
                }
            }
        } else if(isDelete){
            //In case of delete, simply delete the milestone
            deleteMilestoneList = [SELECT id FROM pse__Milestone__c WHERE OPLI_Id__c IN: oldMap.keyset()];
        }
        if(upsertMilestoneList.size() > 0)
            upsert upsertMilestoneList;
        if(deleteMilestoneList.size() > 0)
            delete deleteMilestoneList;
    }
    
    /*
     * Static method to summarize the milestone data on Project 
     * @param   milestoneList  the list of conncerned milestones
     */
    public static void summarizeMilestones(list<pse__Milestone__c> milestoneList) {
        set<Id> projectIds = new set<Id>();
        list<pse__Proj__c> projectList = new list<pse__Proj__c>();
        Map<Id,pse__Proj__c> projectMap = new Map<Id,pse__Proj__c>();

        
        //Fetch the desired project ids
        for(pse__Milestone__c milestone: milestoneList) {
            projectIds.add(milestone.pse__Project__c);
        }
        
        //new code 11 May
        List<pse__Milestone__c> milestones = [SELECT Id, pse__Milestone_Amount__c, pse__Project__c FROM pse__Milestone__c WHERE pse__Project__c IN :projectIds];
        
        for(pse__Milestone__c mil : milestones)
        {
            IF(projectMap.containsKey(mil.pse__Project__c))
            {
                pse__Proj__c project = projectMap.get(mil.pse__Project__c);
            	project.Fixed_Price_Planned_Revenue__c = project.Fixed_Price_Planned_Revenue__c + mil.pse__Milestone_Amount__c;
                projectMap.put(mil.pse__Project__c,project);
            }
            ELSE
            {
                pse__Proj__c project = new pse__Proj__c(id = mil.pse__Project__c);
                project.Fixed_Price_Planned_Revenue__c = mil.pse__Milestone_Amount__c;
                projectMap.put(mil.pse__Project__c,project);
            }
        }
        projectList = projectMap.values();
        update projectList;
        /* This is the old code but multi-currency doesnt work for aggregations
        //fetch the summary for all the projects
        list<AggregateResult> summarizedMilestone = [SELECT sum(pse__Milestone_Amount__c) TotalAmount, pse__Project__c project FROM pse__Milestone__c WHERE pse__Project__c IN :projectIds GROUP BY pse__Project__c];
        
        //Update the project with summary
        for(AggregateResult summary: summarizedMilestone) {
            pse__Proj__c project = new pse__Proj__c(id = String.valueOf(summary.get('project')));
            project.Fixed_Price_Planned_Revenue__c = (decimal) summary.get('TotalAmount');
            projectList.add(project);
        }
        update projectList;
		*/
    }
/* Project specific methods end here*/
}