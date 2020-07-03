public class SCMPurchaseOrderTriggerHandler {

    public void OnBeforeInsert(SCMC__Purchase_Order__c[] newPOs) {
        
        // set default PO company
        Id ffaCompanyId = SCMFFAUtilities.getDefaultFFACompany();

        for (SCMC__Purchase_Order__c po : newPOs) {
            if (po.SCMFFA__Company__c == null) {
                po.SCMFFA__Company__c = ffaCompanyId;
            }
        }
  }
    
}