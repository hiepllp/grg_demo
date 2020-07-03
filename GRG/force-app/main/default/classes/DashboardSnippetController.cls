public class DashboardSnippetController {
    public DashBoardSnippetController(){}

    public string getDashboardHtml(){
         system.debug('getDashboardHtml');
        PageReference dbPage = new PageReference('https://grg200210.my.salesforce.com/01Z2w000000gbF5EAI');
        Blob pageBlob = dbPage.getContent();
        String html = pageBlob.toString();
        system.debug('html: ' + html);
        return pageBlob.toString();
    }
}