trigger SCMServiceContract on SCMC__Service_Order__c (before insert) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        Id ffaCompanyId = SCMFFAUtilities.getDefaultFFACompany();
        if (ffaCompanyId == null) {
            for(SObject record: Trigger.new) {
                record.addError('You must be in single company mode.');
            }
        }
        
        SCMServiceContractTriggerHandler handler = new SCMServiceContractTriggerHandler();
        
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.OnBeforeInsert(Trigger.new);
        }
    }
}