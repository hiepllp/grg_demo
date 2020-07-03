public with sharing class LinkRedirectController {

  public String link {get;set;}
  public LinkRedirectController(){

      link =   [SELECT Name, Original_Link__c FROM Hyperlink__c WHERE Name =: System.currentPageReference().getParameters().get('Name')].Original_Link__c;
  }
}