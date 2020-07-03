public class SCMSalesOrderTriggerHandler {

    public void OnBeforeInsert(SCMC__Sales_Order__c[] newSOs) {
        
        // set default SO company
        Id ffaCompanyId = SCMFFAUtilities.getDefaultFFACompany();

        for (SCMC__Sales_Order__c so : newSOs) {
            if (so.SCMFFA__Company__c == null) {
                so.SCMFFA__Company__c = ffaCompanyId;
            }
        }
  }
    
}