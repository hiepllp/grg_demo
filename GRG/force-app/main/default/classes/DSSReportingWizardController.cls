public class DSSReportingWizardController {

    public string recordId {get;set;}
    public string ReportName {get;set;}
    public string fullreporttype {get;set;}
    public string reporttype {get;set;}
    public string reporttypeLevel1 {get;set;}
    public string reporttypeLevel1child {get;set;}
    public string reporttypeLevel1link {get;set;}
    public string reporttypeLevel2 {get;set;}
    public string reporttypeLevel2child {get;set;}
    public string reporttypeLevel2link {get;set;}
    public string reporttypeLevel3 {get;set;}
    public string reporttypeLevel3child {get;set;}
    public string reporttypeLevel3link {get;set;}
    public string reporttypeBase {get;set;}
    public string reporttypecategory {get;set;}
    public Schema.DisplayType currentprompttype {get;set;}
    
    public DSSReportingWizardController()
    {
        recordId = '';
        ReportName = '';
        reporttype = 'xx';
        reporttypeLevel1 = 'xx';
        fullreporttype = '';
        reporttypeBase = 'xx';
        reporttypeLevel1child = 'xx';
        reporttypeLevel1link = 'xx';
        reporttypeLevel2 = 'xx';
        reporttypeLevel2child = 'xx';
        reporttypeLevel2link = 'xx';
        reporttypeLevel3 = 'xx';
        reporttypeLevel3child = 'xx';
        reporttypeLevel3link = 'xx';
        reporttypecategory = '';
    }
    public PageReference convert()
    {
        MetadataService.MetadataPort service = createService();
        system.debug('Record ID: ' + recordId);
        //this will be the address of the report
        String fullreportaddress = '';
        //find the report
        Report reportdetails = [SELECT Id, Name, DeveloperName, NamespacePrefix , FolderName FROM Report WHERE Id =: recordId LIMIT 1];
        //find the folder the report is in
        Folder folderdetails = [SELECT Id, Name, DeveloperName, NamespacePrefix  FROM Folder WHERE Name = : reportdetails.FolderName LIMIT 1];

        IF(folderdetails.NamespacePrefix != null)
        {
            fullreportaddress = fullreportaddress + folderdetails.NamespacePrefix + '__';
        }
        fullreportaddress = fullreportaddress + folderdetails.DeveloperName + '/';
        IF(reportdetails.NamespacePrefix != null)
        {
            fullreportaddress = fullreportaddress + reportdetails.NamespacePrefix + '__';
        }
        fullreportaddress = fullreportaddress + reportdetails.DeveloperName;
        system.debug('Full Report Name: ' + fullreportaddress);
        MetadataService.Report report = (MetadataService.Report) service.readMetadata('Report',new String[] { fullreportaddress }).getRecords()[0];
        
        system.debug('report.reportType: ' + report.reportType);

        //we must then determine what type of report this is. There are 4 types.
        //type 1: one object CustomEntity$VanaHCM__Worker__c
        IF(report.reportType.startsWith('CustomEntity$') && report.reportType.countMatches('.') == 0)
        {
            reporttype = report.reportType.substringAfterLast('$');
            reporttypecategory = 'type1';
        }
        //type 2: two objects CustomEntity$VanaHCM__Worker__c@VanaHCM__Worker__c.VanaHCM__Job_Person__c
        IF(report.reportType.startsWith('CustomEntity$') && report.reportType.countMatches('.') == 1)
        {
            reporttypeLevel1link = report.reportType.substringAfterLast('.');
            reporttype = report.reportType.substringAfterLast('$');
            reporttype = reporttype.substringBefore('@');
            reporttypecategory = 'type2';
            
            Schema.SObjectType t = Schema.getGlobalDescribe().get(reporttype);
             
            Schema.DescribeSObjectResult r = t.getDescribe();
            Schema.DescribeFieldResult f = r.fields.getMap().get(reporttypeLevel1link).getDescribe();
            
            reporttypeLevel1 = f.getName();
            
            Schema.DescribeFieldResult f2 = Schema.getGlobalDescribe()
                .get(reporttype)
                .getDescribe()
                .fields
                .getMap()
                .get(reporttypeLevel1)
                .getDescribe();
            
            for(Schema.SObjectType reference : f2.getReferenceTo()) {
                reporttypelevel1child =  reference.getDescribe().getName();
            }
        }
        //type 3: three objects CustomEntityCustomEntity$c2g__codaTransaction__c$c2g__codaTransactionLineItem__c@c2g__codaTransactionLineItem__c.c2g__Dimension3__c
        IF(report.reportType.startsWith('CustomEntityCustomEntity$'))
        {
            reporttypecategory = 'type3';
            reporttype = report.reportType.substringBefore('@');
            reporttype = reporttype.substringAfterLast('$');
            
            reporttypeLevel1 = report.reportType.remove('CustomEntityCustomEntity$');
            reporttypeLevel1 = reporttypeLevel1.substringBefore('$');

            reporttypeLevel2link = report.reportType.substringAfterLast('.');
            
            Schema.sObjectType parentType = Schema.getGlobalDescribe().get(reporttypeLevel1);
            Schema.sObjectType childType = Schema.getGlobalDescribe().get(reporttype);
            
            //this finds the link between the first two objects
            List<Schema.SObjectField> fieldList = childType.getDescribe().fields.getMap().values();
            
            for (Schema.SObjectField field : fieldList) {
                Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                String ParentObject = '';
                IF(fieldDesc.getReferenceTo().contains(parentType))
                {
                    reporttypeLevel1link = fieldDesc.Name;
                }
            }        
        }

        //type 4: custom report type 
        IF(!report.reportType.startsWith('CustomEntity'))
        {
            reporttypecategory = 'type4';
            MetadataService.ReportType reportTypeDetails = (MetadataService.ReportType) service.readMetadata('ReportType',new String[] { report.reportType.removeEnd('__c') }).getRecords()[0];
            IF(reportTypeDetails.baseObject == null)
            {
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The report type is not yet supported (known issue): ' + report.reportType));
                return null;
            }
            reporttype = reportTypeDetails.baseObject;
            
            reporttypeBase = reporttype;
            //see if an object is linked
            IF(reportTypeDetails.join_x.relationship != null)
            {
                reporttypeLevel1child = reportTypeDetails.join_x.relationship;
                SObjectType customobject = Schema.getGlobalDescribe().get(reporttype);
                List<Schema.ChildRelationship> C = customobject.getDescribe().getChildRelationships();

                for(Schema.ChildRelationship CR : C)
                {
                    IF(cr.RelationshipName == reportTypeDetails.join_x.relationship)
                    {
                        reporttype = cr.getChildSObject().getDescribe().getName();
                    }
                }
                
                //we now need to find the linking field between base and level 1            
                Schema.sObjectType parentType = Schema.getGlobalDescribe().get(reporttypebase);
                Schema.SObjectType childType = Schema.getGlobalDescribe().get(reporttype);
                
                List<Schema.SObjectField> fieldList = childType.getDescribe().fields.getMap().values();
                
                for (Schema.SObjectField field : fieldList) {
                    Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                    String ParentObject = '';
                    IF(fieldDesc.getReferenceTo().contains(parentType))
                    {
                        reporttypeLevel1link = fieldDesc.Name;
                        reporttypeLevel1link = reporttypeLevel1link.removeEnd('__c') + '__r';
                    }
                }
                reporttypeLevel1 = reporttype;
            }
            IF(reportTypeDetails.join_x.join_x.relationship != null)
            {                
                reporttypeLevel2child = reportTypeDetails.join_x.join_x.relationship;
                
                SObjectType accountType = Schema.getGlobalDescribe().get(reporttype);
                List<Schema.ChildRelationship> C = accountType.getDescribe().getChildRelationships();

                for(Schema.ChildRelationship CR : C)
                {
                    IF(cr.RelationshipName == reportTypeDetails.join_x.join_x.relationship)
                    {
                        reporttype = cr.getChildSObject().getDescribe().getName();
                    }
                }
                
                //we now need to find the linking field between Level 1 and Level 2            
                Schema.sObjectType parentType = Schema.getGlobalDescribe().get(reporttypelevel1);
                Schema.SObjectType childType = Schema.getGlobalDescribe().get(reporttype);
                
                List<Schema.SObjectField> fieldList = childType.getDescribe().fields.getMap().values();
                
                for (Schema.SObjectField field : fieldList) {
                    Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                    String ParentObject = '';
                    IF(fieldDesc.getReferenceTo().contains(parentType))
                    {
                        reporttypeLevel2link = fieldDesc.Name;
                        reporttypeLevel2link = reporttypeLevel2link.removeEnd('__c') + '__r';
                    }
                }
                reporttypeLevel2 = reporttype;
            }
            try{
            IF(reportTypeDetails.join_x.join_x.join_x.relationship != null)
            {                
                reporttypeLevel3child = reportTypeDetails.join_x.join_x.join_x.relationship;
                
                SObjectType accountType = Schema.getGlobalDescribe().get(reporttype);
                List<Schema.ChildRelationship> C = accountType.getDescribe().getChildRelationships();

                for(Schema.ChildRelationship CR : C)
                {
                    IF(cr.RelationshipName == reportTypeDetails.join_x.join_x.join_x.relationship)
                    {
                        reporttype = cr.getChildSObject().getDescribe().getName();
                    }
                }
                
                //we now need to find the linking field between Level 2 and Level 3            
                Schema.sObjectType parentType = Schema.getGlobalDescribe().get(reporttypelevel2);
                Schema.SObjectType childType = Schema.getGlobalDescribe().get(reporttype);
                
                List<Schema.SObjectField> fieldList = childType.getDescribe().fields.getMap().values();
                
                for (Schema.SObjectField field : fieldList) {
                    Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                    String ParentObject = '';
                    IF(fieldDesc.getReferenceTo().contains(parentType))
                    {
                        reporttypeLevel3link = fieldDesc.Name;
                        reporttypeLevel3link = reporttypeLevel3link.removeEnd('__c') + '__r';
                    }
                }
                reporttypeLevel2 = reporttype;
            }
            }catch (Exception e)
            {}
            system.debug('ReportType: ' + reporttype);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The Report was based off of: ' + reporttype));
        }

        try{
        ffr__ReportingDefinition__c newReport = new ffr__ReportingDefinition__c();
        newReport.ffr__Description__c = 'For use with XL Plus';
        newReport.Name = reportdetails.Name + ' ' + datetime.now();
        newReport.ffr__Title__c = reportdetails.Name;
        newReport.ffr__ReportingTemplate__c = 'ffr__TF000000000000A';
        newReport.ffr__PrintStyleSheet__c = 'ReportingPrintStylesLetterLandscape.css';
        newReport.ffr__StyleSheet__c = 'ReportingUserStyles/ReportingDefaultStyles.css';
        insert newReport;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The Report was created.'));
        
        //create datarange
        ffr__ReportingDataRange__c newDatarange = new ffr__ReportingDataRange__c();
        newDatarange.Name = reportType;
        newDatarange.ffr__ReportingDefinition__c = newReport.Id;
        newDatarange.ffr__TemplateKey__c = 'DR01';
        newDatarange.ffr__Type__c = 'Detail';

        //check for reporting object
        List<ffr__ReportingObject__c>  ReportingObjectCheck = [SELECT ID FROM ffr__ReportingObject__c WHERE ffr__SalesforceObjectName__c =: reportType LIMIT 1];
        IF(ReportingObjectCheck.isEmpty())
        {
            ffr__ReportingObject__c newReportingObject = new ffr__ReportingObject__c();
            newReportingObject.ffr__SalesforceObjectName__c = reportType;
            newReportingObject.Name = reportType;
            system.debug(newReportingObject);
            insert newReportingObject;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'A new reporting object was created.'));
            newDatarange.ffr__ReportingObject__c = newReportingObject.Id;
        }
        ELSE
        {
            newDatarange.ffr__ReportingObject__c = ReportingObjectCheck[0].Id;
        }
        insert newDatarange;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The data range was created.'));
        
        //create the values (columns)
        List<ffr__ReportingValue__c > fieldlist = new List<ffr__ReportingValue__c >();
        
        List<String> templatekeys = new List<String>();
            templatekeys.add('01');
            templatekeys.add('02');
            templatekeys.add('03');
            templatekeys.add('04');
            templatekeys.add('05');
            templatekeys.add('06');
            templatekeys.add('07');
            templatekeys.add('08');
            templatekeys.add('09');
            templatekeys.add('10');
            templatekeys.add('11');
            templatekeys.add('12');
            templatekeys.add('13');
            templatekeys.add('14');
            templatekeys.add('15');
            templatekeys.add('16');
            templatekeys.add('17');
            templatekeys.add('18');
            templatekeys.add('19');
            templatekeys.add('20');
            templatekeys.add('21');
            templatekeys.add('22');
            templatekeys.add('23');
            templatekeys.add('24');
            templatekeys.add('25');
            templatekeys.add('26');
            templatekeys.add('27');
            templatekeys.add('28');
            templatekeys.add('29');
            templatekeys.add('30');
        
        Integer counter = 0;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'reporttype: ' + reporttype + ' reportcategory: ' + reporttypecategory + ' reporttypebase: ' + reporttypebase + ' reporttypelevel1: ' + reporttypelevel1 + ' reporttypelevel2: ' + reporttypelevel2 + ' reporttypelevel3: ' + reporttypelevel3 + ' reporttypelevel1link: ' + reporttypelevel1link + ' reporttypelevel2link: ' + reporttypelevel2link + ' reporttypelevel3link: ' + reporttypelevel3link + ' reporttypelevel3child: ' + reporttypelevel3child + ' reporttypelevel2child: ' + reporttypelevel2child + ' reporttypelevel1child: ' + reporttypelevel1child));
        for(MetadataService.ReportColumn  cols : report.columns)
        {
            //create field as a string so we can manipulate
            String fieldname = cols.field;
            //this is the first object
            IF(fieldname == 'CUST_NAME')
            {
                system.debug('Field before CUST_NAME: ' + fieldname);
                IF(reporttypecategory == 'type1')
                {
                    fieldname = 'Name';
                }
                IF(reporttypecategory == 'type2')
                {
                    fieldname = 'Name';
                }
                IF(reporttypecategory == 'type3')
                {
                    fieldname = reporttypelevel1link + '.Name';
                    fieldname = fieldname.replace('__c.', '__r.');
                }
                ffr__ReportingValue__c newvalue = new ffr__ReportingValue__c();
                newvalue.name = fieldname;
                newvalue.ffr__FieldName__c = fieldname;
                newvalue.ffr__ReportingDataRange__c = newDatarange.Id;
                newvalue.ffr__Type__c = 'Detail';
                newvalue.ffr__TemplateKey__c = templatekeys[counter];
                fieldlist.add(newvalue);
                counter = counter + 1;
                system.debug('Field After CUST_NAME: ' + fieldname);

            }
            ELSE IF(fieldname == 'CHILD_NAME')
            {
                system.debug('Field before CHILD_NAME: ' + fieldname);
                ffr__ReportingValue__c newvalue = new ffr__ReportingValue__c();
                IF(reporttypecategory == 'type3')
                {
                    fieldname = 'Name';
                }
                newvalue.name = fieldname;
                newvalue.ffr__FieldName__c = fieldname;
                newvalue.ffr__ReportingDataRange__c = newDatarange.Id;
                newvalue.ffr__Type__c = 'Detail';
                newvalue.ffr__TemplateKey__c = templatekeys[counter];
                fieldlist.add(newvalue);
                counter = counter + 1;
                system.debug('Field After CHILD_NAME: ' + fieldname);

            }
            ELSE IF(fieldname.startswith('FK_'))
            {
                system.debug('Field before FK_: ' + fieldname);
                ffr__ReportingValue__c newvalue = new ffr__ReportingValue__c();
                IF(reporttypecategory == 'type3')
                {
                    fieldname = reporttypelevel2link + '.Name';
                    fieldname = fieldname.replace('__c.', '__r.');
                }
                IF(reporttypecategory == 'type2')
                {
                    IF(fieldname.countMatches('.') == 0)
                    {
                        fieldname = reporttypelevel1link + '.' + fieldname.substringAfter('_');
                        fieldname = fieldname.replace('__c.', '__r.');
                    }
                    ELSE
                    {
                        fieldname = fieldname.substringAfter('$');
                        fieldname = reporttypelevel1link + '.' +  fieldname.substringAfter('.');
                    	fieldname = fieldname.replace('__c.', '__r.');
                    }
                }
                newvalue.name = fieldname;
                newvalue.ffr__FieldName__c = fieldname;
                newvalue.ffr__ReportingDataRange__c = newDatarange.Id;
                newvalue.ffr__Type__c = 'Detail';
                newvalue.ffr__TemplateKey__c = templatekeys[counter];
                fieldlist.add(newvalue);
                counter = counter + 1;
                system.debug('Field After FK_: ' + fieldname);
            }
            ELSE
            {
                system.debug('Field before ELSE: ' + fieldname);
                IF(reporttypecategory == 'type4')
                {                    
                    IF(reporttypelevel3link == 'xx')
                    {
                        fieldname = fieldname.replace(reporttypebase + '$', reporttypelevel2link + '.' + reporttypelevel1link + '.');
                        fieldname = fieldname.replace(reporttypebase + '.' + reporttypelevel1child + '$', reporttypelevel2link + '.');
                        fieldname = fieldname.replace(reporttypebase + '.' + reporttypelevel1child + '.' + reporttypelevel2child + '$','');
                    }
                    ELSE
                    {
                        fieldname = fieldname.replace(reporttypebase + '$', reporttypelevel3link + '.' + reporttypelevel2link + '.' + reporttypelevel1link + '.');
                        fieldname = fieldname.replace(reporttypebase + '.' + reporttypelevel1child + '$', reporttypelevel3link + '.' + reporttypelevel2link + '.');
                        fieldname = fieldname.replace(reporttypebase + '.' + reporttypelevel1child + '.' + reporttypelevel2child + '$', reporttypelevel3link + '.');
                        fieldname = fieldname.replace(reporttypebase + '.' + reporttypelevel1child + '.' + reporttypelevel2child + '.' + reporttypelevel3child + '$', '');                ffr__ReportingValue__c newvalue = new ffr__ReportingValue__c();
                    }
                }
                IF(reporttypecategory == 'type3')
                {
                    fieldname = fieldname.replace(reporttypelevel1, reporttypelevel1link);
                    fieldname = fieldname.replace(reporttype + '.', '');
                    fieldname = fieldname.replace('__c.', '__r.');
                }
                IF(reporttypecategory == 'type2')
                {
                    fieldname = fieldname.replace(reporttype + '.', '');
                    fieldname = fieldname.replace('__c.', '__r.');
                }
                IF(reporttypecategory == 'type1')
                {
                    fieldname = fieldname.substringAfterLast('.');
                }
                ffr__ReportingValue__c newvalue = new ffr__ReportingValue__c();
                newvalue.name = fieldname.right(80);
                newvalue.ffr__FieldName__c = fieldname;
                newvalue.ffr__ReportingDataRange__c = newDatarange.Id;
                newvalue.ffr__Type__c = 'Detail';
                newvalue.ffr__TemplateKey__c = templatekeys[counter];
                system.debug('Field After ELSE: ' + fieldname);
                //try adding a reference
                try{
                    ffr__ReportingValue__c newvalue2 = new ffr__ReportingValue__c();
                    newvalue2.name = fieldname.right(80);
                    newvalue2.ffr__ReportingDataRange__c = newDatarange.Id;
                    newvalue2.ffr__Type__c = 'Detail';
                    newvalue2.ffr__TemplateKey__c = templatekeys[counter];
                    newvalue2.ffr__FieldName__c = fieldname;
                    newvalue2.ffr__FieldName__c = newvalue2.ffr__FieldName__c.removeEnd('__c') + '__r.Name';
                    insert newvalue2;
                } catch (Exception e)
                {
                    fieldlist.add(newvalue);                
                }
                counter = counter + 1;
            }
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'All fields: ' + fieldlist));
        //add all of the fields
        insert fieldlist;
        
        system.debug('reporttype: ' + reporttype + ' reporttypebase: ' + reporttypebase + ' reporttypelevel1: ' + reporttypelevel1 + ' reporttypelevel2: ' + reporttypelevel2 + ' reporttypelevel3: ' + reporttypelevel3 + ' reporttypelevel1link: ' + reporttypelevel1link + ' reporttypelevel2link: ' + reporttypelevel2link + ' reporttypelevel3link: ' + reporttypelevel3link + ' reporttypelevel3child: ' + reporttypelevel3child + ' reporttypelevel2child: ' + reporttypelevel2child + ' reporttypelevel1child: ' + reporttypelevel1child);
        
        //next we create the filters!
        IF(report.filter != null)
        {
            Integer filtercounter = 1;
            for(MetadataService.ReportFilterItem  fils : report.filter.criteriaItems)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Filtercolumn: ' + fils.column + 'Filteroperator: ' + fils.operator + 'Filtervalue: ' + fils.value));
                ffr__ReportingFilter__c newfilter = new ffr__ReportingFilter__c();
                newfilter.ffr__Description__c = 'CustomFilter' + + datetime.now() + filtercounter;
                newfilter.ffr__UniqueName__c = 'CustomFilter' + + datetime.now() + filtercounter;
                newfilter.Name = 'CustomFilter' + + datetime.now() + filtercounter;
                newfilter.ffr__ReportingObject__c = newDatarange.ffr__ReportingObject__c;
                newfilter.ffr__Value__c = filtercreator(fils.column, fils.operator, fils.value);
                //only create filters if there is a value
                IF(newfilter.ffr__Value__c != '')
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Filter: ' + newfilter));
                    insert newfilter;
                    
                    ffr__ReportingFilterMapping__c newmapping = new ffr__ReportingFilterMapping__c();
                    newmapping.Name = filtercounter + 'Mapping';
                    newmapping.ffr__ReportingFilter__c = newfilter.Id;
                    newmapping.ffr__ReportingDataRange__c = newDatarange.Id;
                    newmapping.ffr__Type__c = 'All';
                    newmapping.ffr__TemplateKey__c = '';
                    insert newmapping;
                    
                    ffr__ReportingPrompt__c filterprompt = new ffr__ReportingPrompt__c();
                    filterprompt.Name = 'Prompt ' + filtercounter + ' ' + fils.column.substringAfterLast('.');
                    filterprompt.ffr__ReportingDefinition__c = newReport.Id;
                    filterprompt.ffr__DefaultValue__c = fils.value.substringBefore(',');
                    IF(currentprompttype == Schema.DisplayType.INTEGER)
                    {
                    	filterprompt.ffr__Type__c = 'Number';
                    }
                    ELSE IF(currentprompttype == Schema.DisplayType.DATE)
                    {
                    	filterprompt.ffr__Type__c = 'Date';
                    	filterprompt.ffr__DefaultValue__c = '2017-12-31';
                    }
                    ELSE
                    {
                    	filterprompt.ffr__Type__c = 'Text';
                    }
                    insert filterprompt;
                    
                    ffr__ReportingPromptMapping__c  promptmapping = new ffr__ReportingPromptMapping__c();
                    promptmapping.ffr__ReportingPrompt__c = filterprompt.Id;
                    promptmapping.ffr__ReportingFilter__c = newfilter.Id;
                    promptmapping.ffr__PromptTag__c = 'PromptLink';
                    insert promptmapping;
                    filtercounter = filtercounter + 1;
                }
                
            }
        }
            PageReference pageRef = new PageReference('/apex/c__DSSReportingWizardValue?id=' + newReport.Id);
            return pageRef;
        }catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An error occured: ' +e));
        }
        return null;

    }
    
    public String filtercreator(String columnname, String Operatorname, String criterianame)
    {
        system.debug('Column Name: ' + columnname);
        system.debug('Operator Name: ' + Operatorname);
        system.debug('Criteria Name: ' + criterianame);
        String value = '';
        //find the correct operator
        IF(Operatorname == 'equals')
        {
            Operatorname = 'is';
        }
        IF(Operatorname == 'notequal')
        {
            Operatorname = 'is not';
        }
        IF(Operatorname == 'Contains')
        {
            Operatorname = 'contains';
        }
        IF(Operatorname == 'notContain')
        {
            Operatorname = 'does not contain';
        }
        IF(Operatorname == 'lessThan')
        {
            Operatorname = 'is less than';
        }
        IF(Operatorname == 'greaterThan')
        {
            Operatorname = 'is greater than';
        }
        IF(Operatorname == 'lessOrEqual')
        {
            Operatorname = 'is less than or equal to';
        }
        IF(Operatorname == 'greaterOrEqual')
        {
            Operatorname = 'is greater than or equal to';
        }
        IF(columnname.contains(reporttype + '.'))
        {
            Schema.SObjectType t = Schema.getGlobalDescribe().get(reporttype);
             
            Schema.DescribeSObjectResult r = t.getDescribe();
            Schema.DescribeFieldResult f = r.fields.getMap().get(columnname.remove(reporttype + '.')).getDescribe();
            currentprompttype = f.getType();
            IF(f.getType() != Schema.DisplayType.Reference)
            {
                value = '{"version":"2.0","conditions":[{"condition":{"obj":{"name":"' + reporttype + '"},"field":{"name":"' + columnname.remove(reporttype + '.') + '","type":"' + f.getType() +'"}},"operator":"' + Operatorname + '","value":"###PromptLink###"}],"logic":""}';
            }
            ELSE
            {
                value = '{"version":"2.0","conditions":[{"condition":{"obj":{"name":"' + reporttype + '"},"field":{"name":"' + columnname.remove(reporttype + '.') + '","type":"reference","relationshipName":"' + columnname.remove(reporttype + '.').replace('__c','__r') + '","referencing":{"obj":{"name":"' + f.getLabel() +'"},"field":{"name":"name","type":"string"}}}},"operator":"' + Operatorname + '","value":"###PromptLink###"}],"logic":""}';
            }
        }
        IF(columnname == 'CUST_NAME')
        {
            value = '{"version":"2.0","conditions":[{"condition":{"obj":{"name":"' + reporttype + '"},"field":{"name":"Name","type":"string"}},"operator":"' + Operatorname + '","value":"###PromptLink###"}],"logic":""}';
        }
        IF(columnname.contains('FK_'))
        {
            IF(columnname.contains('$'))
            {
                value = '{"version":"2.0","conditions":[{"condition":{"obj":{"name":"' + reporttype + '"},"field":{"name":"' + reporttypeLevel1 + '","type":"reference","relationshipName":"' + reporttypeLevel1.removeEnd('__c') + '__r' + '","referencing":{"obj":{"name":"' + columnname.substringBetween('$', '.') + '"},"field":{"name":"' + columnname.substringAfterLast('.') + '","type":"string"}}}},"operator":"' + Operatorname + '","value":"###PromptLink###"}],"logic":""}';
            }
            IF(columnname.contains('FK_NAME') && reporttypecategory == 'type2')
            {
            	value = '{"version":"2.0","conditions":[{"condition":{"obj":{"name":"' + reporttype + '"},"field":{"name":"' + reporttypeLevel1 + '","type":"reference","relationshipName":"' + reporttypeLevel1.removeEnd('__c') + '__r' + '","referencing":{"obj":{"name":"' + reporttypelevel1child + '"},"field":{"name":"name","type":"string"}}}},"operator":"' + Operatorname + '","value":"###PromptLink###"}],"logic":""}';
            }
        }
        system.debug('OutputValue: ' + value);
        return value;
    }
    
    public static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.timeout_x = 60000;
        return service;    
    }
    
    public List<SelectOption> getTabularList()
    {
        List<SelectOption> Values = new List<SelectOption>();
        
        for(Report r : [SELECT Id, Name FROM Report WHERE Format = 'Tabular' AND FolderName != 'Private Reports' AND FolderName != 'Public Reports'])
        {
                Values.add( new SelectOption(r.Id, r.Name) );
        }
        return Values;
    }
    
    public List<SelectOption> getSummaryList()
    {
        List<SelectOption> Values = new List<SelectOption>();
        
        for(Report r : [SELECT Id, Name FROM Report WHERE Format = 'Summary'])
        {
                Values.add( new SelectOption(r.Id, r.Name) );
        }
        return Values;
    }
}