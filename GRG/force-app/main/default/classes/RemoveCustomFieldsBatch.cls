global class RemoveCustomFieldsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{
    private  Integer counter;
    private  String objectAPI;
    List<String> objectList = new List<String>();
    List<Boolean> objectListCalculated = new List<Boolean>();
    
    global RemoveCustomFieldsBatch(Integer count, String objectName)
    {
        counter = count;
        objectAPI = objectName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String QUERY = '';
        
        SObjectType customObject = Schema.getGlobalDescribe().get(objectAPI);
        Map<String,Schema.SObjectField> fields = customObject.getDescribe().fields.getMap();
        for(Schema.SObjectField field: fields.values()) {
            IF(field.getDescribe().getName().contains('__c') 
               && !field.getDescribe().getName().contains('c2g__') 
               && !field.getDescribe().getName().contains('ffxp__') 
               && !field.getDescribe().getName().contains('ffqs__') 
               && !field.getDescribe().getName().contains('ffc__') 
               && !field.getDescribe().getName().contains('ffr__') 
               && !field.getDescribe().getName().contains('ffirule__') 
               && !field.getDescribe().getName().contains('ffbext__') 
               && !field.getDescribe().getName().contains('ffap__') 
               && !field.getDescribe().getName().contains('ffcash__') 
               && !field.getDescribe().getName().contains('ffgl__') 
               && !field.getDescribe().getName().contains('appirio_core__') 
               && !field.getDescribe().getName().contains('pse__') 
               && !field.getDescribe().getName().contains('psa_report__') 
               && !field.getDescribe().getName().contains('ob1__') 
               && !field.getDescribe().getName().contains('ffpsai__') 
               && !field.getDescribe().getName().contains('ffrr__') 
               && !field.getDescribe().getName().contains('ffrr_exp__') 
               && !field.getDescribe().getName().contains('ffbf__') 
               && !field.getDescribe().getName().contains('PsaCalSync__') 
               && !field.getDescribe().getName().contains('ffvat__') 
               && !field.getDescribe().getName().contains('ffrr_exa__') 
               && !field.getDescribe().getName().contains('SCMC__') 
               && !field.getDescribe().getName().contains('SCMQT__') 
               && !field.getDescribe().getName().contains('FAM__') 
               && !field.getDescribe().getName().contains('fflbx__') 
               && !field.getDescribe().getName().contains('psamsp__') 
               && !field.getDescribe().getName().contains('fferpcore__') 
               && !field.getDescribe().getName().contains('dlrs__') 
               && !field.getDescribe().getName().contains('SCMSC__') 
               && !field.getDescribe().getName().contains('ffbc__') 
               && !field.getDescribe().getName().contains('ff1099__') 
               && !field.getDescribe().getName().contains('SCMFFA__') 
               && !field.getDescribe().getName().contains('psa_m__') 
               && !field.getDescribe().getName().contains('sbqq__') 
               && !field.getDescribe().getName().contains('Chargent') 
               && !field.getDescribe().getName().contains('ffct__') 
               && !field.getDescribe().getName().contains('ffaci__'))
            {
                objectList.add(field.getDescribe().getName());
                objectListCalculated.add(field.getDescribe().isCalculated());
            }
        }
        QUERY = 'Select Id From FieldPermissions WHERE SobjectType = \'' + objectAPI + '\' AND Parent.Profile.Name != null AND Field = \'' + objectAPI + '.' + objectList[counter] + '\'';
        try{
            FieldPermissions newcustomfieldperm = new FieldPermissions();
            newcustomfieldperm.SobjectType = objectAPI;
            newcustomfieldperm.ParentId = '0PSf2000000XOINGA4';
            newcustomfieldperm.PermissionsRead = true;
            newcustomfieldperm.Field = objectAPI + '.' + objectList[counter];
            IF(objectListCalculated[counter] == false)
            {
                newcustomfieldperm.PermissionsEdit = true;
            }
            insert newcustomfieldperm;
        }catch (Exception e)
        {
            
        }

        return Database.getQueryLocator(QUERY);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        try{
            delete scope;
        }catch (Exception e)
        {
            
        }
    }   
    global void finish(Database.BatchableContext BC)
    {
        counter = counter + 1;
        IF(counter < objectList.size())
        {
            RemoveCustomFieldsBatch batch = new RemoveCustomFieldsBatch(counter, objectAPI);
            Id batchId = database.executeBatch(batch, 50);
        }
    }
}