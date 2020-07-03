trigger CopyAttachmentsIssuesRisks on pse__Proj__c(after insert)
{
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        Attachment[] insertAttList = new Attachment[]{};
            ContentDocumentLink[] insertDocList = new ContentDocumentLink[]{};
                pse__Issue__c[] insertIssList = new pse__Issue__c[]{};
                    pse__Risk__c[] insertRskList = new pse__Risk__c[]{};
                        
                        for(pse__Proj__c proj : Trigger.new)
                    {
                        
                        if (proj.Template_Used__c != null) {
                            
                            
                            
                            
                            
                            Attachment[] attList = [select id, name, body from Attachment where ParentId = :proj.Template_Used__c];
                            ContentDocumentLink[] docList = [select Id, ContentDocument.Title, ContentDocumentId, ShareType, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :proj.Template_Used__c];
                            pse__Issue__c[] issList = [select id, name, pse__Issue_Name__c, pse__Issue_Description__c from pse__Issue__c where pse__Project__c = :proj.Template_Used__c];
                            pse__Risk__c[] rskList = [select id, name, pse__Risk_Name__c, pse__Risk_Description__c from pse__Risk__c where pse__Project__c = :proj.Template_Used__c];
                            
                            for(Attachment a: attList)
                            {
                                Attachment att = new Attachment(name = a.name, body = a.body, parentid = proj.Id);
                                insertAttList.add(att);
                            }
                            
                            for(ContentDocumentLink d: docList)
                            {
                                ContentDocumentLink doc = new ContentDocumentLink(ContentDocumentId = d.ContentDocumentId, ShareType = d.ShareType, LinkedEntityId = proj.id);
                                insertDocList.add(doc);
                            }
                            
                            for(pse__Issue__c i: issList)
                            {
                                pse__Issue__c iss = new pse__Issue__c(pse__Issue_Name__c = i.pse__Issue_Name__c, pse__Issue_Description__c = i.pse__Issue_Description__c, pse__Project__c = proj.id);
                                insertIssList.add(iss);
                            }
                            
                            
                            for(pse__Risk__c r: rskList)
                            {
                                pse__Risk__c rsk = new pse__Risk__c(pse__Risk_Name__c = r.pse__Risk_Name__c, pse__Risk_Description__c = r.pse__Risk_Description__c, pse__Project__c = proj.id);
                                insertRskList.add(rsk);
                            }
                            
                            
                        }
                    }
        
        
        
        if(!insertDocList.isEmpty())
        {
            insert insertDocList;
        }
        
        
        if(!insertAttList.isEmpty())
        {
            insert insertAttList;
        }
        
        if(!insertIssList.isEmpty())
        {
            insert insertIssList;
        }
        
        if(!insertRskList.isEmpty())
        {
            insert insertRskList;
        }
    }
}