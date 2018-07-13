({
    handleSelfRegister: function (component, event, helper) {        
        var spinner = $A.get("e.FieloPLT:ToggleSpinnerEvent");
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }        
        var regConfirmUrl = component.get("v.regConfirmUrl");
        var startUrl = component.get('v.startUrl');
        
        var includePassword = component.get("v.includePasswordField");
        var password = component.get("v.password");
        var confirmPassword = component.get("v.confirmPassword");
        
        var action = component.get("c.selfRegister");
        
        var programId = component.get('v.program');        
        var extraFields = component.get('v.extraFieldsValues');        
        extraFields.FieloPLT__Program__c = programId;
        
        var agreement = component.get('v.agreement');
        if(agreement){
            extraFields.FieloPLT__Agreement__c = agreement.Id;
        }        
        action.setParams({
            fields: JSON.stringify(extraFields),
            includePassword:includePassword,
            password:password,
            confirmPassword:confirmPassword,
            regConfirmUrl:regConfirmUrl,
            startUrl: startUrl
        });          
        action.setCallback(this, function(a){
            var spinner = $A.get("e.FieloPLT:ToggleSpinnerEvent");
            var toastEvent = $A.get("e.force:showToast");
            var rtnValue = a.getReturnValue();
            if(spinner){
                spinner.setParam('show', false);
                spinner.fire();    
            }
            if (rtnValue !== null) {                
                var errorMsg = rtnValue;
                toastEvent.setParams({
                    "title": errorMsg,
                    "message": " ",
                    "type": "error"
                });
                toastEvent.fire();
                component.set('v.agreementChecked', false);
                component.set('v.showAgreement', false);
            }else{
                component.set('v.showSuccesfulRegistration', true);
            }
        });
        $A.enqueueAction(action);
    },
    checkRequired: function(component, event, helper){           
        var requiredFields = component.get('v.requiredFields');        
        var extraFields = component.get('v.extraFieldsValues') || {};
        var res = true;        
        requiredFields.forEach(function(field){                        
            if(!extraFields[field] || extraFields[field] == ''){                
                res = false;
            }
        })        
        return res;
    },
    
    showMyToast : function(component, event, helper,result, errorMsg) {
        
        var success = {"title": "Success!", "message": "The e-mail was sent." };
        var error = {"title": "Error!", "message": errorMsg  };
        
        var toastEvent = $A.get("e.force:showToast");
        if(result){           
            toastEvent.setParams({"type": "sucess", "message": "The e-mail was sent."});      
        }else{
            toastEvent.setParams({"type": "error","message": errorMsg+' Try again!' });      
            
        }
        
        toastEvent.fire();
        console.log('chega no toast3');
    },
    
    
})