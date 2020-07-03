({
    getData : function(cmp) {
        var that = this;
        var action = cmp.get('c.loadCandidatesByPosition');
        action.setParams({
            PrentId : cmp.get("v.recordId")
        });
        

        action.setCallback(this, function(response){
            let name = response.getState();
            if (name === "SUCCESS") {
                cmp.set('v.mydata', response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);

        window.setTimeout(
            $A.getCallback(function() {
                //console.log('Calling');
                that.getData(cmp);
            }), 20000
        );
        
    }
})