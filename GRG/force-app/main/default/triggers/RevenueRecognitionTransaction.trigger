/*
* FinancialForce.com, inc. claims copyright in this software, its screen display designs and 
* supporting documentation. FinancialForce and FinancialForce.com are trademarks of FinancialForce.com, inc. 
* Any unauthorized use, copying or sale of the above may constitute an infringement of copyright and may 
* result in criminal or other legal proceedings. 
*
* Copyright FinancialForce.com, inc. All rights reserved.
*/ 

trigger RevenueRecognitionTransaction on ffrr__RevenueRecognitionTransaction__c (after update) 
{
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        RevenueRecognitionTransactionTrigger handler = 
            new RevenueRecognitionTransactionTrigger(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        
        //    if(Trigger.isAfter && Trigger.isUpdate)
        //        handler.afterUpdate(); 
    }
}