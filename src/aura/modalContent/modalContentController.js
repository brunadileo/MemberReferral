({
    doInit : function(component, event, helper) {
        console.log(component.get("v.sendEmail"));
        var action = component.get("c.getMember");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                component.set("v.memberMap",response.getReturnValue());
                console.log(component.get("v.memberMap")); 
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    sendMailCont: function(component, event, helper){
        
        var url = component.get("v.url");
        var memberId = component.get("v.memberMap.Id");  console.log('memberId: '+memberId);       
        var memberName = component.get("v.memberMap.Name"); console.log('name: '+memberName);
        var program = component.get("v.memberMap.FieloPLT__Program__c"); console.log('program: '+program);
        var email = component.get("v.email"); 
        var emails = email.split(','); console.log('emails: '+emails);
        
        var link = url+'registration?member='+memberId+'&prog='+program;
        console.log('link: '+ link);
        
        var message = "Hi! \n\n You were referenced by" + memberName+" to join the Contractor Program.\n \n Click in the link below to join:\n\n"+link;
        
        var action = component.get("c.sendMail");
        action.setParams({             
            emails: emails,
            subject: 'Join the Contractor program',
            message: message,
            templateId:null
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                console.log("Message: " + response.getReturnValue());              
                helper.showMyToast(component, event, helper,true);
                component.find("modal").notifyClose();
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showMyToast(component, event, helper,false,errors[0].message);
                        component.find("modal").notifyClose();
                    }
                } else {
                    console.log("Unknown error");
                    helper.showMyToast(component, event, helper,false,"Unknown error");
                    component.find("modal").notifyClose();
                }
            }
        });
        $A.enqueueAction(action);
          
    },
    
    chooseMailTool: function(cmp, event, helper){
        var sendEmail = cmp.get("v.sendEmail"); console.log('chooseMailTool:' +sendEmail);
        if(sendEmail == 'SendGrid'){
            helper.sendSGMail(cmp, event, helper);
        }else if(sendEmail == 'Salesforce'){
            helper.sendSFMail(cmp, event, helper);
        }
        
    },
    
})