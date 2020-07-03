public class billingdocumentpdfcontroller {

    static String recordId {get;set;}
    public Decimal totalTax {get;set;}
    
    public billingdocumentpdfcontroller(ApexPages.StandardController controller)
    {
        recordId = controller.getRecord().Id;
        totalTax = 0;
    }

    public static Account getDocAccount()
    {
        Id accountId = [SELECT Id, fferpcore__Account__c FROM fferpcore__BillingDocument__c WHERE Id =: recordId].fferpcore__Account__c;
        Account accountrecord = [SELECT Id, BillingStreet, BillingCity, BillingCountry, BillingPostalCode, BillingState, ShippingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, Name FROM Account WHERE Id =: accountId LIMIT 1];
            return accountrecord;
    }
    
    public List<fferpcore__Company__c>  getDocCompany()
    {
        Id companyId = [SELECT Id, fferpcore__Company__c FROM fferpcore__BillingDocument__c WHERE Id =: recordId].fferpcore__Company__c;
        List<fferpcore__Company__c> companyrecord = [SELECT Id, fferpcore__LogoURL__c, fferpcore__Website__c, Name, fferpcore__Street__c,fferpcore__City__c ,fferpcore__State__c ,fferpcore__Zip__c ,fferpcore__Country__c FROM fferpcore__Company__c WHERE Id =: companyId LIMIT 1];
            return companyrecord;
    }
    public List<fferpcore__BillingDocumentLineItem__c> getDocLines()
    {
        List<fferpcore__BillingDocumentLineItem__c> billingLines = [SELECT Id, ffbc__ContractType__c, fferpcore__ProductService__r.ffbc__BillingType__c, ffbc__ContractLineItem__r.ffbc__Description__c, fferpcore__TaxValueTotal__c, Name, fferpcore__LineDescription__c , fferpcore__Quantity__c, fferpcore__UnitPrice__c, fferpcore__NetValue__c, fferpcore__ProductService__r.Name, fferpcore__ProductService__r.Description  FROM fferpcore__BillingDocumentLineItem__c WHERE fferpcore__BillingDocument__c  =: recordId ORDER BY fferpcore__ProductService__r.ffbc__BillingType__c];
        for(fferpcore__BillingDocumentLineItem__c bl : billingLines)
        {
            totalTax += bl.fferpcore__TaxValueTotal__c; 
        }
        return billingLines;
    }
    
}