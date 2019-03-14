({
    doInit:  function(cmp, event, helper) {
        console.log('entrou aqui');
        var url = window.location.href;
        var queryString,params;
        if(url.includes('code')){
            queryString = url.split('?')[1];
            params = queryString.split('&');
            var token;
            for (var i =0;i<params.length;i++){
                var params2 = params[i].split('='); console.log(params2);
                if(params2[0] == 'code'){
                    token = unescape(params2[1]); console.log(token);
                }
            }
        }
              
        if(token){
            var action = cmp.get("c.getGoogleUser");
            action.setParams({
                token:token
            })
            action.setCallback(this, function(response) {
                var state = response.getState();      console.log(state);     
                if (state === "SUCCESS") { 
                    console.log(response.getReturnValue());
                    var res = JSON.parse(response.getReturnValue());
                    
                    localStorage.setItem('firstName', res.firstName);   
                    localStorage.setItem('lastName', res.lastName);  
                    localStorage.setItem('email',res.email);  
                    
                    window.close();
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