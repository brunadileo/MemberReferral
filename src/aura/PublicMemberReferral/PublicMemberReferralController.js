({    
    doInit: function(cmp, event, helper){
        var url = window.location.href; console.log(url);
        var queryString = url.split('?')[1]; console.log(queryString);
        
        var action = cmp.get("c.queryMember");
        action.setParams({
            url:queryString,
            inboundSetup:cmp.get("v.customSettingIn"),
            memberCreationClass:cmp.get("v.MemberCreationExternalClass")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS") { 
                var res = response.getReturnValue(); console.log(res);
                cmp.set("v.member",res);
                helper.openComponent(cmp, event, helper);
            }else if (state === "ERROR") {
                if (response.getError()) {
                    console.log("Error message: " + response.getError()[0].message);
                }
            }             
        });
        $A.enqueueAction(action);
        
    }
    
})