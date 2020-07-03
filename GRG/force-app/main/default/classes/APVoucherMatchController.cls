public class APVoucherMatchController {
	
    private Id currentRecId = null;
    
	public APVoucherMatchController(ApexPages.StandardController controller) {
        currentRecId  = ApexPages.CurrentPage().getparameters().get('id');
    }
    
    public PageReference match() {
        PageReference pg = null;
        scmc.AccountPayableVouchersService.match(new Set<ID>{currentRecId});
        pg = new PageReference('/'+currentRecId);
        pg.setRedirect(true);       
        return pg;
    }
}