({
    continueFbApi: function(cmp, event, helper,res){
        var appId = res.appId; console.log(appId);
        var redirectUrl = res.redirectUrl; console.log(redirectUrl);
        var url = 'https://www.facebook.com/v3.1/dialog/oauth?client_id='+appId
        + '&response_type=token&display=page&scope=email'
        + '&state=123'
        + '&redirect_uri='+encodeURIComponent(redirectUrl)
        ;
        
        window.open(url,'','width=400,height=400');
        
        cmp.set('v.showSpinner',true);
        
        var interval = window.setInterval(
            $A.getCallback(function() {
                if(localStorage.getItem('firstName')){
                    cmp.set('v.firstname',localStorage.getItem('firstName')); localStorage.removeItem('firstName');
                    cmp.set('v.lastname',localStorage.getItem('lastName')); localStorage.removeItem('lastName');
                    cmp.set('v.email',localStorage.getItem('email')); localStorage.removeItem('email');
                    cmp.set('v.showSpinner',false);
                }
            }), 1000
        );
        
        if(localStorage.getItem('firstName')){
            window.clearInterval(interval);
        }
        
    },
    
    continueGoogleApi: function(cmp, event, helper,res){
        console.log('continueGoogleApi');
        var clientId = res.clientId; console.log(clientId);
        var redirectUrl = res.redirectUrl; console.log(redirectUrl);
        var url = 'https://accounts.google.com/o/oauth2/auth?'+
            'client_id='+clientId+'&'+
            'redirect_uri='+redirectUrl+'&'+
            'response_type=code&'+
            'scope=https://www.googleapis.com/auth/plus.me+https://www.googleapis.com/auth/userinfo.email&'+
            'approval_prompt=auto&access_type=online';
        
        window.open(url,'','width=400,height=400');
        
        cmp.set('v.showSpinner',true);
        
        var interval = window.setInterval(
            $A.getCallback(function() {
                if(localStorage.getItem('firstName')){
                    cmp.set('v.firstname',localStorage.getItem('firstName')); localStorage.removeItem('firstName');
                    cmp.set('v.lastname',localStorage.getItem('lastName')); localStorage.removeItem('lastName');
                    cmp.set('v.email',localStorage.getItem('email')); localStorage.removeItem('email');
                    cmp.set('v.showSpinner',false);
                }
            }), 1000
        );
        
        if(localStorage.getItem('firstName')){
            window.clearInterval(interval);
        }
        
    },
})