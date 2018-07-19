({    
    showMyToast : function(component, event, helper,result, errorMsg) {
        var message;

        var success = {"type": "sucess", "title": "Success!", "message": "The e-mail was sent." };
        var error = {"type": "error", "title": "Error!", "message": errorMsg  };
        
        if(result){
            message = success;           
        }else{
            message = error;      
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(message); 
       
        toastEvent.fire();
    },
    
    sendSGMail : function(cmp, event, helper) {   
        
        //get the email list
        var email = cmp.get("v.email"); console.log('email: '+email);
        var emails = email.split(','); console.log('emails: '+emails);
        
        //get the logged in user
        var link = cmp.get("v.completeURL"); console.log(link);
        var memberMap = cmp.get("v.memberMap"); console.log(memberMap);
        var p = {"program":memberMap.FieloPLT__Program__r.Name,
                 "link": link,
                 "memberName":memberMap.Name,
                };  
        console.log(p);
        
        //get the email template
        var emailTemplate = cmp.get("v.emailTemplate"); console.log(emailTemplate);        
        var action = cmp.get("c.sgSendMail");        
        action.setParams({
            emails: emails,
            p:p,
            emailTemplate:emailTemplate
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                console.log(response.getReturnValue());
                
                cmp.find("modal").notifyClose();
                //cmp.set("v.hideSuccessMsg", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showMyToast(cmp, event, helper,false,errors[0].message);   
                    }
                } else {
                    console.log("Unknown error");
                    helper.showMyToast(cmp, event, helper,false,"Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    sendSFMail: function(cmp, event, helper) {   
        var link = cmp.get("v.completeURL");
        
        //get the email list
        var email = cmp.get("v.email"); console.log('email: '+email);
        var emails = email.split(','); console.log('emails: '+emails);
        
        //get the logged in user
        //var link = cmp.get("v.completeURL"); console.log(link);
        var memberMap = cmp.get("v.memberMap"); //console.log(memberMap);
        
        //get the email template
        var emailTemplate = cmp.get("v.emailTemplate"); //console.log(emailTemplate);
        var message = "Hi! \n\n You were referenced by " + memberMap.Name+" to join the Contractor Program.\n \n Click in the link below to join:\n\n"+link;
        
        var action = cmp.get("c.sendMail");
        action.setParams({             
            emails: emails,
            subject: 'Join our program!',
            message: message,
            //templateName:emailTemplate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                console.log(response.getReturnValue()); 
                cmp.find("modal").notifyClose();
                //cmp.set("v.hideSuccessMsg", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showMyToast(cmp, event, helper,false,errors[0].message);   
                    }
                } else {
                    console.log("Unknown error");
                    helper.showMyToast(cmp, event, helper,false,"Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})