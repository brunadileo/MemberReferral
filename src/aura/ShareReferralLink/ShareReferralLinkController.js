({
    
    doInit: function(cmp, event, helper){      
        
        var action = cmp.get("c.getParams");
        action.setParams({
            outboundSetup:cmp.get("v.customSettingOut"),
            member:cmp.get("v.member")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS") { 
                var params = JSON.parse(response.getReturnValue());
                console.log(params); 
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
    
    clickCopyButton: function(cmp, event, helper) {
        
        var clipboard = new ClipboardJS('.btn');
        clipboard.on('success', function(e) {
            console.log(e);
        });
        clipboard.on('error', function(e) {
            console.log(e);
        });
        
        if(cmp.get("v.shortURL")){
            helper.showMyToast(cmp, event, helper, 'success');
        }else{
            helper.showMyToast(cmp, event, helper, 'error');
        }
    },
    
    clickFBButton: function(cmp, event, helper) {
        var message = encodeURIComponent(cmp.get("v.socialmedia"));
        var init = encodeURIComponent(cmp.get("v.shortURL")); console.log(init);
        var url = 'https://www.facebook.com/sharer/sharer.php?u='+init+'&src=sdkpreparse&quote='+message;
        window.open(url,'popUpWindow','height=300,width=400,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
        
    },
    
    clickWPButton: function(cmp, event, helper) {
        var message = encodeURIComponent(cmp.get("v.socialmedia"));
        var init = encodeURIComponent(cmp.get("v.shortURL")); console.log(init);
        var url = 'https://api.whatsapp.com/send?text='+ message+ ' '+init;
        window.open(url,'popUpWindow','height=300,width=400,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
        
    },
    
    clickTwButton: function(cmp, event, helper) {
        var message = encodeURIComponent(cmp.get("v.socialmedia"));
        var init = encodeURIComponent(cmp.get("v.shortURL")); console.log(init);
        var url = 'https://twitter.com/intent/tweet?url='+init+'&text='+message;
        window.open(url,'popUpWindow','height=300,width=400,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
        
    },
    
    clickCopyMobile: function(cmp, event, helper) {
        var holdtxt = document.getElementById("holdtext");
        holdtxt.select();
        console.log(holdtxt);
        
    },
    
    clickEmailButton: function(cmp, event, helper){
        var tool = cmp.get("v.emailTool");
        if(tool != 'Open email app'){
            var modalBody;
            $A.createComponent(
                "FieloRFL:modalContent",
                {
                    "completeURL": cmp.getReference("v.completeURL"),
                    "sendEmail": cmp.getReference("v.sendEmail"),
                    "emailTemplate":cmp.getReference("v.emailTemplate"),
                },
                function(content, status, url) {
                    if (status === "SUCCESS") { 
                        modalBody = content;             
                        cmp.find('modal').showCustomModal({
                            header: "Write the e-mails",
                            body: modalBody, 
                            showCloseButton: true,
                            cssClass: "mymodal",
                            
                        })
                    }
                })
            
        }else{
            
            var init = cmp.get("v.shortURL");
            var url = cmp.get("v.shortURL");
            var mailto = cmp.get("v.mailto");
            mailto = 'mailto:?subject='+
                encodeURIComponent(cmp.get("v.emailsubject"))+
                '&body='+ encodeURIComponent(cmp.get("v.emailbody") +'\n\n ' + init +'\n\n') ;
            cmp.set("v.mailto",mailto);
            
        }        
    },
    
    clickGOButton: function(cmp, event, helper) {
        var message = encodeURIComponent(cmp.get("v.socialmedia"));
        var init = encodeURIComponent(cmp.get("v.shortURL")); console.log(init);
        var url = 'https://plus.google.com/share?url='+init+'&text='+message;
        window.open(url,'popUpWindow','height=300,width=400,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
        
    },
    
    clickLKButton: function(cmp, event, helper) {
        var message = encodeURIComponent(cmp.get("v.socialmedia"));
        var init = encodeURIComponent(cmp.get("v.shortURL")); 
        var url = 'https://www.linkedin.com/shareArticle?mini=true&url='+init+'&title='+message;
        window.open(url,'popUpWindow','height=300,width=400,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
        
    },
    
    clickVIButton: function(cmp, event, helper) {
        var message = cmp.get("v.socialmedia");
        var init = cmp.get("v.shortURL"); 
        var url = 'https://3p3x.adj.st/?adjust_t=u783g1_kw9yml&adjust_fallback=https%3A%2F%2Fwww.viber.com%2F%3Futm_source%3DPartner%26utm_medium%3DSharebutton%26utm_campaign%3DDefualt&adjust_campaign=Sharebutton&adjust_deeplink=' + 
            encodeURIComponent("viber://forward?text=" + encodeURIComponent(message + " " + init)); console.log(url);    
        cmp.set("v.viberurl",url);
    },
    
    clickSMSButton: function(cmp, event, helper){
        
        var message = cmp.get("v.socialmedia");
        var init =  encodeURIComponent(cmp.get("v.shortURL"));
        var url = 'sms:?&body='+init;
        cmp.set("v.smsLink", url);
    },
   
    
})