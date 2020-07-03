public with sharing class MilestoneToInvoice implements Schedulable
{    
    public void execute(SchedulableContext ctx) 
    {        
		List<pse__Milestone__c> milestones2process = [SELECT Id, Name, pse__Approved__c, Create_Invoice_after_Approval__c FROM pse__Milestone__c WHERE pse__Approved__c = true AND Sales_Invoice__c = null AND pse__Requires_Customer_Sign_off__c = true AND pse__Billed__c = false LIMIT 1];
        for(pse__Milestone__c mil : milestones2process)
        {
            mil.Create_Invoice_after_Approval__c = true;
        }
        update milestones2process;
        
        //this part of the code finds invoices that need posting
    	List<c2g.CODAAPICommon.Reference> sourceIds = new List<c2g.CODAAPICommon.Reference>();
        List<c2g__codaInvoice__c> invoices = [SELECT Id, Auto_Post_Invoice__c, Account_Name__c, c2g__AccountName__c FROM c2g__codaInvoice__c WHERE Auto_Post_Invoice__c  = true AND c2g__InvoiceStatus__c  = 'In Progress'];
        if(invoices.size()>0)
        {
            for(c2g__codaInvoice__c inv: invoices)
            {
				c2g.CODAAPICommon.Reference ref = new c2g.CODAAPICommon.Reference();
                ref.Id = inv.Id;
                sourceIds.add(ref);
                //we are using a custom text field for the sharing rule so this needs to be set
                inv.Account_Name__c = inv.c2g__AccountName__c;
            }
            //fire off the post job using FF API
			c2g.CODAAPISalesInvoice_10_0.BulkPostInvoice(null, sourceIds);   
        	//update the account name field for sharing
            update invoices;
        }
        
    }
}