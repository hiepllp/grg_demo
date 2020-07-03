public with sharing class TopicUtils {
   
   public static void addTopicTagsToObject(Id objectId, List<String> topicNames){
      String sObjName = objectId.getSObjectType().getDescribe().getName();
      List<Topic> topics = new List<Topic>();
      
      for(String topicName : topicNames){
            Topic topic = new Topic(Name = topicName);
            List<Topic> topicDBs = [select id, name from Topic where name = :topicName LIMIT 1];
            if(topicDBs.size() > 0){
               topic = topicDBs.get(0);
            }
            topics.add(topic);
            
      }
      upsert topics;
      List<TopicAssignment> topicAssignments = new List<TopicAssignment>();
      for(Topic topic : topics){
         TopicAssignment topicAssignment = new TopicAssignment(EntityId = objectId, TopicId = topic.id);
         topicAssignments.add(topicAssignment);
      }
      
      upsert topicAssignments;
      system.debug('topicAssignments' + topicAssignments);

      List<TopicAssignment> topicAssignmentsWillBeDeleted = [SELECT ID FROM TopicAssignment where EntityId = :objectId and Topic.Name not in :topicNames];
      if(topicAssignmentsWillBeDeleted.size() > 0){
         delete topicAssignmentsWillBeDeleted;
      }
      
   }
}
