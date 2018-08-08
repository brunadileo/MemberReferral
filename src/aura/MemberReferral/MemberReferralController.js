({    
    getMember: function(cmp, event, helper){
        console.log('GET MEMBER CONTROLLER');
        cmp.set("v.callGetMember", true);
        var loggedInSetup = cmp.get("v.loggedInMember"); //console.log('loggedInSetup: '+loggedInSetup);
        if(loggedInSetup){
            do{  
                try {
                    console.log(JSON.stringify(event.getParams()));
                    var member = event.getParam('member'); console.log(member);
                    cmp.set('v.member', member.Id); console.log(cmp.get("v.member"));
                    window.localStorage.setItem('member', JSON.stringify(member));
                    
                } catch (e) {
                    console.log(e);
                    var action = cmp.get("c.setMemberbyUser"); 
                    action.setCallback(this, function(response) {
                        var state = response.getState();           
                        if (state === "SUCCESS") { 
                            var res = response.getReturnValue(); console.log(res);
                            cmp.set("v.member",res);
                        }else if (state === "ERROR") {
                            if (response.getError()) {
                                console.log("Error message: " + response.getError()[0].message);
                            }
                        }                                                                
                    });
                    $A.enqueueAction(action);     
                }
            }
            while(cmp.get("v.member") == null);
        }        
    },
    
    doInit: function(cmp, event, helper){     
        console.log('DO INIT CONTROLLER');
        var loggedInSetup = cmp.get("v.loggedInMember"); //console.log('loggedInSetup: '+loggedInSetup);
        if(loggedInSetup){
            console.log('entra aqui 1');
            if(localStorage.getItem('member') == null){
                console.log('entra aqui 2');
				helper.getMember(cmp, event, helper);                
            }else{
                console.log('entra aqui 3');
                console.log(localStorage.getItem('member'));
                var member = JSON.parse(localStorage.getItem('member'));
                cmp.set('v.member', member.Id);
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
    },
    
    
})