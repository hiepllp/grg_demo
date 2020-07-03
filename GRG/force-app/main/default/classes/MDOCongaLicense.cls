global class MDOCongaLicense implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM PackageLicense WHERE NamespacePrefix = \'APXTConga4\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<PackageLicense> batch) {
        try{
            for(PackageLicense pl : batch)
            {
                insert new UserPackageLicense(UserId = UserInfo.getUserId(), PackageLicenseId = pl.Id);
            }
        }catch (Exception e)
        {}
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}