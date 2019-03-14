({
    
    showMyToast : function(cmp, event, helper, error) {
        var device = cmp.get("v.device");
        var error = {"type": "error", "message": error };
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(error);
        
        toastEvent.fire(); 
        
    },
    
    getMember: function(cmp, event, helper){
        console.log('GET MEMBER HELPER');
        var loggedInSetup = cmp.get("v.loggedInMember"); //console.log('loggedInSetup: '+loggedInSetup);
        var i = 0;
        if(loggedInSetup){
            do{  
                i++;
                try {
                    var member = event.getParam('member'); console.log(member);
                    cmp.set('v.member', member.Id); console.log(cmp.get("v.member"));
                    window.localStorage.setItem('member', JSON.stringify(member));
                }catch (e) {
                    console.log(e);
                } 
                
            }    
            while(cmp.get("v.member") == null && i<2);
            
            if(cmp.get("v.member") == null && i>=2){
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
        
    },
    
    
})