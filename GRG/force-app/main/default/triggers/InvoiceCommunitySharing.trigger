trigger InvoiceCommunitySharing on c2g__codaInvoice__c (before insert, before update) {

    for(c2g__codaInvoice__c inv : Trigger.New)
    {
        inv.Account_Name__c = inv.c2g__AccountName__c;
    }
}