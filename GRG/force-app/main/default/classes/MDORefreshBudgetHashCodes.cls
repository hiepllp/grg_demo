//MDOUpdateInquiryTemplateSort was before this
global class MDORefreshBudgetHashCodes implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'Select Id, Name, c2g__localGLA__c, c2g__GeneralLedgerAccount__c, c2g__Dimension1__c, c2g__Dimension2__c, c2g__Dimension3__c, c2g__Dimension4__c, c2g__Account__c, c2g__Product__c, c2g__BankAccount__c, c2g__TaxCode__c, c2g__Year__c, c2g__OwnerCompany__c, c2g__IntersectDefinition__c, c2g__HashCode__c from c2g__codaBudget__c';
        return Database.getQueryLocator(query);
    }
        
    global void execute(Database.BatchableContext BC, List<c2g__codaBudget__c> batch) {

        for(c2g__codaBudget__c budget: batch)
        {
            String hashCode = '';
            
            if (budget.c2g__GeneralLedgerAccount__c != null) 
                hashCode += '#' + budget.c2g__GeneralLedgerAccount__c;
            if (budget.c2g__localGLA__c != null) 
                hashCode += '#' + budget.c2g__localGLA__c;
            if (budget.c2g__Dimension1__c != null) 
                hashCode += '#' + budget.c2g__Dimension1__c;
            if (budget.c2g__Dimension2__c != null) 
                hashCode += '#' + budget.c2g__Dimension2__c;
            if (budget.c2g__Dimension3__c != null) 
                hashCode += '#' + budget.c2g__Dimension3__c;
            if (budget.c2g__Dimension4__c != null) 
                hashCode += '#' + budget.c2g__Dimension4__c;
            if (budget.c2g__Account__c != null)
                hashCode += '#' + budget.c2g__Account__c;
            if (budget.c2g__Product__c != null)
                hashCode += '#' + budget.c2g__Product__c;
            if (budget.c2g__BankAccount__c != null)
                hashCode += '#' + budget.c2g__BankAccount__c;
            if (budget.c2g__TaxCode__c != null)
                hashCode += '#' + budget.c2g__TaxCode__c;
            
            hashCode = budget.c2g__OwnerCompany__c + hashCode + '#' + budget.c2g__Year__c + '#' + budget.c2g__IntersectDefinition__c;
            
            budget.c2g__HashCode__c = hashCode;
        }
        try{
        update batch;
        } catch(Exception e) {
        
        }
    }
    
    global void finish(Database.BatchableContext BC) {

        if(!Test.isRunningTest())
        {        
            UpdateAccountDrilldown a = new UpdateAccountDrilldown();
            database.executeBatch(a,50);
        }
    
    }

}