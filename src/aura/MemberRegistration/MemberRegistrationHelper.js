({
    showToast : function(cmp, event, helper, message, type) {
        
        //var success = {"type": "success", "message": $A.get("$Label.c.CopytoClipboardSuccess") };
        var error = {"type": "error", "message": message };
        
        var toastEvent = $A.get("e.force:showToast");
        if(type == 'success'){
            toastEvent.setParams(success); 
        }else{
            toastEvent.setParams(error);
        }
        toastEvent.fire(); 
        
    },
    
    generateForm : function(cmp, event, helper) {
        var action = cmp.get("c.getRefferedByMember");
        action.setParams({
            
        })
        action.setCallback(this, function(response) {
            var state = response.getState();      console.log(state);     
            if (state === "SUCCESS") { 
                
            }else if (state === "ERROR") {
                if (response.getError()) {
                    console.log("Error message: " + response.getError()[0].message);
                }
            }             
        });
        $A.enqueueAction(action);
        
    },
    
})