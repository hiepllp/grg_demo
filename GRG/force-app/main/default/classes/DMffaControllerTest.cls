@isTest
public with sharing class DMffaControllerTest
{   
    @isTest(SeeAllData=true)
    public static void testNoSDAKey()
    {  
        PageReference pageRef = Page.DMffa;
        Test.setCurrentPageReference(pageRef);

        DMffaController controller = new DMffaController();

        User currentUser = [SELECT Id, c2g__SupportDataAccessKey__c FROM User WHERE Id =: UserInfo.getUserID() LIMIT 1];
        currentUser.c2g__SupportDataAccessKey__c = '';

        update currentUser;

        controller.MoveDates();

        for(ApexPages.Message msg :  ApexPages.getMessages()) 
        {
            System.assertEquals('Cannot find SDA Key for your user.', msg.getSummary());
            System.assertEquals(ApexPages.Severity.WARNING, msg.getSeverity());
        }

    }

    @isTest(SeeAllData=true)
    public static void testSDAKey()
    {  
        PageReference pageRef = Page.DMffa;
        Test.setCurrentPageReference(pageRef);

        DMffaController controller = new DMffaController();

        User currentUser = [SELECT Id, c2g__SupportDataAccessKey__c FROM User WHERE Id =: UserInfo.getUserID() LIMIT 1];
        currentUser.c2g__SupportDataAccessKey__c = '0a4d5995e8f789b34a8e0bea08db9b58eaa1196020160314';

        update currentUser;

        controller.MoveDates();

        for(ApexPages.Message msg :  ApexPages.getMessages()) 
        {
            System.assertEquals('All FFA Dates are being moved 1 years. You will be notified by email once complete.', msg.getSummary());
            System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity());
        }

    }

    @isTest(SeeAllData=true)
    public static void DMBankReconciliationTest()
    {  
        DMBankReconciliation a = new DMBankReconciliation(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMBankStatementTest()
    {  
        DMBankStatement a = new DMBankStatement(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMBankStatementLinesTest()
    {  
        DMBankStatementLines a = new DMBankStatementLines(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMCancelPaymentCriteriaTest()
    {  
        DMCancelPaymentCriteria a = new DMCancelPaymentCriteria(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMCashMatchingHistoriesTest()
    {  
        DMCashMatchingHistories a = new DMCashMatchingHistories(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMJournalsTest()
    {  
        DMJournals a = new DMJournals(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMCashEntriesTest()
    {  
        DMCashEntries a = new DMCashEntries(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPayableCreditNoteExpenseLineTest()
    {  
        DMPayableCreditNoteExpenseLine a = new DMPayableCreditNoteExpenseLine(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPayableCreditNoteLineTest()
    {  
        DMPayableCreditNoteLine a = new DMPayableCreditNoteLine(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPayableCreditNotesTest()
    {  
        DMPayableCreditNotes a = new DMPayableCreditNotes(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPayableInvoiceExpenseLineTest()
    {  
        DMPayableInvoiceExpenseLine a = new DMPayableInvoiceExpenseLine(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPayableInvoiceLineTest()
    {  
        DMPayableInvoiceLine a = new DMPayableInvoiceLine(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPayableInvoicesTest()
    {  
        DMPayableInvoices a = new DMPayableInvoices(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPaymentLineTest()
    {  
        DMPaymentLine a = new DMPaymentLine(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPaymentMediaControlTest()
    {  
        DMPaymentMediaControl a = new DMPaymentMediaControl(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPaymentMediaDetailTest()
    {  
        DMPaymentMediaDetail a = new DMPaymentMediaDetail(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPaymentsTest()
    {  
        DMPayments a = new DMPayments(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMPeriodRenameTest()
    {  
        DMPeriodRename a = new DMPeriodRename(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMSalesCreditNoteTest()
    {  
        DMSalesCreditNote a = new DMSalesCreditNote(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMSalesInvoiceTest()
    {  
        DMSalesInvoice a = new DMSalesInvoice(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMSalesInvoiceInstallmentTest()
    {  
        DMSalesInvoiceInstallment a = new DMSalesInvoiceInstallment(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMSalesInvoiceLineTest()
    {  
        DMSalesInvoiceLine a = new DMSalesInvoiceLine(1);
        Database.executeBatch(a,200);

    }

    @isTest(SeeAllData=true)
    public static void DMTransactionTest()
    {  
        DMTransaction a = new DMTransaction(1);
        Database.executeBatch(a,200);

    }
    
    @isTest(SeeAllData=true)
    public static void DMTransactionLineTest()
    {  
        DMTransactionLine a = new DMTransactionLine(1,'1');
        Database.executeBatch(a,200);

    }


    @isTest(SeeAllData=true)
    public static void DMYearRenameTest()
    {  
        DMYearRename a = new DMYearRename(1);
        Database.executeBatch(a,200);

    }
}