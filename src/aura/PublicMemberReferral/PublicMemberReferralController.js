({
    doInit: function(cmp, event, helper){
        cmp.set("v.url",window.location.href);   
        var emailSetup = cmp.get("v.customSettingMessages"); console.log(emailSetup);
        var setup = cmp.get("v.customSettingIn");
        var cs = setup.split(',');

        //get the params choosen by the admin
        var action = cmp.get("c.getParams");
        action.setParams({
            fieldname: cs[0],
            quant:cs[1],
            emailSetup: emailSetup
        })
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS") { 
                var params = JSON.parse(response.getReturnValue());
                console.log(params);
                cmp.set("v.socialmedia",params.socialmedia);
                cmp.set("v.emailsubject",params.subject);
                cmp.set("v.emailbody",params.body);   
                helper.continueInit(cmp,event,helper,params);
            }else if (state === "ERROR") {
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