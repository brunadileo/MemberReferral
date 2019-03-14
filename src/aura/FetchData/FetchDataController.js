({
    
    doInit:  function(cmp, event, helper) {
        localStorage.removeItem('firstName');
        localStorage.removeItem('lastName');
        localStorage.removeItem('email');
    },
    
    facebookApi : function(cmp, event, helper) {
        console.log('entrou facebook');
        var url;
        var action = cmp.get("c.getSocialMediaSetup");
        action.setParams({
            csName:'facebook'
        })
        action.setCallback(this, function(response) {
            var state = response.getState();      console.log(state);     
            if (state === "SUCCESS") { 
                var res = JSON.parse(response.getReturnValue()); console.log(res);
                helper.continueFbApi(cmp, event, helper,res);
            }else if (state === "ERROR") {
                if (response.getError()) {
                    console.log("Error message: " + response.getError()[0].message);
                }
            }             
        });
        $A.enqueueAction(action);
        
    },
    
    googleApi : function(cmp, event, helper) {
        console.log('entrou google');
        var url;
        var action = cmp.get("c.getSocialMediaSetup");
        action.setParams({
            csName:'google'
        })
        action.setCallback(this, function(response) {
            var state = response.getState();      console.log(state);     
            if (state === "SUCCESS") { 
                var res = JSON.parse(response.getReturnValue()); console.log(res);
                helper.continueGoogleApi(cmp, event, helper,res);
            }else if (state === "ERROR") {
                if (response.getError()) {
                    console.log("Error message: " + response.getError()[0].message);
                }
            }             
        });
        $A.enqueueAction(action);
        
        
        
    }
    
    
})