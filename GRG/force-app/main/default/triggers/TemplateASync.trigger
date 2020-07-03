//this trigger updates the Async checkbox whenever a project is setup as a template so that SOQL query error is avoided.

trigger TemplateASync on pse__Proj__c (before insert) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        for(pse__Proj__c pro : Trigger.New)
        {
            if (pro.pse__Is_Template__c == true) {
                pro.pse__Copy_Child_Records_from_Template_Async__c = true;
            }
        }
    }
}