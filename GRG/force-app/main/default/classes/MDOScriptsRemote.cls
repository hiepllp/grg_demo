public with sharing class MDOScriptsRemote
{    

//this populates all the source id fields for use with action views. It also places some text to the end so that the system does not change when trials created.
public static void populateSource()
{
        List <ffr__DataView__c> DataView = [SELECT Id, Source_ID__c FROM ffr__DataView__c];
        List <ffr__DataViewJoin__c> DataViewJoin = [SELECT Id, Source_ID__c FROM ffr__DataViewJoin__c];
        List <ffr__DataViewAction__c> DataViewAction = [SELECT Id, Source_ID__c FROM ffr__DataViewAction__c];
        List <ffr__DataViewField__c> DataViewField = [SELECT Id, Source_ID__c FROM ffr__DataViewField__c];
        List <ffr__DataViewJoinFilter__c> DataViewJoinFilter = [SELECT Id, Source_ID__c FROM ffr__DataViewJoinFilter__c];
        List <ffr__DataViewTransposeItem__c> DataViewTransposeItem = [SELECT Id, Source_ID__c FROM ffr__DataViewTransposeItem__c];

        List <ffr__Filter__c> Filter = [SELECT Id, Source_ID__c FROM ffr__Filter__c];
        List <ffr__FilterElement__c> FilterElement = [SELECT Id, Source_ID__c FROM ffr__FilterElement__c];

        List <ffr__InquiryTemplate__c> InquiryTemplate = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplate__c];
        List <ffr__InquiryTemplateColumn__c> InquiryTemplateColumn = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateColumn__c];
        List <ffr__InquiryTemplateFilter__c> InquiryTemplateFilter = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateFilter__c];
        List <ffr__InquiryTemplateRCP__c> InquiryTemplateRCP = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateRCP__c];
        List <ffr__InquiryTemplateSortItem__c> InquiryTemplateSortItem = [SELECT Id, Source_ID__c FROM ffr__InquiryTemplateSortItem__c];

        List <User> UserRecord = [SELECT Id, Source_ID__c FROM User];

        
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

        for(User UserSettings: UserRecord)
        {
            UserSettings.Source_ID__c = UserSettings.Id + 'SUPPORT';
        } update UserRecord;

}
@RemoteAction
public static String googleCalendar() 
{  
    DateTime expires = [SELECT TrialExpirationDate from Organization].TrialExpirationDate;
    expires = expires.addDays(-7);
    String expireDate = expires.format('yyyyMMdd');
    return 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=Org+Expiration&dates=' + expireDate + 'T090000Z/' + expireDate + 'T090500Z&details=Organization+with+id ' + UserInfo.getOrganizationId() + '+and+username ' + UserInfo.getUserName() + '+is+expiring+in+7+days&sf=true&output=xml#eventpage_6';
}
    
    
@RemoteAction
public static void removetab()
{
        PermissionSet[] perm =[SELECT ID, Name FROM PermissionSet WHERE Name = 'Tab_Settings'];
        PermissionSetAssignment[] assign = [SELECT ID, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId =: perm[0].id];
        delete assign[0];

}

@RemoteAction
public static void runeverything()
{
  //first we create the permission
  PermissionSet enableCommunities = new PermissionSet();
  enableCommunities.Name = 'Communities' + DateTime.now().minute() + DateTime.now().second() + DateTime.now().millisecondGMT();
  enableCommunities.Label = 'Communities' + DateTime.now().minute() + DateTime.now().second() + DateTime.now().millisecondGMT();
  enableCommunities.PermissionsViewGlobalHeader = true;
  insert enableCommunities;
  //then we assign the permission
  PermissionSetAssignment assignPerm = new PermissionSetAssignment();
  assignPerm.AssigneeId = UserInfo.getUserId();
  assignPerm.PermissionSetId = enableCommunities.id;
  insert assignPerm;
  
  Boolean incremental = false;
  c2g.CODAAPICommon_8_0.Context context = new c2g.CODAAPICommon_8_0.Context();
  context.CompanyName = 'Company';
  c2g.CODAAPIBudget_8_0.ReportingBalanceUpdate(context,incremental);

  UpdateBillLumbergh a = new UpdateBillLumbergh();
  database.executeBatch(a,50);
  
}

//this function sends an email to licensing requesting a license extension
@RemoteAction
public static void extendFFLicense()
{
    //only financialforce employees can use this feature
    IF(UserInfo.getUserEmail().contains('@financialforce.com'))
    {
        // Email licensing
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        String[] ccAddresses = new String[] {UserInfo.getUserEmail()};  
        String[] toAddresses = new String[] {'subscription@financialforce.com'};  
        mail.setToAddresses(toAddresses);  
        mail.setCcAddresses(ccAddresses);  
        mail.setSubject('License Extension');  
        string messageBody = '<html><body><p>Hi,</p><p>Could you please extend each of the FinancialForce licenses in my org by a year. The org ID is ' + UserInfo.getOrganizationId() + '</p><p>Thanks, </p><p>' + UserInfo.getName() + ' </p></body></html>';
        mail.SetHTMLBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
}

//this function sends an email to licensing requesting a license extension on conga
@RemoteAction
public static void extendCongaLicense()
{
    //only financialforce employees can use this feature
    IF(UserInfo.getUserEmail().contains('@financialforce.com'))
    {
        // Email licensing
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        String[] ccAddresses = new String[] {UserInfo.getUserEmail()};  
        String[] toAddresses = new String[] {'Support@congamerge.com'};  
        mail.setToAddresses(toAddresses);  
        mail.setCcAddresses(ccAddresses);  
        mail.setSubject('Conga License Extension');  
        string messageBody = '<html><body><p>Hi,</p><p>Would you please extend the Conga Composer and Conga Conductor licenses in org ID ' + UserInfo.getOrganizationId() + ' for 90 days.</p><p>Thanks, </p><p>' + UserInfo.getName() + ' </p></body></html>';
        mail.SetHTMLBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
}

    @RemoteAction
    public static void extendSFLicense()
    {
        Datetime sysTime = [SELECT TrialExpirationDate FROM Organization].TrialExpirationDate;
        sysTime = sysTime.addDays(-20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        ReminderEmail scheduler = new ReminderEmail();
        System.schedule('Org Expiry Reminder Email ' + sysTime,chron_exp,scheduler);
    }    
    
}