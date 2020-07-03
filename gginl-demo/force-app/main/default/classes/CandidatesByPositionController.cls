public with sharing class CandidatesByPositionController {
    public CandidatesByPositionController() {

    }

    @AuraEnabled
    public static List<CandidateInfo> loadCandidatesByPosition(id PrentId) {
        system.debug('PrentId: ' + PrentId);
        List<TopicAssignment> topicNames = [SELECT Topic.Name FROM TopicAssignment where EntityType = 'Position' and EntityId = :PrentId];
        system.debug('topicNames: ' + topicNames);
//         step 2:
// Load candidate id have match with topic
        
        List<TopicAssignment> candidatesALL = new  List<TopicAssignment>();
        
        for(TopicAssignment topicName: topicNames) {
            String topicNameStr = topicName.Topic.Name;
            List<TopicAssignment> candidates = [SELECT EntityType, EntityId, Topic.Name FROM TopicAssignment where EntityType = 'Candidate' and Topic.Name like :topicNameStr];
            //system.debug('topic: ' + topicNameStr + ' - candidates: ' + candidates);
            if(candidates.size() > 0){
                candidatesALL.addAll(candidates);
            }
            
        }
        system.debug('candidatesALL: ' + candidatesALL);
        Set<String> candidateIds = new Set<String>();
        Map<String, Set<String>> candidateHasTopicNames = new Map<String, Set<String>>();
        for(TopicAssignment candidateTopic: candidatesALL) {
            String candidateId = candidateTopic.EntityId;
            Set<String> skillNamesMatched = candidateHasTopicNames.get(candidateId);
            if(skillNamesMatched == null){
                skillNamesMatched = new Set<String>();
            }
            skillNamesMatched.add(candidateTopic.Topic.Name);
            candidateHasTopicNames.put(candidateId, skillNamesMatched);
            system.debug('candidateHasTopicNames: ' + candidateHasTopicNames);

            //Only list Candidate have enough skills which match the skills in the position
             if(skillNamesMatched.size() == topicNames.size()){
                    candidateIds.add(candidateId);
             }
            
        }

        List<Candidate__c> listCandidates = [SELECT ID, First_Name__c, Last_Name__c FROM Candidate__c where ID in :candidateIds];
        List<CandidateInfo> candidateInfos = new List<CandidateInfo>();
        for(Candidate__c c : listCandidates){
            CandidateInfo candidateInfo = new CandidateInfo();
            candidateInfo.id = c.Id;
            candidateInfo.candidateFirstName = c.First_Name__c;
            candidateInfo.candidateLastName = c.Last_Name__c;
            candidateInfo.skillNamesMatched = new List<String>(candidateHasTopicNames.get(c.Id));
            if(candidateInfo.skillNamesMatched.size() > 0){
                candidateInfo.skillNamesMatchedStr = string.join(candidateInfo.skillNamesMatched,', ');
            }
            candidateInfo.urlView = '/lightning/r/Candidate__c/' + candidateInfo.id +'/view';
            
            candidateInfos.add(candidateInfo);
        }

        return candidateInfos;
    }
}
