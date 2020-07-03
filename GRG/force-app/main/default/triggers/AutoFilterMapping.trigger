trigger AutoFilterMapping on ffr__ReportingFilterMapping__c (after insert, after update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        //the code below may not be the most efficient but it works as a POC. Currently inactive
        for(ffr__ReportingFilterMapping__c mapping : Trigger.New)
        {
            //get the filter details
            ffr__ReportingFilter__c filterdetails = [SELECT ID, Name, ffr__Value__c, ffr__Description__c FROM ffr__ReportingFilter__c WHERE ID =: mapping.ffr__ReportingFilter__c LIMIT 1];
            IF(filterdetails.ffr__Value__c.countMatches('name":"c2g__codaPeriod__c') >0)
            {            
                //we need to get the definition id via the data range
                ffr__ReportingDataRange__c datarange = [SELECT ID, Name, ffr__ReportingDefinition__c FROM ffr__ReportingDataRange__c WHERE ID = : mapping.ffr__ReportingDataRange__c];
                
                //we need to check if there are any accounting period prompts
                List<ffr__ReportingPrompt__c> prompt = [SELECT ID, Name, ffr__ReportingDefinition__c  FROM ffr__ReportingPrompt__c WHERE ffr__ReportingDefinition__c = : datarange.ffr__ReportingDefinition__c AND ffr__Type__c = 'Accounting Period'];
                IF(prompt.size() == 1)
                {
                    //delete any existing prompt mappings
                    List<ffr__ReportingPromptMapping__c> existingpromptmappings = [SELECT ID FROM ffr__ReportingPromptMapping__c WHERE ffr__ReportingFilter__c =: filterdetails.Id AND ffr__ReportingPrompt__c =: prompt[0].Id];
                    delete existingpromptmappings;
                    
                    String filterValue = filterdetails.ffr__Value__c;
                    List<ffr__ReportingPromptMapping__c> mappingsList = new List<ffr__ReportingPromptMapping__c>();
                    do
                    {
                        //create new prompt mapping
                        ffr__ReportingPromptMapping__c newmapping = new ffr__ReportingPromptMapping__c();
                        newmapping.ffr__PromptTag__c = filterValue.subStringBetween('###','###');
                        newmapping.ffr__ReportingFilter__c = filterdetails.Id;
                        newmapping.ffr__ReportingPrompt__c = prompt[0].Id;
                        mappingsList.add(newmapping);
                        
                        Integer position = filterValue.indexOf('###');
                        Integer length = filterValue.length();
                        filterValue = filterValue.right(length-position-20);
                        
                    }while (filterValue.contains('###'));
                    insert mappingsList;
                }
            }
        }
    }
}