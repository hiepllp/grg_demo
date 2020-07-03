global class BundleClasses {
    public String bundleclass {get;set;}
    public String message {get;set;}

    public BundleClasses()
    {
        message = '';
        bundleclass = System.currentPageReference().getParameters().get('class');
        if(bundleclass == 'cqli')
        {
            try{
                cqli();
        		message = 'Post Install Steps run successfully.';
            }catch (Exception e)
            {
        		message = 'An Error occured: ' + e.getMessage();
            }
        }
    }

    
    //configurabe Quote Line Import
    public static void cqli()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort(); 
        service.SessionHeader = new MetadataService.SessionHeader_element(); 
        service.SessionHeader.sessionId = UserInfo.getSessionId(); 
        // Read the Layout 
        MetadataService.Layout layout1 = 
        (MetadataService.Layout) service.readMetadata('Layout', 
        new String[] { 'SCMC__Customer_Quotation__c-SCMQT__Customer Quotation Change Request Layout' }).getRecords()[0]; 
        
        MetadataService.Layout layout2 = 
        (MetadataService.Layout) service.readMetadata('Layout', 
        new String[] { 'SCMC__Customer_Quotation__c-SCMQT__Customer Quotation Flex Change Request Layout' }).getRecords()[0]; 
        
        MetadataService.Layout layout3 = 
        (MetadataService.Layout) service.readMetadata('Layout', 
        new String[] { 'SCMC__Customer_Quotation__c-SCMQT__Customer Quotation Flex Service Layout' }).getRecords()[0]; 
        
        MetadataService.Layout layout4 = 
        (MetadataService.Layout) service.readMetadata('Layout', 
        new String[] { 'SCMC__Customer_Quotation__c-SCMQT__Customer Quotation Inventory Layout' }).getRecords()[0]; 
        
        MetadataService.Layout layout5 = 
        (MetadataService.Layout) service.readMetadata('Layout', 
        new String[] { 'SCMC__Customer_Quotation__c-SCMQT__Customer Quotation Item Layout' }).getRecords()[0]; 
        
        MetadataService.Layout layout6 = 
        (MetadataService.Layout) service.readMetadata('Layout', 
        new String[] { 'SCMC__Customer_Quotation__c-SCMC__Customer Quotation Layout' }).getRecords()[0]; 
        
        MetadataService.Layout layout7 = 
        (MetadataService.Layout) service.readMetadata('Layout', 
        new String[] { 'SCMC__Customer_Quotation__c-SCMQT__Customer Quotation Service Layout' }).getRecords()[0]; 
        
        
        // Add the Custom Button to the Layout 
        layout1.customButtons.add('FFPS_CD0884__Import_Line_Items'); 
        layout2.customButtons.add('FFPS_CD0884__Import_Line_Items'); 
        layout3.customButtons.add('FFPS_CD0884__Import_Line_Items'); 
        layout4.customButtons.add('FFPS_CD0884__Import_Line_Items'); 
        layout5.customButtons.add('FFPS_CD0884__Import_Line_Items'); 
        layout6.customButtons.add('FFPS_CD0884__Import_Line_Items'); 
        layout7.customButtons.add('FFPS_CD0884__Import_Line_Items'); 
        
        // Update the Layout 
        MetadataService.SaveResult results = 
        service.updateMetadata( 
        new MetadataService.Metadata[] { layout1,layout2,layout3,layout4,layout5,layout6,layout7})[0];    
    }
}