@isTest
public with sharing class UpdateDepreciationMethodsTest
{
    @isTest
    public static void testUpdateDepreciationMethods()
    {
        FAM__FA_Depreciation_Method__c depStraightLine1 = new FAM__FA_Depreciation_Method__c(
        Name = 'Alt. Straight Line - Longer Term',
        FAM__Calculation_Class__c = 'FAM.DM_StraightLine'
        );
        insert depStraightLine1;
        
        FAM__FA_Depreciation_Method__c depDDecline1 = new FAM__FA_Depreciation_Method__c(
        Name = 'Double Declining Balance',
        FAM__Calculation_Class__c = 'FAM.DM_Declining_Balance'
        );
        insert depDDecline1;
        
        FAM__FA_Depreciation_Method__c depStraightLine2 = new FAM__FA_Depreciation_Method__c(
        Name = 'Straight Line',
        FAM__Calculation_Class__c = 'FAM.DM_StraightLine'
        );
        insert depStraightLine2;
        
        FAM__FA_Depreciation_Method__c depSumYears1 = new FAM__FA_Depreciation_Method__c(
        Name = 'Sum of the Years Digits',
        FAM__Calculation_Class__c = 'FAM.DM_Sum_of_the_Years_Digits'
        );
        insert depSumYears1;

        FAM__FA_Depreciation_Method__c depUoP1 = new FAM__FA_Depreciation_Method__c(
        Name = 'Units of Production',
        FAM__Calculation_Class__c = 'FAM.DM_Units_of_Production'
        );
        insert depUoP1;
        
        c2g__codaCompany__c merlinCompany1 = new c2g__codaCompany__c(
            Name = 'Merlin Technologies, Inc.'
        );
        insert merlinCompany1;
        
        Document document = new Document(
            Name = 'MerlinTechLogo',
            DeveloperName = 'MerlinTechLogo',
            FolderId = UserInfo.getUserId());
        insert document;
        
        c2g__Dataview__c DataviewRecord1 = new c2g__Dataview__c(
            Name = 'Dataview1',
            c2g__StartingObject__c = 'c2g__ReportingBalances__c',
            Source_ID__c = 'dataviewrecordxxxx123456789');
        insert DataviewRecord1;
                        
        c2g__InquiryTemplate__c inquiryTemplateRecord1 = new c2g__InquiryTemplate__c(
            Name = 'A1: P&L Statutory (By Quarter)',
            c2g__Dataview__c = DataviewRecord1.id,
            Source_ID__c = 'inquirytemplate1xx123456789',
            c2g__SummarizeDuplicateRows__c = false);
        insert inquiryTemplateRecord1;
        
        ffr__ReportingDefinition__c definitionRecord1 = new ffr__ReportingDefinition__c(
            Name = 'Quarterly Income Statement',
            ffr__Title__c = 'Quarterly Income Statement'
            );
        insert definitionRecord1;
        
        ffr__ReportingLabel__c urlLabel = new ffr__ReportingLabel__c(
            Name = 'ACTION VIEW - A1: P&L Statutory (By Quarter)',
            ffr__Value__c = 'URL goes here',
            ffr__TemplateKey__c = 'L01',
            ffr__ReportingDefinition__c = definitionRecord1.Id
            );
        insert urlLabel;
                
        UpdateDepreciationMethods a = new UpdateDepreciationMethods();
        database.executeBatch(a, 30);    
        }
}