public class RoleRenameController {
    public string oldvalue {get;set;}
    public string newvalue {get;set;}
    public boolean updated {get;set;}
    
    public RoleRenameController()
    {
        updated = false;
    }
    
    public List<SelectOption> getValueList()
    {
        List<SelectOption> Values = new List<SelectOption>();
        
        for(Schema.PicklistEntry p : Contact.pse__Resource_Role__c.getDescribe().getPicklistValues())
        {
            IF(p.getValue() != oldvalue)
            {
            	Values.add( new SelectOption(p.getValue(), p.getLabel()) );
            }
            IF(p.getValue() == oldvalue & updated == true)
            {
            	Values.add( new SelectOption(newvalue, newvalue) );
            }
            IF(p.getValue() == oldvalue & updated == false)
            {
            	Values.add( new SelectOption(p.getValue(), p.getLabel()) );
            }
        }
        return Values;
    }
    

	public static void renamePicklist(String objectName, String fieldName, String oldname, String newname)
    {
        MetadataService.MetadataPort service = createService();
        MetadataService.SaveResult results = service.renameMetadata('PicklistValue',objectName+'.'+fieldName+'.'+oldname,objectName+'.'+fieldName+'.'+newname);
    }
    
	public static void addPicklist(String objectName, String fieldName, String newname)
    {
        MetadataService.MetadataPort service = createService();
        // Read Custom Field
        MetadataService.CustomField customField =
            (MetadataService.CustomField) service.readMetadata('CustomField',
                new String[] { objectName+'.'+fieldName }).getRecords()[0];

        // Add pick list values
        metadataservice.PicklistValue newvalue = new metadataservice.PicklistValue();
        newvalue.fullName= newname;
        newvalue.default_x=false;
        customField.picklist.picklistValues.add(newvalue);

        // Update Custom Field
        MetadataService.SaveResult results = service.updateMetadata(
                new MetadataService.Metadata[] { customField })[0];
    }
    
    public pageReference updateAllPicklists()
    {
        try{
            renamePicklist('Contact','pse__Resource_Role__c',oldvalue, newvalue);
            renamePicklist('pse__Assignment__c','pse__Role__c',oldvalue, newvalue);
			renamePicklist('pse__Resource_Request__c','pse__Resource_Role__c',oldvalue, newvalue); 
            renamePicklist('pse__Rate_Card__c','pse__Role__c',oldvalue, newvalue);
            renamePicklist('pse__Project_Task_Assignment__c','pse__Resource_Role__c',oldvalue, newvalue);
            renamePicklist('pse__Expense_Limit_Rate__c','pse__Resource_Role__c',oldvalue, newvalue);
            renamePicklist('pse__Utilization_Summary__c','pse__Resource_Role__c',oldvalue, newvalue);
            updated = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully replaced ' + oldvalue + ' with ' + newvalue + ' on all objects.'));
        }catch (Exception e)
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An error occured updating the picklist: ' +e));
        }
        
        return null;
    }
    
    public pageReference addnewPicklist()
    {
        try{
            addPicklist('Contact','pse__Resource_Role__c', newvalue);
            addPicklist('pse__Assignment__c','pse__Role__c', newvalue);
			addPicklist('pse__Resource_Request__c','pse__Resource_Role__c', newvalue); 
            addPicklist('pse__Rate_Card__c','pse__Role__c', newvalue);
            addPicklist('pse__Project_Task_Assignment__c','pse__Resource_Role__c', newvalue);
            addPicklist('pse__Expense_Limit_Rate__c','pse__Resource_Role__c', newvalue);
            addPicklist('pse__Utilization_Summary__c','pse__Resource_Role__c', newvalue);
            updated = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully added ' + newvalue + ' on all objects.'));
        }catch (Exception e)
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An error occured updating the picklist: ' +e));
        }
        
        return null;
    }
    
    public static MetadataService.MetadataPort createService()
  	{ 
    	MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    	service.SessionHeader = new MetadataService.SessionHeader_element();
    	service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.timeout_x = 60000;
    	return service;    
  	}

}