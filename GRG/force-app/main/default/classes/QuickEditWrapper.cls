public class QuickEditWrapper {
    public Boolean checked{ get; set; }
    public SObject cat { get; set;}

    public QuickEditWrapper(){
        checked = false;
    }
    
    public QuickEditWrapper(SObject c){
        cat = c;
        checked = false;
    }
}