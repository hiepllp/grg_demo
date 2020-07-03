public with sharing class DemoSetupController
{    
    public Integer expiredlicenses {get;set;}
    public String loadingimage {get;set;}
    public String pagemessage {get;set;}
    public String messageType {get;set;}
    
    public DemoSetupController()
    {
        pagemessage = '';
        messageType = '';
        expiredlicenses = [SELECT count() FROM PackageLicense WHERE ExpirationDate <= TODAY];
        loadingimage = 'https://i.imgur.com/lPzp7Wd.gif';
        
        //the below code finds the relevant loading image
        //christmas
        IF(date.today() >= Date.newInstance(2019, 12, 7) && date.today() <= Date.newInstance(2019, 12, 31))
        {
            loadingimage = 'https://i.imgur.com/lSP149l.gif';
        }
        //new year
        IF(date.today() >= Date.newInstance(2020, 1, 1) && date.today() <= Date.newInstance(2020, 1, 14))
        {
            loadingimage = 'https://i.imgur.com/v1aDxTs.gif';
        }
        //valentines
        IF(date.today() >= Date.newInstance(2020, 2, 11) && date.today() <= Date.newInstance(2020, 2, 15))
        {
            loadingimage = 'https://i.imgur.com/tc6ZXNa.gif';
        }
        //paddys day
        IF(date.today() >= Date.newInstance(2019, 3, 15) && date.today() <= Date.newInstance(2019, 3, 18))
        {
            loadingimage = 'https://i.imgur.com/wR5dDqi.gif';
        }
        //easter
        IF(date.today() >= Date.newInstance(2019, 4, 20) && date.today() <= Date.newInstance(2019, 4, 28))
        {
            loadingimage = 'https://i.imgur.com/eHQgXB1.gif';
        }
        //Star wars
        IF(date.today() >= Date.newInstance(2019, 5, 4) && date.today() <= Date.newInstance(2019, 5, 5))
        {
            loadingimage = 'https://i.imgur.com/ydq406U.gif';
        }
        //4th July
        IF(date.today() >= Date.newInstance(2019, 7, 2) && date.today() <= Date.newInstance(2019, 7, 9))
        {
            loadingimage = 'https://i.imgur.com/zGr5pzY.gif';
        }
        //Halloween
        IF(date.today() >= Date.newInstance(2019, 10, 20) && date.today() <= Date.newInstance(2019, 11, 3))
        {
            loadingimage = 'https://i.imgur.com/Ec0X9hz.gif';
        }
    }
    
    //this populates all the source id fields for use with action views. It also places some text to the end so that the system does not change when trials created.
    public pageReference populateSource()
    {
        List <ffr__DataView__c> DataView = [SELECT Id, Source_ID__c FROM ffr__DataView__c WHERE Source_ID__c = null];
        List <ffr__DataViewJoin__c> DataViewJoin = [SELECT Id, Source_ID__c FROM ffr__DataViewJoin__c WHERE Source_ID__c = null];
        List <ffr__DataViewAction__c> DataViewAction = [SELECT Id, Source_ID__c FROM ffr__DataViewAction__c WHERE Source_ID__c = null];
        List <ffr__DataViewField__c> DataViewField = [SELECT Id, Source_ID__c FROM ffr__DataViewField__c WHERE Source_ID__c = null];
        List <ffr__DataViewJoinFilter__c> DataViewJoinFilter = [SELECT Id, Source_ID__c FROM ffr__DataViewJoinFilter__c WHERE Source_ID__c = null];
        List <ffr__DataViewTransposeItem__c> DataViewTransposeItem = [SELECT Id, Source_ID__c FROM ffr__DataViewTransposeItem__c WHERE Source_ID__c = null];
        
        List <ffr__Filter__c> Filter = [SELECT Id, Source_ID__c FROM ffr__Filter__c WHERE Source_ID__c = null];
        List <ffr__FilterElement__c> FilterElement = [SELECT Id, Source_ID__c FROM ffr__FilterElement__c WHERE Source_ID__c = null];
        
        List <ffr__InquiryTemplate__c> InquiryTemplate = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplate__c WHERE Source_ID__c = null];
        List <ffr__InquiryTemplateColumn__c> InquiryTemplateColumn = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateColumn__c WHERE Source_ID__c = null];
        List <ffr__InquiryTemplateFilter__c> InquiryTemplateFilter = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateFilter__c WHERE Source_ID__c = null];
        List <ffr__InquiryTemplateRCP__c> InquiryTemplateRCP = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateRCP__c WHERE Source_ID__c = null];
        List <ffr__InquiryTemplateSortItem__c> InquiryTemplateSortItem = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateSortItem__c WHERE Source_ID__c = null];
        
        try{
            for(ffr__DataView__c DataViewRecords: DataView)
            {
                DataViewRecords.Source_ID__c = DataViewRecords.Id + 'SUPPORT';
            } update DataView;
            
            for(ffr__DataViewJoin__c DataViewJoinRecords: DataViewJoin)
            {
                DataViewJoinRecords.Source_ID__c = DataViewJoinRecords.Id + 'SUPPORT';
            } update DataViewJoin;
            
            for(ffr__DataViewAction__c DataViewActionRecords: DataViewAction)
            {
                DataViewActionRecords.Source_ID__c = DataViewActionRecords.Id + 'SUPPORT';
            } update DataViewAction;
            
            for(ffr__DataViewField__c DataViewFieldRecords: DataViewField)
            {
                DataViewFieldRecords.Source_ID__c = DataViewFieldRecords.Id + 'SUPPORT';
            } update DataViewField;
            
            for(ffr__DataViewJoinFilter__c DataViewJoinFilterRecords: DataViewJoinFilter)
            {
                DataViewJoinFilterRecords.Source_ID__c = DataViewJoinFilterRecords.Id + 'SUPPORT';
            } update DataViewJoinFilter;
            
            for(ffr__DataViewTransposeItem__c DataViewTransposeItemRecords: DataViewTransposeItem)
            {
                DataViewTransposeItemRecords.Source_ID__c = DataViewTransposeItemRecords.Id + 'SUPPORT';
            } update DataViewTransposeItem;
            
            for(ffr__Filter__c FilterRecords: Filter)
            {
                FilterRecords.Source_ID__c = FilterRecords.Id + 'SUPPORT';
            } update Filter;
            
            for(ffr__FilterElement__c FilterElementRecords: FilterElement)
            {
                FilterElementRecords.Source_ID__c = FilterElementRecords.Id + 'SUPPORT';
            } update FilterElement;
            
            for(ffr__InquiryTemplate__c InquiryTemplateRecords: InquiryTemplate)
            {
                InquiryTemplateRecords.Source_ID__c = InquiryTemplateRecords.Id + 'SUPPORT';
            } update InquiryTemplate;
            
            for(ffr__InquiryTemplateColumn__c InquiryTemplateColumnRecords: InquiryTemplateColumn)
            {
                InquiryTemplateColumnRecords.Source_ID__c = InquiryTemplateColumnRecords.Id + 'SUPPORT';
            } update InquiryTemplateColumn;
            
            for(ffr__InquiryTemplateFilter__c InquiryTemplateFilterRecords: InquiryTemplateFilter)
            {
                InquiryTemplateFilterRecords.Source_ID__c = InquiryTemplateFilterRecords.Id + 'SUPPORT';
            } update InquiryTemplateFilter;
            
            for(ffr__InquiryTemplateRCP__c InquiryTemplateRCPRecords: InquiryTemplateRCP)
            {
                InquiryTemplateRCPRecords.Source_ID__c = InquiryTemplateRCPRecords.Id + 'SUPPORT';
            } update InquiryTemplateRCP;
            
            for(ffr__InquiryTemplateSortItem__c InquiryTemplateSortItemRecords: InquiryTemplateSortItem)
            {
                InquiryTemplateSortItemRecords.Source_ID__c = InquiryTemplateSortItemRecords.Id + 'SUPPORT';
            } update InquiryTemplateSortItem;
            
            pagemessage = 'Process complete, you can now template';
            messageType = 'SUCCESS';
            
            //This is no longer needed but was used to populate the ExternalId field
            //PopulateExternalIdAccount batch = new PopulateExternalIdAccount();
            //Id batchId = database.executeBatch(batch, 50);
            
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
        
    }
    
    public String getgoogleCalendar() 
    {  
        //find the date that the org expires
        DateTime expires = [SELECT TrialExpirationDate from Organization].TrialExpirationDate;
        //remove 7 days to give some warning
        expires = expires.addDays(-7);
        String expireDate = expires.format('yyyyMMdd');
        //below is the url to add to google calendar.
        return 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=Org+Expiration&dates=' + expireDate + 'T090000Z/' + expireDate + 'T090500Z&details=Organization+with+id ' + UserInfo.getOrganizationId() + '+and+username ' + UserInfo.getUserName() + '+is+expiring+in+7+days&sf=true&output=xml#eventpage_6';
    }
    
    
    public pageReference removetab()
    {
        try{
            //the tab settings permission set controls the tab access
            PermissionSet[] perm =[SELECT ID, Name FROM PermissionSet WHERE Name = 'Tab_Settings'];
            PermissionSetAssignment[] assign = [SELECT ID, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId =: perm[0].id];
            delete assign[0];
            pagemessage = 'Tab removed';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
        
    }
    
    //the following method turns triggers on
    public pageReference triggersOn()
    {
        try{
            Domain_Settings__c currentsetting = [SELECT ID, Custom_Triggers__c FROM Domain_Settings__c LIMIT 1];
            currentsetting.Custom_Triggers__c = true;
            update currentsetting;
            pagemessage = 'Custom triggers now re-enabled';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    // the following code turns triggers off
    public pageReference triggersOff()
    {
        try{
            Domain_Settings__c currentsetting = [SELECT ID, Custom_Triggers__c FROM Domain_Settings__c LIMIT 1];
            currentsetting.Custom_Triggers__c = false;
            update currentsetting;
            pagemessage = 'Custom triggers now disabled';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    //the following code removes the permission set that allows access to custom fields.
    public pageReference customfieldsOff()
    {
        try{
            //remove permission set
            List<PermissionSet> perm =[SELECT ID, Name FROM PermissionSet WHERE Name = 'Product_Custom_Fields'];
            List<PermissionSetAssignment> assign = [SELECT ID, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId =: perm[0].id];
            delete assign;
            
            pagemessage = 'Custom fields now disabled';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    //the following code assigns the permission set that provides access to custom fields.
    public pageReference customfieldsOn()
    {
        try{
            //assign permission set to all users
            List<PermissionSet> perm = [SELECT ID, Name FROM PermissionSet WHERE Name = 'Product_Custom_Fields'];
            List<User> standardusers = [SELECT ID, Name FROM User WHERE IsActive = true AND UserType = 'Standard'];
            List<PermissionSetAssignment> assign = new List<PermissionSetAssignment>();
            for(User u : standardusers)
            {
                PermissionSetAssignment newrecord = new PermissionSetAssignment();
                newrecord.AssigneeId = u.Id;
                newrecord.PermissionSetId = perm[0].id;
                assign.add(newrecord);
            }
            insert assign;
            
            pagemessage = 'Custom fields now re-enabled';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    //batch job to delete reporting balances
    public pageReference deleteReportingBalances()
    {
        try{
            ReportingBalanceDelete a = new ReportingBalanceDelete();
            database.executeBatch(a,50);
            pagemessage = 'Reporting Balances are being deleted';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    //the master configure org job
    public pageReference runeverything()
    {
        try{      
            //performs a full reporting balance synchronization
            Boolean incremental = false;
            c2g.CODAAPICommon_8_0.Context context = new c2g.CODAAPICommon_8_0.Context();
            context.CompanyName = 'Company';
            c2g.CODAAPIBudget_8_0.ReportingBalanceUpdate(context,incremental);
            
            //createRemoteSiteSetting(URL.getOrgDomainUrl().toExternalForm().substringBefore('.'));

            //starts the batch jobs
            MDOUpdateDomainSettings a = new MDOUpdateDomainSettings();
            database.executeBatch(a,50);
            pagemessage = 'The configuration process has begun, you will receive an email when complete.';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    //this function sends an email to licensing requesting a license extension
    public pageReference extendFFLicense()
    {
        //only financialforce employees can use this feature
        try{
            IF(UserInfo.getUserEmail().contains('@financialforce.com'))
            {
                // Email licensing
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                String[] ccAddresses = new String[] {UserInfo.getUserEmail()};  
                    String[] toAddresses = new String[] {'subscription@financialforce.com'};  
                        mail.setToAddresses(toAddresses);  
                mail.setCcAddresses(ccAddresses);  
                mail.setSubject('License Extension');  
                string messageBody = '<html><body><p>Hi,</p><p>Could you please extend each of the FinancialForce licenses in my org by a year and increase the number of available licenses to 50 for each product. The org ID is ' + UserInfo.getOrganizationId() + '</p><p>Thanks, </p><p>' + UserInfo.getName() + ' </p></body></html>';
                mail.SetHTMLBody(messageBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                pagemessage = 'Email sent to subscription@financialforce.com, you will be copied in.';
                messageType = 'SUCCESS';
            }
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    //this function sends an email to licensing requesting a license extension on conga
    public pageReference extendCongaLicense()
    {
        //only financialforce employees can use this feature
        try{
            IF(UserInfo.getUserEmail().contains('@financialforce.com'))
            {
                // Email licensing
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                String[] ccAddresses = new String[] {UserInfo.getUserEmail()};  
                    String[] toAddresses = new String[] {'congalicenses@financialforce.com'};  
                        mail.setToAddresses(toAddresses);  
                mail.setCcAddresses(ccAddresses);  
                mail.setSubject('Conga License Extension');  
                string messageBody = '<html><body><p>Hi,</p><p>Would you please extend ALL Conga licenses in org ID ' + UserInfo.getOrganizationId() + ' for 180 days?</p><p>Licenses to be extended for 180 days include Composer, Sign, Grid and Batch.</p><p>Thanks, </p><p>' + UserInfo.getName() + ' </p></body></html>';
                mail.SetHTMLBody(messageBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            }
            pagemessage = 'Email sent to congalicenses@financialforce.com, you will be copied in.';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    
    //this will schedule a job to remind you to extend your org
    public pageReference extendSFLicense()
    {
        try{
            Datetime sysTime = [SELECT TrialExpirationDate FROM Organization].TrialExpirationDate;
            sysTime = sysTime.addDays(-20);
            String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            ReminderEmail scheduler = new ReminderEmail();
            System.schedule('Org Expiry Reminder Email ' + sysTime,chron_exp,scheduler);
            pagemessage = 'An apex job has been scheduled to remind you of the org expiration 20 days before the end.';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }    
    
    //this relates to a milestone approval job
    public pageReference scheduleCommunityJob()
    {
        try{
            MilestoneToInvoice m = new MilestoneToInvoice();
            Integer count = 0;
            
            do {
                system.schedule('Milestone Job ' + count, '0 ' + count + ' * * * ?', m);
                count++;
            } while (count < 60);
            pagemessage = 'Community Job Scheduled. Approved Milestones will appear as posted Invoices.';
            messageType = 'SUCCESS';
            return null;
        }catch (Exception e)
        {
            pagemessage = 'An error occured: ' + e.getMessage();
            messageType = 'ERROR';
            return null;
        }
    }
    public static void createRemoteSiteSetting(string instance){
        MetadataService.MetadataPort service = createService();
        MetadataService.RemoteSiteSetting aptxtcongaVF = new MetadataService.RemoteSiteSetting();
        aptxtcongaVF.fullName = instance + '_aptxtcongaVF';
        aptxtcongaVF.url = 'https://apxtconga4.' + instance + '.visual.force.com';
        aptxtcongaVF.isActive=true;
        aptxtcongaVF.disableProtocolSecurity=true;
        
        MetadataService.RemoteSiteSetting customsite = new MetadataService.RemoteSiteSetting();
        customsite.fullName = instance + '_customsite';
        customsite.url = 'https://c.' + instance + '.visual.force.com';
        customsite.isActive=true;
        customsite.disableProtocolSecurity=true;
        
        MetadataService.RemoteSiteSetting ffct = new MetadataService.RemoteSiteSetting();
        ffct.fullName = instance + '_ffct';
        ffct.url = 'https://ffct.' + instance + '.visual.force.com';
        ffct.isActive=true;
        ffct.disableProtocolSecurity=true;
        
        MetadataService.RemoteSiteSetting dlrs = new MetadataService.RemoteSiteSetting();
        dlrs.fullName = instance + '_dlrs';
        dlrs.url = 'https://dlrs.' + instance + '.visual.force.com';
        dlrs.isActive=true;
        dlrs.disableProtocolSecurity=true;
        
        MetadataService.RemoteSiteSetting aptxtcongaSF = new MetadataService.RemoteSiteSetting();
        aptxtcongaSF.fullName = instance + '_aptxtcongaSF';
        aptxtcongaSF.url = 'https://apxtconga4.' + instance + '.salesforce.com';
        aptxtcongaSF.isActive=true;
        aptxtcongaSF.disableProtocolSecurity=true;
        service.createMetadata(new List<MetadataService.Metadata> { aptxtcongaSF, aptxtcongaVF, ffct, customsite, dlrs });
    }
    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service1 = new MetadataService.MetadataPort();
        service1.SessionHeader = new MetadataService.SessionHeader_element();
        service1.SessionHeader.sessionId = UserInfo.getSessionId();
        return service1;
    }    
    
}