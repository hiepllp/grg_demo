public class DSSReportingWizardValueController {

    public String reportId {get;set;}
    public List<ffr__ReportingValue__c> Values {get;set;}
    public Integer promptcount {get;set;}
    
    public DSSReportingWizardValueController()
    {
        reportId = System.currentPageReference().getParameters().get('Id');
        promptcount = [SELECT Count() FROM ffr__ReportingPrompt__c WHERE ffr__ReportingDefinition__c = : reportId];
        Values = [SELECT ID, Name, ffr__Type__c, ffr__TemplateKey__c, ffr__FieldName__c FROM ffr__ReportingValue__c WHERE ffr__ReportingDataRange__r.ffr__ReportingDefinition__c = : reportId ORDER BY ffr__TemplateKey__c];
        IF(reportId == null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Report found'));
        }
        IF(Values.size() == 0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Reporting Values found'));
        }
    }
    
    public PageReference save()
    {
        try{
            update Values;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The Columns have been updated'));
        }catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An error occured updating the columns:' + e));
        }
        
        return null;
    }
    public PageReference viewReport()
    {
        PageReference pageRef = new PageReference('/' + reportId);
        return pageRef;
    }
    public PageReference renamePrompts()
    {
        PageReference pageRef = new PageReference('/apex/c__DSSReportingWizardPrompts?id=' + reportId);
        return pageRef;
    }
    
}