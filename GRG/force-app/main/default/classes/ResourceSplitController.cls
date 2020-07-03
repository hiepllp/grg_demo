public class ResourceSplitController{

    public ResourceSplitController(ApexPages.StandardController stdController) {
        CurrentPageId = ApexPages.currentPage().getParameters().get('Id');
        RRSplits();
    }

    public ResourceSplitController(ApexPages.StandardSetController stdController) {
        CurrentPageId = ApexPages.currentPage().getParameters().get('Id');
        RRSplits();
    }

 
    //Our collection of the class/wrapper objects wrapRR
    public List<wrapRR> wrapRRList {get; set;}
    public List<pse__Resource_Request__c > selectedRRs{get;set;}
    public List<pse__Region__c> RegionsList {get;set;}
    public List<Integer> RegionsCount {get;set;}
    public String CurrentPageId {get;set;}
     
    private void RRSplits(){
        
        if(wrapRRList == null) {
            wrapRRList = new List<wrapRR>();
            for(pse__Resource_Request__c  a: [SELECT Id, Name, pse__End_Date__c, pse__Start_Date__c, pse__Opportunity__c, pse__Resource_Role__c, pse__SOW_Hours__c,pse__Region__r.Name, pse__Region__c  FROM pse__Resource_Request__c WHERE pse__Opportunity__c =: CurrentPageId]) {
                // As each RR is processed we create a new wrapRR object and add it to the wrapRRList
                wrapRRList.add(new wrapRR(a));
            }
        }
        RegionsCount = new List<Integer>();
        RegionsList = [SELECT Id, Name FROM pse__Region__c ORDER BY Name];
        Integer counter = 0;
        for(pse__Region__c r : RegionsList)
        {
            RegionsCount.add(counter);
            counter = counter + 1;
        }
    }
    public PageReference goBack() { 
        PageReference pageRef = new PageReference('/' + CurrentPageId);
        return pageRef;
    }
    public PageReference processSelected() { 
        PageReference pageRef = apexpages.Currentpage();
        pageRef.setRedirect(true);
        for (wrapRR cw : wrapRRList) {
            Integer Totalpercent = 0;
            if (cw.selected)
            {
                List<pse__Resource_Request__c> newRecordsList = new List<pse__Resource_Request__c>();
                 
                for(Integer cc : RegionsCount)
                {
                    Totalpercent = Totalpercent + cw.RegionPercent[cc];
                     
                    //check if percentage is greater than 0 otherwise ignore.
                    if(cw.RegionPercent[cc] > 0)
                    {
                        pse__Resource_Request__c newRecord = new pse__Resource_Request__c(pse__Resource_Role__c = cw.RR.pse__Resource_Role__c, 
                                                                                        pse__SOW_Hours__c = (cw.RR.pse__SOW_Hours__c*cw.RegionPercent[cc])/100,
                                                                                        pse__Opportunity__c = cw.RR.pse__Opportunity__c,
                                                                                        pse__Region__c = RegionsList[cc].id,
                                                                                        pse__Start_Date__c = cw.RR.pse__Start_Date__c,
                                                                                        pse__End_Date__c  = cw.RR.pse__End_Date__c );
                         
                        //We will create all records at the end.
                        newRecordsList.add(newRecord);
                    }
                }
                if(Totalpercent != 100)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, cw.RR.Name + ' could not be split as the total came to ' + Totalpercent + '%'));
                    return null;
                }
                ELSE
                {
                    try {
                         insert newRecordsList;
                         delete cw.RR;
                    }catch (Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'An error occured: ' + e.getMessage()));
                    return null;
                    }
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, cw.RR.Name + ' was split.'));
                    return pageRef;
                }
             }
         }
        return null;
    }
 
    // This is our wrapper/container class. In this example a wrapper class contains both the standard salesforce object Account and a Boolean value
    public class wrapRR {
        public pse__Resource_Request__c RR {get; set;}
        public Boolean selected {get; set;}
        public List<Integer> RegionPercent {get; set;}
        
        public wrapRR(pse__Resource_Request__c  a) {
            RR = a;
            selected = false;
            RegionPercent = new List<Integer>();
            
            List<pse__Region__c> Regions = [SELECT Id, Name FROM pse__Region__c ORDER BY Name];

            for(pse__Region__c rg : Regions)
            {
                IF(a.pse__Region__r.Name == rg.Name)
                {
                    RegionPercent.add(100);
                }
                ELSE
                {
                    RegionPercent.add(0);
                }
            }
        }
    }
}