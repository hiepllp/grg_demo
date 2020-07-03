public with sharing class MoveDateController {

    public Integer numberOfDays {get;set;}

    public MoveDateController()
    {
        numberOfDays = 7;
    }
    
    public PageReference MoveDates()
    {        
        try
        {
            IF(math.mod(numberOfDays,7)==0)
            {
                IF(!test.isRunningTest())
                {
                DateMoveOpportunities oppbatch = new DateMoveOpportunities(numberOfDays);
                Id batchId = database.executeBatch(oppbatch, 10 );
                }

                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'All PSA Dates are being moved ' + numberOfDays + ' days.' ));
                return null;
            }

            ELSE
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'The days to move forward must be a multiple of 7.' ));
                return null;
            }
        } catch (DMLException e){
           ApexPages.addMessages(e);
       }
       return null;
   }
}