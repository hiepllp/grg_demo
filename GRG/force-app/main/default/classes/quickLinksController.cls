public with sharing class quickLinksController 
{    
    public List< Month_End_Procedures__c > getProcedures() 
    {  
        List<Month_End_Procedures__c > monthEndPro = [SELECT Id, Name, Procedure_Location__c, Hyperlink__c FROM Month_End_Procedures__c WHERE Period__c = null ORDER BY Name];
        return monthEndPro;
    }
}