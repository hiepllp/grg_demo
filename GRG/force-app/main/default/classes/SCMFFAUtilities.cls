public class SCMFFAUtilities {

    public static Id getDefaultFFACompany() {
                
        List<c2g__codaCompany__c> companies;

            Set<Id> groupIds = new Set<Id>();
            for(GroupMember groupMember : [select GroupId from GroupMember where Group.Type = 'Queue' and UserOrGroupId = :UserInfo.getUserId()])
            {
                groupIds.add(groupMember.GroupId);
            }
            companies = [select Id, Name from c2g__codaCompany__c where OwnerId in :groupIds];

        if (companies.size() == 1) {
            return companies[0].Id;
        } else {
        	return null;
        }

    }
}