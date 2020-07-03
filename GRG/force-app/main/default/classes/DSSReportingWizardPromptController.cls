public class DSSReportingWizardPromptController {

    public String reportId {get;set;}
    public List<ffr__ReportingPrompt__c> Values {get;set;}
    
    public DSSReportingWizardPromptController()
    {
        reportId = System.currentPageReference().getParameters().get('Id');
        Values = [SELECT ID, Name, ffr__SortOrder__c, ffr__Type__c, ffr__DefaultValue__c, ffr__PicklistValues__c  FROM ffr__ReportingPrompt__c WHERE ffr__ReportingDefinition__c = : reportId ORDER BY ffr__SortOrder__c ];
        IF(reportId == null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Report found'));
        }
        IF(Values.size() == 0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Prompts found'));
        }
    }
    
    public PageReference save()
    {
        try{
            update Values;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The Prompts have been updated'));
        }catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An error occured updating the prompts:' + e));
        }
        
        return null;
    }
    public PageReference viewReport()
    {
        PageReference pageRef = new PageReference('/' + reportId);
        return pageRef;
    }
    public PageReference renameValues()
    {
        PageReference pageRef = new PageReference('/apex/c__DSSReportingWizardValue?id=' + reportId);
        return pageRef;
    }
    
}