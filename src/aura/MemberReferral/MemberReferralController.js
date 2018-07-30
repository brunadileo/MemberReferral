({    
    doInit: function(cmp, event, helper){        
        var loggedInSetup = cmp.get("v.loggedInMember"); console.log('loggedInSetup: '+loggedInSetup);
        
        var member = window.localStorage.getItem('member'); console.log('member: '+member);
        if(member == null){
            member = event.getParam("member"); 
        }
        
        if(loggedInSetup){
            var member = event.getParam("member"); console.log('member: '+member);
            if(member){
                cmp.set("v.member",member.Id); console.log(cmp.get("v.member"));
                $A.get('e.force:refreshView').fire();
                var action = cmp.get("c.setMember");
                console.log(JSON.stringify(member, null, 2));                
                action.setParams({
                    "memberId": member.Id
                });
                
                $A.enqueueAction(action);
            }else{
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
            }
            
        }else{
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
            
        }
    }
    
})