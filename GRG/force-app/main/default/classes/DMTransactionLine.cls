global class DMTransactionLine implements Database.Batchable<sObject>, Database.Stateful
{
    private static final String QUERY = 'SELECT Id, Name, c2g__AsOfDate__c, c2g__DateCanceled__c, c2g__DiscountDate1__c, c2g__DiscountDate2__c, c2g__DiscountDate3__c, c2g__DiscountDate4__c, c2g__DueDate__c FROM c2g__codaTransactionLineItem__c WHERE Moved__c = false AND Name < :COUNTMAX';
    private Integer YEARSMOVED; 
    private String COUNTMAX; 
    List<c2g__codaTransactionLineItem__c> recordsToUpdate = new List<c2g__codaTransactionLineItem__c>();

    global DMTransactionLine(Integer years, String recordlimit)
    {
        YEARSMOVED = years;
        COUNTMAX = recordlimit;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext BC, List< c2g__codaTransactionLineItem__c> scope)
    {
        for(c2g__codaTransactionLineItem__c x: scope)
        {
            if(x.Name < COUNTMAX)
            {
                if(x.c2g__AsOfDate__c != null)
                    x.c2g__AsOfDate__c = x.c2g__AsOfDate__c.addYears(YEARSMOVED);
    
                if(x.c2g__DateCanceled__c != null)
                    x.c2g__DateCanceled__c = x.c2g__DateCanceled__c.addYears(YEARSMOVED);
    
                if(x.c2g__DiscountDate1__c != null)
                    x.c2g__DiscountDate1__c = x.c2g__DiscountDate1__c.addYears(YEARSMOVED);
    
                if(x.c2g__DiscountDate2__c != null)
                    x.c2g__DiscountDate2__c = x.c2g__DiscountDate2__c.addYears(YEARSMOVED);
    
                if(x.c2g__DiscountDate3__c != null)
                    x.c2g__DiscountDate3__c = x.c2g__DiscountDate3__c.addYears(YEARSMOVED);
    
                if(x.c2g__DiscountDate4__c != null)
                    x.c2g__DiscountDate4__c = x.c2g__DiscountDate4__c.addYears(YEARSMOVED);
    
                if(x.c2g__DueDate__c != null)
                    x.c2g__DueDate__c = x.c2g__DueDate__c.addYears(YEARSMOVED);
    
                x.Moved__c = true;
                recordsToUpdate.add(x);
            }
        }
        update recordsToUpdate;
    }   
    global void finish(Database.BatchableContext BC)
    {        
        if(recordsToUpdate.size() == 0)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            String[] toAddresses = new String[] {UserInfo.getUserEmail()};  
            mail.setToAddresses(toAddresses);  
            mail.setSubject('Dates Moved');  
            string messageBody = 'The following objects have had their dates moved by ' + YEARSMOVED + ' years. '
                                +'<p>Bank Reconciliation</p>'
                                +'<p>Bank Statement</p>'
                                +'<p>Bank Statement Line Item</p>'
                                +'<p>Cancel Payment Criteria</p>'
                                +'<p>Cash Entries</p>'
                                +'<p>Cash Matching Histories</p>'
                                +'<p>Journals</p>'
                                +'<p>Payable Credit Notes</p>'
                                +'<p>Payable Credit Note Expense Line Item</p>'
                                +'<p>Payable Credit Note Line Item</p>'
                                +'<p>Payable Invoices</p>'
                                +'<p>Payable Invoice Expense Line Item</p>'
                                +'<p>Payable Invoice Line Item</p>'
                                +'<p>Payments</p>'
                                +'<p>Payment Line Item</p>'
                                +'<p>Payment Media Control</p>'
                                +'<p>Payment Media Detail</p>'
                                +'<p>Sales Credit Notes</p>'
                                +'<p>Sales Invoices</p>'
                                +'<p>Sales Invoice Installment Line Item</p>'
                                +'<p>Sales Invoice Line Item</p>'
                                +'<p>Transactions</p>'
                                +'<p>Transaction Line Items</p>';
            mail.SetHTMLBody(messageBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        else
        {
            if(!Test.isRunningTest())
            {
                  DMTransactionLine nextobject = new DMTransactionLine(YEARSMOVED,String.valueOf(integer.valueof(COUNTMAX) + 5));
                  Id batchprocessid = database.executeBatch(nextobject,100);
            }
        }

    }
}