//UpdateBillLumbergh is before this batch job
global class UpdateDepreciationMethods implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT id, Name FROM FAM__FA_Depreciation_Method__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<FAM__FA_Depreciation_Method__c> batch) {
            }
            
    global void finish(Database.BatchableContext BC) {
          List<Folder> flds = [SELECT Id FROM Folder WHERE DeveloperName ='Fixed_Asset'];
          List<Document> docs = [SELECT Id, DeveloperName FROM Document WHERE FolderId = :flds[0].Id];
        
          // get instance
          string instance = '';
          List<String> parts = System.URL.getSalesforceBaseUrl().getHost().replace('-api','').split('\\.');
          if (parts.size() == 3) {
            instance = parts[0];
          } else if (parts.size() == 5) {
            instance = parts[1];
          } else {
            instance = null;
          }
          system.debug('+++instance: ' + instance);
        
          // set namespace
          string ns = 'FAM';
        
          string baseDocUrl = 'https://';
          if (ns.length() > 0) {
            baseDocUrl += ns + '.';
          } else {
            baseDocUrl += 'c.';
          }
          if (instance != null) {
            baseDocUrl += instance + '.';
          } else {
            // placeholder if can't figure it out.
            baseDocUrl += 'instance.';
          }
          baseDocUrl += 'content.force.com/servlet/servlet.FileDownload?file=';
        
          List<FAM__FA_Depreciation_Method__c> dms = [select Id, name, FAM__Formula_URL__c from FAM__FA_Depreciation_Method__c];
        
          for (FAM__FA_Depreciation_Method__c dm : dms) {
            string u = dm.FAM__Formula_URL__c;
            system.debug('+++existing url: ' + u);
        
            string method = '';
            if (dm.name == 'Straight Line' || dm.name == 'Alt. Straight Line - Longer Term') {
              method =  'Straight_Line';
            } else if (dm.name == 'Double Declining Balance') {
              method = 'Declining_Balance';
            } else if (dm.name == 'Units of Production') {
              method = 'Units_of_Production';
            } else if (dm.name == 'Sum of the Years Digits') {
              method = 'Sum_of_the_Years';
            } else if (dm.name == '150% Declining Balance') {
              method = 'Declining_Balance_150';
            }
        
            // find docId
            string docId = '';
            if (method != '') {
              for (Document d : docs) {
                if (d.DeveloperName == method) {
                  docId = d.Id;
                  break;
                }
              }
            }
        
            if (docId != '') {
              u = baseDocUrl + docId;
            }
        
            system.debug('+++new url: ' + u);
        
            dm.FAM__Formula_URL__c = u;
          }
        
          update dms;
                      
      //update reporting definition with correct link  
      String actionViewRecord = [SELECT Id FROM ffr__InquiryTemplate__c WHERE Name = 'A1: P&L Statutory (By Quarter)'].Id;
      List<ffr__ReportingLabel__c> reportingLabelRecord = [SELECT Id, ffr__Value__c FROM ffr__ReportingLabel__c WHERE Name = 'ACTION VIEW - A1: P&L Statutory (By Quarter)'];
      for(ffr__ReportingLabel__c label: reportingLabelRecord)
      {
        label.ffr__Value__c = 'https://ffr.' + instance + '.visual.force.com/apex/ffr__actionviews?id=' + actionViewRecord;
      }
      update reportingLabelRecord;


      string query1 = 'Select pse__Project_ID_Chain__c, Id From pse__Proj__c'; 
      
      if(!Test.isRunningTest())
      {
      MDOProjectBatch1 batchObject1 = new MDOProjectBatch1(query1);
      Id batchprocessid1 = database.executeBatch(batchObject1) ;
      }
    }
}