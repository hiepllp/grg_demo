trigger SCMSalesOrder on SCMC__Sales_Order__c (before insert) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        Id ffaCompanyId = SCMFFAUtilities.getDefaultFFACompany();
        if (ffaCompanyId == null) {
            for(SObject record: Trigger.new) {
                record.addError('You must be in single company mode.');
            }
        }
        
        SCMSalesOrderTriggerHandler handler = new SCMSalesOrderTriggerHandler();
        
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.OnBeforeInsert(Trigger.new);
        }
    }
}