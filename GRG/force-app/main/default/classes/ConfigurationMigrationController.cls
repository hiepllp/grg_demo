public class ConfigurationMigrationController {
    
    public String modDate {get;set;}
    public String queryObject {get;set;}
    public List<Integer> objectChangeCount {get;set;}
    public List<Integer> counterList {get;set;}
    public List<String> objectNameList {get;set;}
    public List<String> objectLabelList {get;set;}
            
    public static void createExternalField(String fieldName)
    {
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = fieldName;
        customField.label = 'External Id Field';
        customField.type_x = 'Text';
        customField.length = 42;
        customField.externalId = true;
        customField.unique = true;
        List<MetadataService.SaveResult> results =
            service.createMetadata(
                new MetadataService.Metadata[] { customField });
        handleSaveResults(results[0]);
    }
    
    public static void handleSaveResults(MetadataService.SaveResult saveResult)
    {
        // Nothing to see?
        if(saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if(saveResult.errors!=null) 
        {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') + 
                    'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' + 
                    ( error.fields!=null && error.fields.size()>0 ? 
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
        }
        if(!saveResult.success)
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
    }   
    public class MetadataServiceExamplesException extends Exception { }
    
    public static MetadataService.MetadataPort createService()
  { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;    
  }

    
    public ConfigurationMigrationController()
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Use this page to export any changes you have made in your org so that they can be imported into another org using the Import Wizard. All records can be linked using the External_Id_Field listed on every object which will be the same across all orgs.'));
        DateTime now = DateTime.now();
        Integer offset = ((DateTime.newInstance(now.date(), now.time()).getTime() - DateTime.newInstance(now.dateGmt(), now.timeGmt()).getTime())/-3600000).intValue();

        queryObject = 'Dimension';
        DateTime ConfigureDate = [SELECT Id, SystemModstamp FROM c2g__AccountSettings__c].SystemModstamp;

        modDate = ConfigureDate.addHours(offset).format('yyyy-MM-dd hh:mm:ss');
        modDate = modDate.left(10) + 'T' + modDate.right(8);
        
        
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
        String objectName = '';
        String objectLabel = '';
        List<String> objectlist1 = new List<String>();
        List<String> objectlabel1 = new List<String>();
        List<Integer> countlist1 = new List<Integer>();
        List<Integer> counter1 = new List<Integer>();
        Integer counterNum = 0;
        for(Schema.SObjectType f : gd)
        {
            //objectNames.add(f.getDescribe().getName());
            objectName = (String)f.getDescribe().getName();
            objectLabel = (String)f.getDescribe().getLabel();
            IF(objectName.endsWith('__c') && (objectName.containsIgnoreCase(queryObject) || objectLabel.containsIgnoreCase(queryObject)))
            {
                objectlabel1.add(objectLabel);
                objectlist1.add(objectName);
                String query = 'SELECT count() FROM ' + objectName + ' WHERE SystemModStamp > ' + modDate + '.000+0000';
                countlist1.add(Database.countQuery(query));
                counter1.add(counterNum);
                counterNum = counterNum +1;
            }
        }
        objectNameList = objectlist1;
        objectChangeCount = countlist1;
        objectLabelList = objectlabel1;
        counterList = counter1;
    }
    public PageReference loadObjectdata()
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Use this page to export any changes you have made in your org so that they can be imported into another org using the Import Wizard. All records can be linked using the External_Id_Field listed on every object which will be the same across all orgs.'));
        IF(queryObject == '')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You must specify a search term.'));
            return null;
        }
        IF(modDate == '')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You must specify a date and time in the format yyyy-MM-dd hh:mm:ss.'));
            return null;
        }
        modDate = modDate.left(19);
        modDate = modDate.left(10) + 'T' + modDate.right(8);
        
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
        String objectName = '';
        String objectLabel = '';
        List<String> objectlist1 = new List<String>();
        List<String> objectlabel1 = new List<String>();
        List<Integer> countlist1 = new List<Integer>();
        List<Integer> counter1 = new List<Integer>();
        Integer counterNum = 0;
        for(Schema.SObjectType f : gd)
        {
            //objectNames.add(f.getDescribe().getName());
            objectName = (String)f.getDescribe().getName();
            objectLabel = (String)f.getDescribe().getLabel();
            IF(objectName.endsWith('__c') && (objectName.containsIgnoreCase(queryObject) || objectLabel.containsIgnoreCase(queryObject)))
            {
                objectlabel1.add(objectLabel);
                objectlist1.add(objectName);
                String query = 'SELECT count() FROM ' + objectName + ' WHERE SystemModStamp > ' + modDate + '.000+0000';
                countlist1.add(Database.countQuery(query));
                counter1.add(counterNum);
                counterNum = counterNum +1;
            }
        }
        objectNameList = objectlist1;
        objectChangeCount = countlist1;
        objectLabelList = objectlabel1;
        counterList = counter1;
        return null;
    }
        
}