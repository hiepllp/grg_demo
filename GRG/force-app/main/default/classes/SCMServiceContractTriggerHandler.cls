public class SCMServiceContractTriggerHandler {

    public void OnBeforeInsert(SCMC__Service_Order__c[] newSCs) {
        
        // set default SC company
        Id ffaCompanyId = SCMFFAUtilities.getDefaultFFACompany();

        for (SCMC__Service_Order__c sc : newSCs) {
            if (sc.SCMFFA__Company__c == null) {
                sc.SCMFFA__Company__c = ffaCompanyId;
            }
        }
  }
    
}