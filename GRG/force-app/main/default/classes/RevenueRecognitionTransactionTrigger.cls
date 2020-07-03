/*
 * FinancialForce.com, inc. claims copyright in this software, its screen display designs and 
 * supporting documentation. FinancialForce and FinancialForce.com are trademarks of FinancialForce.com, inc. 
 * Any unauthorized use, copying or sale of the above may constitute an infringement of copyright and may 
 * result in criminal or other legal proceedings. 
 *
 * Copyright FinancialForce.com, inc. All rights reserved.
 */
 
public with sharing class RevenueRecognitionTransactionTrigger 
{
  private final String STATUS_COMMITTED         = 'Committed';
  private final String ACCOUNTTYPE_INCOMESTATEMENT  = 'Income Statement';
  private final String TRANSACTIONCATEGORY_REVENUE   = 'Revenue';
  private final String STATUS_APPROVED         = 'Approved';
  
  private List<ffrr__RevenueRecognitionTransaction__c> m_newList;
  private List<ffrr__RevenueRecognitionTransaction__c> m_oldList;
  private Map<Id, ffrr__RevenueRecognitionTransaction__c> m_newMap;
  private Map<Id, ffrr__RevenueRecognitionTransaction__c> m_oldMap; 
  
  public RevenueRecognitionTransactionTrigger(List<ffrr__RevenueRecognitionTransaction__c> newList,
    List<ffrr__RevenueRecognitionTransaction__c> oldList, 
    Map<Id, ffrr__RevenueRecognitionTransaction__c> newMap,
    Map<Id, ffrr__RevenueRecognitionTransaction__c> oldMap)
  {
    this.m_newList = newList;
    this.m_oldList = oldList;
    this.m_newMap = newMap;
    this.m_oldMap = oldMap;
  }
  
  public void afterUpdate()
  {
    Set<Id> transactiontoProcess = new Set<Id>(); 
    
    for(ffrr__RevenueRecognitionTransaction__c tran : m_newList)
    {
      if(tran.ffrr__Status__c != m_oldMap.get(tran.Id).ffrr__Status__c && tran.ffrr__Status__c == STATUS_COMMITTED)
      {
        transactiontoProcess.add(tran.Id);
      }
    }
      
    List<pse__Miscellaneous_Adjustment__c> miscAdjustmentToInsert = new List<pse__Miscellaneous_Adjustment__c>();
    
    for(List<ffrr__RevenueRecognitionTransactionLine__c> transactionLines : [Select Id, Name,
      ffrr_exp__Project__c, ffrr__RecognizedDate__c, ffrr__RevenueRecognitionMaster__r.ffrr__Description__c, ffrr_exp__Project__r.ffpsai__MiscAdjGLACode__c, 
      ffrr__AmountRecognized__c, ffrr__RevenueRecognitionMaster__c From ffrr__RevenueRecognitionTransactionLine__c  
      Where ffrr__RevenueRecognitionMaster__c in : transactiontoProcess AND ffrr__AccountType__c =: ACCOUNTTYPE_INCOMESTATEMENT])
    {
      for(ffrr__RevenueRecognitionTransactionLine__c line : transactionLines)
      {
        miscAdjustmentToInsert.add(new pse__Miscellaneous_Adjustment__c(Name = 'MA-' + line.Name.split('-')[1],
          pse__Project__c = line.ffrr_exp__Project__c,
          pse__Effective_Date__c = line.ffrr__RecognizedDate__c,
          pse__Description__c = line.ffrr__RevenueRecognitionMaster__r.ffrr__Description__c,
          ffpsai__BalancingGLACode__c = line.ffrr_exp__Project__r.ffpsai__MiscAdjGLACode__c,
          ffpsai__MiscAdjGLACode__c = line.ffrr_exp__Project__r.ffpsai__MiscAdjGLACode__c,
          pse__Amount__c = line.ffrr__AmountRecognized__c,
          pse__Transaction_Category__c = TRANSACTIONCATEGORY_REVENUE,
          pse__Status__c = STATUS_APPROVED,
          Revenue_Recognition_Transaction__c = line.ffrr__RevenueRecognitionMaster__c)); 
      }
    }
    
    if(miscAdjustmentToInsert.size() > 0)
      insert miscAdjustmentToInsert;
  }
}