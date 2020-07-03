public class SOAllocateController {
	
    private Id currentRecId = null;
    
	public SOAllocateController(ApexPages.StandardController controller) {
        currentRecId  = ApexPages.CurrentPage().getparameters().get('id');
    }
    
    public PageReference allocateAndApprove() {
        PageReference pg = null;
        SCMC__Sales_Order__c so = [SELECT SCMC__Status__c, SCMC__Shipment_Status__c,
                                    SCMC__Number_Lines__c FROM SCMC__Sales_Order__c
                                    WHERE Id=:currentRecId];
        if(so.SCMC__Status__c=='New' && so.SCMC__Shipment_Status__c=='Open'
           && so.SCMC__Number_Lines__c > 0) {
        	scmc.SalesOrderAPI scmc = new scmc.SalesOrderAPI();
            scmc.allocate(new List<ID>{currentRecId}, true);
            pg = new PageReference('/'+currentRecId);
            pg.setRedirect(true);       
        } else {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Order status should be open, shipment status should be open and number of lines should be > 0'));
        }
        
        return pg;
    }
}