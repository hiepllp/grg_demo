public class ItemLocationDetailsController {
    
    Public String recordId {get;set;}
    Public Decimal totalCost{get;set;}
    Public Decimal totalAverageCost{get;set;}
    Public Double totalQTY{get;set;}
    Public Double totalQTYAllocated{get;set;}
    Public Double totalQTYBackordered{get;set;}
    Public Double totalQTYAvailable{get;set;}
    Public Double totalQTYOnOrder{get;set;}
    Public SCMC__Item__c item;
    Public Boolean showZeros {get;set;}
    //We use re-order criteria to build a fake reference to the Item Master Lookup
    Public SCMC__Inventory_Position__c ipItemLookup {get;set;}
    Public Map<String,Double> backOrders {get;set;}
    Public Map<String,Double> onOrder {get;set;}
    Public Map<String,Boolean> toRender {get;set;}
    Public Map<String,Double> rcAllocated {get;set;}
    Public List <SCMC__ReOrder_Criteria__c> rcs {get;set;}
    Public Map<String,SCMC__ReOrder_Criteria__c> reorderCriterias {get;set;}
    Public List<SCMC__Inventory_Position__c> inventoryPositions {get;set;}
    Public AggregateResult[] groupedResults {get;set;}
    
    public ItemLocationDetailsController(){
        item = new SCMC__Item__c();
        showZeros = False;
        totalCost = 0.00;
        totalAverageCost = 0.00;
        totalQTY = 0.00;
        totalQTYAllocated = 0.00;
        totalQTYBackordered = 0.00;
        totalQTYAvailable = 0.00;
        totalQTYOnOrder = 0.00;
        
        String itemId = ApexPages.currentPage().getParameters().get('recordId');
        String showZeroPage = ApexPages.currentPage().getParameters().get('showZeroPage');
        if(showZeroPage=='true'){
            showZeros = true;
        }
        backOrders = new Map<String,Double>();
        onOrder = new Map<String,Double>();
        toRender = new Map<String,Boolean>();
        rcAllocated = new Map<String,Double>();
        ipItemLookup = new SCMC__Inventory_Position__c();
        if(itemId!=null){
            ipItemLookup.SCMC__Item_Master__c = itemId;
            getItem();
        }
    }
    
    public SCMC__Item__c getItem(){
        
        if(ipItemLookup.SCMC__Item_Master__c==null){
            return null;
        }else{
            item = [SELECT Id, 
                    Name,
                    Business_Unit__c,
                    SCMC__Active_Status__c,
                    SCMC__Item_Type__c,
                    SCMC__Kit__c,
                    SCMC__Item_Description__c,
                    //Supplier_Site__r.Name,
                    //Supplier_Item_Number_Default_Supplier__c,
                    //Supplier_Currency__c,
                    //Landed_Cost__c,
                    //Standard_Sell_Price__c,
                    Primary_Sales_Price__c,
                    SCMC__Supplier_UOM__c,
                    SCMC__Stocking_UOM__c,
                    SCMC__Conversion_Factor__c
                    //,Initial_Cost_Price__c
                    from SCMC__Item__c 
                    WHERE Id =:ipItemLookup.SCMC__Item_Master__c];   
        }
        
        //Get re-order criteria
        rcs =[SELECT Id, 
              Name, 
              SCMC__Item_Master__c,
              //Minimum__c, 
              //Maximum__c, 
              //Default_Inventory_Location__c, 
              //Average_Cost__c, 
              //Landed_Cost__c,
              //Total_Quantity_Stored__c,
              //Quantity_Allocated__c,
              //Location__c,
              //Quantity_Available__c,
              //Total_Sum_Value__c,
              SCMC__Warehouse__c,
              SCMC__Warehouse__r.Name
              FROM SCMC__ReOrder_Criteria__c
              WHERE SCMC__Item_Master__c =:item.id];
        
        //sets totals to zeros to stop continous adding on page loads
        totalCost = 0.00;
        totalAverageCost = 0.00;
        totalQTY = 0.00;
        totalQTYAllocated = 0.00;
        totalQTYBackordered = 0.00;
        totalQTYAvailable = 0.00;
        totalQTYOnOrder = 0.00;   
        
        //Now we are starting to build the data for the table. Mapping all re-order criteria to the warehouse name.
        reorderCriterias = new Map<String,SCMC__ReOrder_Criteria__c>();
        for(SCMC__ReOrder_Criteria__c rc:rcs){
            
            reorderCriterias.put(rc.SCMC__Warehouse__r.Name,rc);
            rcAllocated.put(rc.SCMC__Warehouse__r.Name, 0);
            backOrders.put(rc.SCMC__Warehouse__r.Name,0);
            onOrder.put(rc.SCMC__Warehouse__r.Name,0);
            toRender.put(rc.SCMC__Warehouse__r.Name,False);
        }
             
        //Get Inventory Position Sums for actuals
        groupedResults = [Select SCMC__Bin__r.SCMC__Warehouse__r.Name w,
                          SUM(SCMC__Quantity__c)quant,
                          SUM(SCMC__Quantity_Allocated__c)quantAlloc, //need to Map this seperately
                          SUM(SCMC__Total_Current_Value__c)curValue
                          , SUM(Qty_available__c)quantAvail
                          FROM SCMC__Inventory_Position__c
                          WHERE SCMC__Item_Master__c =: item.id
                          GROUP BY SCMC__Bin__r.SCMC__Warehouse__r.Name];
       
        for (AggregateResult ar : groupedResults)  {
            SCMC__ReOrder_Criteria__c reorderCriteria = new SCMC__ReOrder_Criteria__c();
            String whName = String.valueOf(ar.get('w'));
            //sets totals
            totalCost = totalCost + Decimal.valueOf(Double.valueOf(ar.get('curValue')));
            totalQTY = totalQTY + Double.valueOf(ar.get('quant'));
            totalQTYAvailable = totalQTYAvailable + Double.valueOf(ar.get('quantAvail'));
            totalQTYAllocated = totalQTYAllocated + Double.valueOf(ar.get('quantAlloc'));
 
            if(reorderCriterias.containsKey(whName)){
                reorderCriteria = reorderCriterias.get(whName);
                //reorderCriteria.Total_Quantity_Stored__c = Double.valueOf(ar.get('quant'));
                //reorderCriteria.Quantity_Available__c = Double.valueOf(ar.get('quantAvail'));
                //reorderCriteria.Total_Sum_Value__c = Decimal.valueOf(Double.valueOf(ar.get('curValue')));
                double allocated = Double.valueOf(ar.get('quantAlloc'));
                reorderCriterias.put(whName,reorderCriteria);
                rcAllocated.put(whName, allocated);
                toRender.put(whName,true);
            }
        }
        
        //Get Backordered sums
        AggregateResult[] bogroupedResults = [Select SCMC__Sales_Order__r.SCMC__Warehouse__r.Name w,
                                              SUM(SCMC__Quantity_Backordered__c)boQuant
                                              FROM SCMC__Sales_Order_Line_Item__c
                                              WHERE SCMC__Item_Master__c =: item.id AND SCMC__Quantity_Backordered__c > 0
                                              GROUP BY SCMC__Sales_Order__r.SCMC__Warehouse__r.Name];
        
        for(AggregateResult ar : bogroupedResults){
            String whName = String.valueOf(ar.get('w'));
            totalQTYBackordered = totalQTYBackordered + Double.valueOf(ar.get('boQuant'));
            if(backOrders.containsKey(whName)){
                backOrders.put(whName,Double.valueOf(ar.get('boQuant')));
                toRender.put(whName,true);
            }
        }
        //Get Open PO Sums
        AggregateResult[] pogroupedResults = [Select SCMC__Warehouse__r.Name w
                                              , SUM(Waiting_to_be_received__c)poQuant
                                              FROM SCMC__Purchase_Order_Line_Item__c
                                              WHERE SCMC__Item_Master__c =: item.id AND SCMC__Status__c <> 'Closed' 
                                              //AND Waiting_to_be_received__c > 0
                                              GROUP BY SCMC__Warehouse__r.Name];
        
        for(AggregateResult ar : pogroupedResults){
            String whName = String.valueOf(ar.get('w'));
            totalQTYOnOrder = totalQTYBackordered + Double.valueOf(ar.get('poQuant'));
            if(onOrder.containsKey(whName)){
                onOrder.put(whName,Double.valueOf(ar.get('poQuant')));
                toRender.put(whName,true);
            }
        }
        
        if(totalQTY != 0){
            totalAverageCost = totalCost / totalQTY; 
            totalAverageCost = totalAverageCost.setScale(2);
        }else{
            totalAverageCost = 0;
        }
        
        return item;
        
        
    }
    
    //Toggles between showing all warehouses or just those with quantities
    public void toggleShowZeros(){
        if(showZeros){
            showZeros = false;
        }else{
            showZeros = true;
        }
    }
}