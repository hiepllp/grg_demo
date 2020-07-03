import { LightningElement, api } from 'lwc';

export default class ShowPdfById extends LightningElement {
    @api fileId;
    @api heightInRem;
    @api fileURL;

    get pdfHeight() {
        return 'height: ' + this.heightInRem + 'rem';
    }
    
    get url() {
        if(this.fileURL != null){
            return this.fileURL;
        }
        else {
            return '/sfc/servlet.shepherd/document/download/' + this.fileId;
        }
     
        
    }
}