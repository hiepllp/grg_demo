trigger setProjectProduct on pse__Proj__c (before insert)
{
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        List<Product2> productList = [SELECT Id,Name FROM Product2 WHERE Name = 'SVCS: Professional Services' ORDER BY Name LIMIT 1];
        List<Product2> productListFP = [SELECT Id,Name FROM Product2 WHERE Name = 'SVCS: Professional Services Fixed' ORDER BY Name LIMIT 1];
        
        ID prodId = null;
        ID prodIdFP = null;
        
        if (productList.size() > 0) prodId = productList[0].Id;
        if (productListFP.size() > 0) prodIdFP = productListFP[0].Id;
        
        for (pse__Proj__c proj : Trigger.new)
        {
            if (proj.pse__Billing_Type__c == 'Fixed Price') if (proj != null) proj.ffpsai__ServicesProduct__c = prodIdFP;
            if (proj.pse__Billing_Type__c != 'Fixed Price') if (proj != null) proj.ffpsai__ServicesProduct__c = prodId;
        }
    }
}