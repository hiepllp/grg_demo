public class CSVdownloadController {
    public String sobjectname {get;set;}
    public String query {get;set;}
    public String modDate {get;set;}
    public List<String> fieldNames {get;set;}
    public List<String> fieldList {get;set;}
    public List<sObject> resultList {get;set;}
    public List<String> typeList {get;set;}
    
    public CSVdownloadController()
    {
        modDate = System.currentPageReference().getParameters().get('date');
        //example 2017-01-31T10:08:23.000
        modDate = modDate.left(19);
        modDate = modDate.left(10) + 'T' + modDate.right(8) + '.000+0000';
        IF(modDate == null)
        {
            modDate = [SELECT Id, SystemModstamp FROM c2g__AccountSettings__c].SystemModstamp.format();
            modDate = modDate.left(19) + '.000+0000';
        }
        sobjectname = System.currentPageReference().getParameters().get('object');
        IF(sobjectname == null)
        {
            sobjectname = 'c2g__codaDimension4__c';
        }
        fieldList = Fields(sobjectname);
        Results();

    }
    
    public List<String> Fields(String sobjectname){
        
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
  
        List<String> accessiblefields = new List<String>();
        List<String> accessiblefieldNames = new List<String>();
        List<String> tempTypeList = new List<String>();
          
        for(Schema.SObjectField field : fields.values()){
            if(field.getDescribe().isAccessible())
            {
                IF(String.ValueOf(field.getDescribe().getType())== 'REFERENCE')
                {
                    IF(field.getDescribe().getName().endsWith('__c'))
                    {
                        accessiblefields.add(field.getDescribe().getName().removeEndIgnoreCase('__c') + '__r.External_id_field__c');
                        accessiblefieldNames.add(field.getDescribe().getName().removeEndIgnoreCase('__c') + '__r:External_id_field__c');
                        tempTypeList.add(String.ValueOf(field.getDescribe().getType()));
                    }
                    ELSE
                    {
                        accessiblefields.add(field.getDescribe().getName());
                        accessiblefieldNames.add(field.getDescribe().getName());
                        tempTypeList.add(String.ValueOf(field.getDescribe().getType()));
                    }
                }
                ELSE
                {
                	IF(!field.getDescribe().isCalculated())
                	{
                    	accessiblefields.add(field.getDescribe().getName());
                    	accessiblefieldNames.add(field.getDescribe().getName());
                    	tempTypeList.add(String.ValueOf(field.getDescribe().getType()));
                    }
                }
            }
        }
        fieldNames = accessiblefieldNames;
        typeList = tempTypeList;
        return accessiblefields;
    }

    public List<sObject> Results(){
  
        String allfields = '';

        for(String fieldname : fieldList)
            allfields += fieldname+',';
  
        allfields = allfields.subString(0,allfields.length()-1);
        String objectQUERY = 'SELECT ' + allfields + ' FROM ' + sobjectname + ' WHERE SystemModstamp > ' + modDate;
        query = objectQUERY;
        system.debug(modDate + '.000+0000');
        resultList = Database.query(objectQUERY);
        
        return resultList;
    }

}