trigger SCMPurchaseOrder on SCMC__Purchase_Order__c (before insert) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        Id ffaCompanyId = SCMFFAUtilities.getDefaultFFACompany();
        if (ffaCompanyId == null) {
            for(SObject record: Trigger.new) {
                record.addError('You must be in single company mode.');
            }
        }
        
        SCMPurchaseOrderTriggerHandler handler = new SCMPurchaseOrderTriggerHandler();
        
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.OnBeforeInsert(Trigger.new);
        }
    }
}