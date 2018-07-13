({
    doInit : function(cmp, event, helper){
        
        
        var fields = ["Name", "FieloPLT__Email__c","FieloPLT__Program__r.Name"];  
        
        var obj = ["FieloPLT__Member__c"];
        
        var action = cmp.get("c.getColumns");
        action.setParams({
            objList: obj,
            fieldList2: fields
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {    
                
                console.log(response.getReturnValue());
                cmp.set("v.columns",response.getReturnValue());
                console.log(cmp.get("v.columns"));              
            } else if (state === "ERROR") {
                if (response.getError()) {
                    console.log("Error message: " + 
                                response.getError()[0].message);
                }               
            }            
        });
        $A.enqueueAction(action);
        
        var action2 = cmp.get("c.getData");
        action2.setParams({
            fieldList: fields
        });
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                cmp.set("v.data",response.getReturnValue());
                console.log(cmp.get("v.data"));              
            }else if (state === "ERROR") {
                if (response.getError()) {
                    console.log("Error message: " + 
                                response.getError()[0].message);
                }               
            }            
        });
        $A.enqueueAction(action2);
        
    },
})