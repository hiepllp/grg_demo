trigger SkillRecordType on pse__Skill__c (before insert, before update) {
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        for(pse__Skill__c sk : Trigger.New)
        {
            IF(sk.pse__Skill_Or_Certification__c == 'Skill')
            {
                ID skill = [SELECT ID FROM RecordType WHERE sObjectType = 'pse__Skill__c' AND Name = 'Skill'].Id;
                sk.RecordTypeId = skill;
            }
            IF(sk.pse__Skill_Or_Certification__c == 'Certification')
            {
                ID certs = [SELECT ID FROM RecordType WHERE sObjectType = 'pse__Skill__c' AND Name = 'Certification'].Id;
                sk.RecordTypeId = certs;
            }
        }
    }
}