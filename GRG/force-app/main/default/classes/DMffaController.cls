public with sharing class DMffaController {

    public integer years {get;set;}
    
    public DMffaController()
    {
        years = 1;
    }

    public PageReference MoveDates()
    {
        try
        {            
            //check for SDA key
            String SDAKey = [SELECT Id, c2g__SupportDataAccessKey__c FROM User WHERE Id =: UserInfo.getUserID()].c2g__SupportDataAccessKey__c;
            IF(SDAKey != null)
            {
                if(!Test.isRunningTest())
                {
                    DMYearRename batch = new DMYearRename(years);
                    Id batchId = database.executeBatch(batch );
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'All FFA Dates are being moved ' + years + ' years. You will be notified by email once complete.' ));
            }
            ELSE
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Cannot find SDA Key for your user.' ));
            }

            return null;
        } catch (DMLException e){
           ApexPages.addMessages(e);
       }
       return null;
   }
}