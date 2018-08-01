({
    
    showMyToast : function(cmp, event, helper, error) {
        var device = cmp.get("v.device");
        var error = {"type": "error", "message": error };
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(error);
        
        toastEvent.fire(); 
        
    },
    
    /*doInit: function(cmp, event, helper){     
        console.log('DO INIT HELPER');
        var loggedInSetup = cmp.get("v.loggedInMember"); console.log('loggedInSetup: '+loggedInSetup);
        var member = cmp.get("v.member"); console.log('member: '+member);
        
        if(loggedInSetup){
            if(member){
                var action = cmp.get("c.setMember");
                console.log(JSON.stringify(member, null, 2));                
                action.setParams({
                    "memberId": member.Id
                });
                
                $A.enqueueAction(action);
            }/*else{
                console.log("fez query");
                
                var action = cmp.get("c.setMemberbyUser"); 
                action.setCallback(this, function(response) {
                    var state = response.getState();           
                    if (state === "SUCCESS") { 
                        var res = response.getReturnValue(); console.log(res);
                        cmp.set("v.member",res);
                        //helper.openComponent(cmp, event, helper);
                    }else if (state === "ERROR") {
                        if (response.getError()) {
                            console.log("Error message: " + response.getError()[0].message);
                        }
                    }                                                                
                });
                $A.enqueueAction(action);     
            }*/
            
        /*}else{
            var url;
            if(url == null){
                url = window.location.href; console.log(url);
            }
            var queryString = url.split('?')[1]; console.log(queryString);
            
            var action = cmp.get("c.queryMember");
            action.setParams({
                url:queryString,
                inboundSetup:cmp.get("v.customSettingIn"),
                memberCreationClass:cmp.get("v.MemberCreationExternalClass")
            })
            action.setCallback(this, function(response) {
                var state = response.getState();      console.log(state);     
                if (state === "SUCCESS") { 
                    var res = JSON.parse(response.getReturnValue()); console.log(res);
                    if(res == null){
                        cmp.set("v.member",'no member');
                    } else if(res.member){
                        cmp.set("v.member",res.member);
                    }else if(res.error){
                        helper.showMyToast(cmp, event, helper, res.error);
                    }
                }else if (state === "ERROR") {
                    if (response.getError()) {
                        console.log("Error message: " + response.getError()[0].message);
                    }
                }             
            });
            $A.enqueueAction(action);
            
        }
    },*/
    
    getMember: function(cmp, event, helper){
        console.log('GET MEMBER HELPER');
        try {
            //console.log('updateMember');
            var member = event.getParam('member');
            cmp.set('v.member', member);
            window.localStorage.setItem('member', JSON.stringify(member));
            helper.doInit(cmp, event, helper);
        } catch (e) {
            console.log(e);
        }
    },
    
})