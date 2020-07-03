public class ComfirmShipmentController {
	
    public Id currentRecId {get;set;}
    
	public ComfirmShipmentController(ApexPages.StandardController controller) {
        currentRecId  = ApexPages.CurrentPage().getparameters().get('id');
    }
    
    public PageReference confirm() {
        scmc.ShippingConfirm.confirm('Customer', new List<ID>{currentRecId});
        PageReference pg = new PageReference('/'+currentRecId);
        pg.setRedirect(true);
        return pg;
    }
}