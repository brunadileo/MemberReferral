({
    fireSearchMemberEvent : function(cmp, event) {
        
        var cmpEvent = cmp.getEvent("searchMemberEvent");
        cmpEvent.setParams({
            "memberId" : cmp.get("v.member")
        });
        cmpEvent.fire();
    },

    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            //title : 'Error Message',
            message: message,
            duration:' 5000',
            type: 'error',
            //mode: 'pester'
        });
        toastEvent.fire();
    },
    
    findProgram : function(cmp, event, helper) {
        
        var action = cmp.get("c.getProgram");        
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS") { 
                cmp.set("v.showSearch",false);
                var programList = response.getReturnValue();
                cmp.set("v.dataProgram",programList);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + errors[0].message);
                }
            } else {
                console.log("Unknown error");
            }
            
        });
        $A.enqueueAction(action);
    },
    
    
})