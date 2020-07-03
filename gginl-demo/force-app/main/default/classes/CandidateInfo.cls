public class CandidateInfo {
    public CandidateInfo() {
        
       
    }
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String candidateFirstName;
    @AuraEnabled
    public String candidateLastName;
    @AuraEnabled
    public List<String> skillNames = new List<String>();
    @AuraEnabled
    public List<String> skillNamesMatched = new List<String>();
    @AuraEnabled
    public String skillNamesMatchedStr;
    @AuraEnabled
    public String urlView;
}
