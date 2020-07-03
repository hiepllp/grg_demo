trigger createMiscellaneousAdjustment on Project_Material__c (after insert, after update, before delete, after undelete) {
    static String CATEGORY_BILLING = 'Pass-Through Ready-to-Bill Revenue';
    static String CATEGORY_COST = 'Other Cost';
    
    static Integer MAX_LENGTH_TEXT_ALLOWED = 80; 
    static Integer materialMaxLengthForBillingMA = MAX_LENGTH_TEXT_ALLOWED - System.Label.misc_adjustment_name_type_billing_created_by_material.length() + 3;
    static Integer materialMaxLengthForCostMA = MAX_LENGTH_TEXT_ALLOWED - System.Label.misc_adjustment_name_type_cost_created_by_material.length() + 3;
    IF([SELECT Custom_Triggers__c FROM Domain_Settings__c LIMIT 1].Custom_Triggers__c){
        
        if (trigger.isInsert && trigger.isAfter || trigger.isUnDelete) {
            List<pse__Miscellaneous_Adjustment__c> tobeInsertedMiscAdj = new List<pse__Miscellaneous_Adjustment__c>();
            Integer materialNameLength;
            String miscAdjDescription;
            
            for (Project_Material__c material : trigger.new) {
                materialNameLength = material.Name.length();
                miscAdjDescription = System.Label.misc_adjustment_description_created_by_material.replaceAll('\\{' + 0 + '\\}', material.Name);
                
                // Creating Billing Misc Adj
                pse__Miscellaneous_Adjustment__c miscAdj1 = new pse__Miscellaneous_Adjustment__c();
                miscAdj1.pse__Description__c = miscAdjDescription;
                miscAdj1.pse__Effective_Date__c = material.Effective_Date__c;
                miscAdj1.Project_Material__c = material.Id;
                miscAdj1.ffpsai__BalancingGLACode__c = material.Balancing_GL_Code__c;
                miscAdj1.ffpsai__MiscAdjGLACode__c = material.Balancing_GL_Code__c;
                miscAdj1.pse__Project__c = material.Project__c;
                miscAdj1.pse__Status__c = material.Status__c;
                miscAdj1.pse__Amount__c = material.Billable_Amount__c;
                miscAdj1.pse__Transaction_Category__c = CATEGORY_BILLING;
                
                if (materialNameLength > materialMaxLengthForBillingMA ) {
                    String name = material.Name.substring(0, materialMaxLengthForBillingMA) ;
                    miscAdj1.Name = System.Label.misc_adjustment_name_type_billing_created_by_material.replaceAll('\\{' + 0 + '\\}', name);
                } else {
                    miscAdj1.Name = System.Label.misc_adjustment_name_type_billing_created_by_material.replaceAll('\\{' + 0 + '\\}', material.Name);
                }
                
                // Creating Cost Misc Adj
                pse__Miscellaneous_Adjustment__c miscAdj2 = new pse__Miscellaneous_Adjustment__c();
                miscAdj2.pse__Description__c = miscAdjDescription;
                miscAdj2.pse__Effective_Date__c = material.Effective_Date__c;
                miscAdj2.Project_Material__c = material.Id;
                miscAdj2.ffpsai__BalancingGLACode__c = material.Balancing_GL_Code__c;
                miscAdj2.ffpsai__MiscAdjGLACode__c = material.Balancing_GL_Code__c;
                miscAdj2.pse__Project__c = material.Project__c;
                miscAdj2.pse__Status__c = material.Status__c;
                miscAdj2.pse__Amount__c = material.Cost_Amount__c;
                miscAdj2.pse__Billing_Hold__c = true;
                miscAdj2.pse__Transaction_Category__c = CATEGORY_COST;
                
                if (materialNameLength > materialMaxLengthForCostMA ) {
                    String name = material.Name.substring(0, materialMaxLengthForCostMA) ;
                    miscAdj2.Name = System.Label.misc_adjustment_name_type_cost_created_by_material.replaceAll('\\{' + 0 + '\\}', name);
                } else {
                    miscAdj2.Name = System.Label.misc_adjustment_name_type_cost_created_by_material.replaceAll('\\{' + 0 + '\\}', material.Name);
                }
                
                tobeInsertedMiscAdj.add(miscAdj1);
                tobeInsertedMiscAdj.add(miscAdj2);    
            }
            try {
                //insert tobeInsertedMiscAdj;
                Database.SaveResult[] results = Database.insert(tobeInsertedMiscAdj, false);
                Integer listCounter = 0;
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error err: result.getErrors())
                            trigger.newMap.get(tobeInsertedMiscAdj.get(listCounter).Project_Material__c).addError(err.getMessage());    
                    }
                    listCounter++;
                }
            } catch(DMLException e) {
                System.debug('Exception:' + e);
            }
            
        }
        
        else if (trigger.isupdate) {
            
            List<pse__Miscellaneous_Adjustment__c> tobeUpdatedMiscAdj = [Select Name, pse__Amount__c,pse__Description__c, pse__Effective_Date__c,Project_Material__c,
                                                                         pse__Include_In_Financials__c, pse__Project__c, pse__Status__c, pse__Transaction_Category__c 
                                                                         From pse__Miscellaneous_Adjustment__c Where Project_Material__c in :trigger.newMap.keySet()];
            
            Integer materialNameLength;
            String miscAdjDescription;
            
            for (pse__Miscellaneous_Adjustment__c miscAdj : tobeUpdatedMiscAdj) {
                
                Project_Material__c material = trigger.newMap.get(miscAdj.Project_Material__c);
                miscAdjDescription = System.Label.misc_adjustment_description_created_by_material.replaceAll('\\{' + 0 + '\\}', material.Name);
                materialNameLength = material.Name.length();
                
                
                miscAdj.pse__Effective_Date__c = material.Effective_Date__c;
                miscAdj.pse__Description__c = miscAdjDescription;
                miscAdj.pse__Status__c = material.Status__c;
                miscAdj.pse__Project__c = material.Project__c;
                
                if (miscAdj.pse__Transaction_Category__c == 'Pass-Through Ready-to-Bill Revenue') {
                    miscAdj.pse__Amount__c = material.Billable_Amount__c;
                    if (materialNameLength > materialMaxLengthForBillingMA ) {
                        String name = material.Name.substring(0, materialMaxLengthForBillingMA) ;
                        miscAdj.Name = System.Label.misc_adjustment_name_type_billing_created_by_material.replaceAll('\\{' + 0 + '\\}', name);
                    } else {
                        miscAdj.Name = System.Label.misc_adjustment_name_type_billing_created_by_material.replaceAll('\\{' + 0 + '\\}', material.Name);
                    }
                    
                } else if (miscAdj.pse__Transaction_Category__c == 'Other Cost') {
                    miscAdj.pse__Amount__c = material.Cost_Amount__c;
                    if (materialNameLength > materialMaxLengthForCostMA ) {
                        String name = material.Name.substring(0, materialMaxLengthForCostMA) ;
                        miscAdj.Name = System.Label.misc_adjustment_name_type_cost_created_by_material.replaceAll('\\{' + 0 + '\\}', name);
                    } else {
                        miscAdj.Name = System.Label.misc_adjustment_name_type_cost_created_by_material.replaceAll('\\{' + 0 + '\\}', material.Name);
                    }
                }
            }
            try {
                Database.SaveResult[] results = Database.update(tobeUpdatedMiscAdj, false);
                Integer listCounter = 0;
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error err: result.getErrors())
                            trigger.newMap.get(tobeUpdatedMiscAdj.get(listCounter).Project_Material__c).addError(err.getMessage());     
                    }
                    listCounter++;
                }
            } catch(Exception e) {
                System.debug('Exception:' + e);
            }
            
        }
        
        else if (trigger.isDelete) {
            
            List<pse__Miscellaneous_Adjustment__c> materialMiscAdjs = [Select Name, pse__Include_In_Financials__c
                                                                       From pse__Miscellaneous_Adjustment__c 
                                                                       Where Project_Material__c in : trigger.oldMap.keySet()];
            
            List<pse__Miscellaneous_Adjustment__c> tobeUpdatedMiscAdj = new List<pse__Miscellaneous_Adjustment__c>();
            
            for (pse__Miscellaneous_Adjustment__c miscAdj : materialMiscAdjs) {
                if (miscAdj.pse__Include_In_Financials__c) {
                    miscAdj.pse__Include_In_Financials__c = false;
                    tobeUpdatedMiscAdj.add(miscAdj);
                }
            }
            
            try {
                update tobeUpdatedMiscAdj; 
                delete materialMiscAdjs;
                
            } catch(DMLException e) {
                System.debug('Update Exception While Material Delete: ' + e);
                throw e;
            }
        }
    }
}