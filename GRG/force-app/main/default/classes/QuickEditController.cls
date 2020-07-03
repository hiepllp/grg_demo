public with sharing class QuickEditController {
    
    List<QuickEditWrapper> categories {get;set;}
    public String objectAPI {get;set;}
    public String objectFILTER {get;set;}
    public String objectORDER {get;set;}
    public String objectQUERY {get;set;}
    public List<String> listOfFields = new List<String>();
    public List<String> labelsOfFields = new List<String>();
    
    public QuickEditController()
    {
        objectAPI = 'User';
        objectFILTER = ' WHERE isActive = true';
        objectQUERY = ' ORDER BY LastName';   
        objectORDER = '';     
    }
    
    public List<string> fieldslist {
        get { 
            findFields();
            return listOfFields; }
        set {}
    }        
    public PageReference loadObject()
    {            
        findFields();
        
        objectQUERY = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            if(f.getFieldPath() != 'Id')
                objectQUERY += f.getFieldPath() + ', ';
        }
        objectQUERY += 'Id FROM ' + objectAPI;
        objectFILTER = '';
        objectORDER = '';
        IF(objectAPI == 'c2g__codaDimension1__c')
        {
            objectQUERY += ' ORDER BY CurrencyIsoCode';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Due to references on Transactions you can only update dimensions with one currency at a time. For example you can update all the dimensions with currency USD in one go. Mixing currencies will update some with an error displaying those not updated.'));
        }
        ELSE IF(objectAPI == 'User')
        {
            objectQUERY += ' WHERE isActive = true ORDER By LastName';
        }
        ELSE
        {
            objectQUERY += ' ORDER BY Name ';
        }
        try{
            con = new ApexPages.StandardSetController(Database.getQueryLocator(objectQUERY));
            con.setPageSize(15);
        } catch(Exception e) {
            ApexPages.addMessages(e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,objectQUERY));
        }
        return null;
    }
    public PageReference filterObject()
    {       
        IF(objectFILTER == '' && objectORDER == '')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No filter condition has been entered. Examples includes [WHERE FirstName = \'Lauren\' OR FirstName = \'Matt\'] or [WHERE pse__Region__r.Name = \'Global\'].'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Hover over the the column header in the grid to reveal the API name.'));
            return null;
        }
        findFields();
        objectQUERY = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            if(f.getFieldPath() != 'Id')
                objectQUERY += f.getFieldPath() + ', ';
        }
        objectQUERY += 'Id FROM ' + objectAPI + ' ' + objectFILTER + objectORDER;
        try{
            con = new ApexPages.StandardSetController(Database.getQueryLocator(objectQUERY));
            con.setPageSize(15);
        } catch(Exception e) {
            ApexPages.addMessages(e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,objectQUERY));
            return null;
        } 
        return null;
    }
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            findFields();
            
            objectQUERY = 'SELECT ';
            
            for(Schema.FieldSetMember f : this.getFields()) {
                if(f.getFieldPath() != 'Id')
                    objectQUERY += f.getFieldPath() + ', ';
            }
            objectQUERY += 'Id FROM ' + objectAPI + objectFILTER;
            
            if(con == null) 
            {
                con = new ApexPages.StandardSetController(Database.getQueryLocator(objectQUERY));
                con.setPageSize(15);
            }
            return con;
        }
        set;
    }
    
    public integer getCount()
    {
        String filteredQuery = 'SELECT count() FROM ' + objectAPI;
        objectFilter = objectFilter.toUpperCase();
        IF(!objectFilter.contains('ORDER BY'))
        {
            filteredQuery += ' ' + objectFilter;
        }
        try{
            Integer count = Database.countQuery(filteredQuery);
            return count;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid filter condition. Examples includes [WHERE FirstName = \'Lauren\' OR FirstName = \'Matt\'] or [WHERE pse__Region__r.Name = \'Global\'].'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Hover over the the field in the grid to reveal the API name.'));
            return 0;
        }
    }
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<QuickEditWrapper> getCategories() {
        categories = new List<QuickEditWrapper>();
        for (SObject category : (List<SObject>)con.getRecords())
            categories.add(new QuickEditWrapper(category));
        
        return categories;
    }
    
    // displays the selected items
    public PageReference process() {
        for (QuickEditWrapper cw : categories) {
            if (cw.checked)
            {
                try{
                    update cw.cat;
                    String ObjectName = Schema.getGlobalDescribe().get(ObjectAPI).getDescribe().getLabel();
                    IF(objectQUERY.contains(' Name'))
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,ObjectName + ' with Name: ' + String.valueOf( cw.cat.get('Name') ) + ' has been updated.'));
                    }
                    ELSE
                    {
                        String FieldName = Schema.getGlobalDescribe().get(ObjectAPI).getDescribe().fields.getMap().get(listOfFields[0]).getDescribe().getLabel();
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,ObjectName + ' with ' + FieldName + ' ' + String.valueOf( cw.cat.get(listOfFields[0]) ) + ' has been updated.'));
                    }
                } catch (Exception e){
                    ApexPages.addMessages(e);
                }
                
                //we now set the password 
                IF(ObjectAPI == 'User')
                {
                    try{
                        System.setPassword(String.valueOf( cw.cat.get('Id') ), String.valueOf( cw.cat.get('Password__c') ) );
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Password was set for ' + String.valueOf( cw.cat.get('LastName') ) + ' as ' + String.valueOf( cw.cat.get('Password__c') )));
                    }
                    catch (Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'An error occured setting the password for ' + String.valueOf( cw.cat.get('LastName') ) + ': ' + e.getMessage()));
                    }
                }
            }
        }
        return null;
    }
    
    public PageReference processAll() {
        try{
            for (QuickEditWrapper cw : categories) {
                update cw.cat;
                //we now set the password 
                IF(ObjectAPI == 'User')
                {
                    try{
                        System.setPassword(String.valueOf( cw.cat.get('Id') ), String.valueOf( cw.cat.get('Password__c') ) );
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Password was set for ' + String.valueOf( cw.cat.get('LastName') ) + ' as ' + String.valueOf( cw.cat.get('Password__c') )));
                    }
                    catch (Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'An error occured setting the password for ' + String.valueOf( cw.cat.get('LastName') ) + e.getMessage()));
                    }
                }
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'All visible records have been updated.'));
        } catch (DMLException e){
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    public List<SelectOption> getObjectList()
    {
        
        List<SelectOption> ValidObjects = new List<SelectOption>();
        
        ValidObjects.add( new SelectOption('User', 'User') );
        ValidObjects.add( new SelectOption('Account', 'Account') );
        ValidObjects.add( new SelectOption('Contact', 'Contact') );
        ValidObjects.add( new SelectOption('c2g__codaDimension1__c', 'Dimension 1') );
        ValidObjects.add( new SelectOption('c2g__codaDimension2__c', 'Dimension 2') );
        ValidObjects.add( new SelectOption('c2g__codaDimension3__c', 'Dimension 3') );
        ValidObjects.add( new SelectOption('c2g__codaDimension4__c', 'Dimension 4') );
        ValidObjects.add( new SelectOption('Product2', 'Product') );
        ValidObjects.add( new SelectOption('Opportunity', 'Opportunity') );
        ValidObjects.add( new SelectOption('pse__Proj__c', 'Project') );
        ValidObjects.add( new SelectOption('pse__Region__c', 'Region') );
        ValidObjects.add( new SelectOption('pse__Practice__c', 'Practice') );
        ValidObjects.add( new SelectOption('pse__Grp__c', 'Group') );
        
        return ValidObjects;
    }
    
    public List<String> findFields()
    {
        listOfFields.clear();
        for(Schema.FieldSetMember f : this.getFields()) {
            String relationshipcheck = f.getFieldPath();
            IF(relationshipcheck.indexOf('__r')==-1)
                listOfFields.add(f.getFieldPath());
        }
        return listOfFields;
    }
    
    public List<Schema.FieldSetMember> getFields() {
        
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectAPI);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('QuickEditFieldSet');
        
        return fieldSetObj.getFields(); 
        
    }
    
    // returns the first page of records
    public void first() {
        try {
            con.first();
        } catch (Exception e) {
            IF(e.getMessage() == 'Modified rows exist in the records collection!')
            {
                loadObject();
                first();
            }
            ELSE
                ApexPages.addMessages(e);
        }
    }
    
    // returns the last page of records
    public void last() {
        try{
            con.last();
        } catch (Exception e) {
            IF(e.getMessage() == 'Modified rows exist in the records collection!')
            {
                loadObject();
                last();
            }
            ELSE
                ApexPages.addMessages(e);
        }
    }
    
    // returns the previous page of records
    public void previous() {
        try{
            con.previous();
        } catch (Exception e) {
            IF(e.getMessage() == 'Modified rows exist in the records collection!')
            {
                loadObject();
                previous();
            }
            ELSE
                ApexPages.addMessages(e);
        }
    }
    
    // returns the next page of records
    public void next() {
        try{
            con.next();
        } catch (Exception e) {
            IF(e.getMessage() == 'Modified rows exist in the records collection!')
            {
                loadObject();
                next();
            }
            ELSE
                ApexPages.addMessages(e);
        }    
    }
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
}