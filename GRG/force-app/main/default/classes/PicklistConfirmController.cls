public class PicklistConfirmController {
    
    private Id currentRecId = null;
    
	public PicklistConfirmController(ApexPages.StandardController controller) {
        currentRecId  = ApexPages.CurrentPage().getparameters().get('id');
    }
    
    public PageReference complete() {
        scmc.InventoryAPI scmc = new scmc.InventoryAPI();
        scmc.confirmPullParts(currentRecId);
        PageReference pg = new PageReference('/'+currentRecId);
        pg.setRedirect(true);
        return pg;
    }
}