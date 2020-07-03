public with sharing class MyAccountWelcomeController
{    
    public static Account getUserAccount()
    {
        List<Contact> contactrecord = [SELECT Id, Name, Email, Account.Id FROM Contact WHERE FirstName =: UserInfo.getFirstName() AND LastName =: UserInfo.getLastName()];
        IF(!contactrecord.isEmpty())
        {
            return contactrecord[0].Account;
        }
        else
        {
            return null;
        }
    }
    public static List<c2g__codaInvoice__c> getInvoices()
    {
        List< c2g__codaInvoice__c > invoiceList = [SELECT ID, Name, c2g__OutstandingValue__c, c2g__DueDate__c  FROM c2g__codaInvoice__c WHERE c2g__OutstandingValue__c <> 0 AND c2g__Account__c =: getUserAccount().id ORDER BY c2g__DueDate__c];
        return invoiceList;
    }
    public static Integer getProjectsGreen()
    {
        List< pse__Proj__c > projectsList = [SELECT ID, Name, pse__Project_Status__c  FROM pse__Proj__c WHERE pse__Account__c =: getUserAccount().id AND pse__Project_Status__c = 'Green'];
        return projectsList.size();
    }
    public static Integer getProjectsYellow()
    {
        List< pse__Proj__c > projectsList = [SELECT ID, Name, pse__Project_Status__c  FROM pse__Proj__c WHERE pse__Account__c =: getUserAccount().id AND pse__Project_Status__c = 'Yellow'];
        return projectsList.size();
    }
    public static Integer getProjectsRed()
    {
        List< pse__Proj__c > projectsList = [SELECT ID, Name, pse__Project_Status__c  FROM pse__Proj__c WHERE pse__Account__c =: getUserAccount().id AND pse__Project_Status__c = 'Red'];
        return projectsList.size();
    }
    
    public static Integer getInvoicePaid()
    {
        List< c2g__codaInvoice__c > totalPaid = [SELECT ID, Name, c2g__PaymentStatus__c FROM c2g__codaInvoice__c WHERE c2g__Account__c =: getUserAccount().id AND c2g__PaymentStatus__c = 'Paid'];
        return totalPaid.size();
    }
    public static Integer getInvoiceUnpaid()
    {
        List< c2g__codaInvoice__c > totalUnpaid = [SELECT ID, Name, c2g__PaymentStatus__c FROM c2g__codaInvoice__c WHERE c2g__Account__c =: getUserAccount().id AND c2g__PaymentStatus__c = 'Unpaid'];
        return totalUnpaid.size();
    }
    public static Integer getInvoicePartPaid()
    {
        List< c2g__codaInvoice__c > totalPartPaid = [SELECT ID, Name, c2g__PaymentStatus__c FROM c2g__codaInvoice__c WHERE c2g__Account__c =: getUserAccount().id AND c2g__PaymentStatus__c = 'Part Paid'];
        return totalPartPaid.size();
    }
    public static Decimal getTotalOutstanding()
    {
        Decimal totalOutstanding = 0;
        List<c2g__codaInvoice__c> totalRecords = [SELECT Id, c2g__OutstandingValue__c FROM c2g__codaInvoice__c WHERE c2g__Account__c =: getUserAccount().id ];
        for(c2g__codaInvoice__c inv: totalRecords)
        {
            totalOutstanding += inv.c2g__OutstandingValue__c;
        }
        return totalOutstanding;
    }
}