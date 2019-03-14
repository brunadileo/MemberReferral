({
    doInit : function(cmp, event, helper) {
        var url = window.location.href; 
        var queryString, params;
        if(url.includes('?')){
            queryString = url.split('?')[1]; console.log(queryString);
        }
        
//FACEBOOK AND GOOGLE+ INTEGRATION
        
      	var check = localStorage.getItem('url');
        if(!check){
            localStorage.setItem('url', queryString);
        }
        
        cmp.set('v.firstname',localStorage.getItem('firstName'));
        cmp.set('v.lastname',localStorage.getItem('lastName'));
        cmp.set('v.email',localStorage.getItem('email'));
        
//FACEBOOK AND GOOGLE+ INTEGRATION
        
        var action = cmp.get("c.getRefferedByMember");
        action.setParams({
            url:queryString,
            inboundSetup:cmp.get("v.customSettingIn")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();      console.log(state);     
            if (state === "SUCCESS") { 
                var res = JSON.parse(response.getReturnValue()); console.log(res);
                if(res == null){
                    cmp.set("v.member",'no member');
                } else{
                    cmp.set("v.member.Value",res.Id); 
                    cmp.set("v.member.Name",res.Name); 
                    cmp.set("v.program.Value",res.FieloPLT__Program__c);
                    cmp.set("v.program.Name",res.programName);
                }
            }else if (state === "ERROR") {
                if (response.getError()) {
                    console.log("Error message: " + response.getError()[0].message);
                }
            }             
        });
        $A.enqueueAction(action);
        
        
    },
    
    clickSave: function(cmp, event, helper) {   
        cmp.set('v.showSpinner',true);
        //create object to control which records are going to be created
        var objMap = {};
        objMap.Account = cmp.get("v.createAccount");
        objMap.Lead = cmp.get("v.createLead");
        objMap.Contact = cmp.get("v.createContact");
        objMap.Member = cmp.get("v.createMember");
        
        var createRecords = JSON.stringify(objMap); console.log(createRecords);
        
        //get form info
        var firstname = cmp.get("v.firstname"); console.log(firstname);
        var lastname= cmp.get("v.lastname"); console.log(lastname);
        var email = cmp.get("v.email"); console.log(email);
        var program = cmp.get("v.program.Value"); console.log(program);
        var member = cmp.get("v.member.Value"); console.log(member);
        
        var fieldsObj = {FirstName: firstname,
                         LastName: lastname,
                         FieloPLT__Email__c:email,                       
                         FieloPLT__Program__c: program,
                         FieloMRF__ReferredBy__c: member};
        
        var fields = JSON.stringify(fieldsObj); console.log(fields);
        
        var otherObjects = cmp.get('v.otherObjects'); console.log(otherObjects);
        
        //call controller
        var action = cmp.get("c.createRecords");
        action.setParams({
            fieldsetStr:fields,
            objectsToCreateStr:createRecords,
            otherObjects:otherObjects
            
        })
        action.setCallback(this, function(response) {
            var state = response.getState();      console.log(state);     
            cmp.set('v.showSpinner',false);
            if (state === "SUCCESS") { 
                cmp.set('v.showForm',false);
                var res = JSON.parse(response.getReturnValue()); console.log(res);
            }else{
                console.log("Error message: " + response.getError()[0].message);
                helper.showToast(cmp, event, helper,response.getError()[0].message, 'error');
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
})