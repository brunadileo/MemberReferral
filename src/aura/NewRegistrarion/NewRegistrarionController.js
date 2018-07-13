({
    doInit: function(cmp, event, helper) {  
        //get the url from the browser
        cmp.set("v.url",window.location.href);       
        var url = cmp.get("v.url");
        var path = url.split("?"); //split the url in two; the 2nd list item has the query params
        var qpList = path[1].split("="); //split the query params in a list with the name and the value
        var qptemp = []; 
        var qp = {};
        var i = 0; 
        var j = 1;
        
        if(url != ''){
            if(qpList.length>0){
                for(i; i<qpList.length;i++){
                    if(!qpList[i].includes("&")){
                        qptemp.push(qpList[i]);
                    }else{
                        var temp = qpList[i].split("&");
                        qptemp.push(temp[0]);
                        qptemp.push(temp[1]);
                    }
                }
                console.log(qptemp);
            }
            
            if(qptemp != ''){
                for(j;j< (qptemp.length+1); j++){         
                    if(j == 1 || j%2 == 1){
                        console.log(j);
                        qp[qptemp[j-1]] = qptemp[j];
                    }
                }
                console.log(qp);
                cmp.set("v.member.Id",qp.member); //console.log(cmp.get("v.member.Id"));
                cmp.set("v.program.Id",qp.prog); //console.log(cmp.get("v.program.Id"));
            }
        }
        
        var action = cmp.get("c.getLabels");                      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                console.log(obj);
                cmp.set("v.firstname.Label",obj.firstname); console.log(cmp.get("v.firstname.Label"));
                cmp.set("v.lastname.Label",obj.lastname); console.log(cmp.get("v.lastname.Label"));
                cmp.set("v.email.Label",obj.email); console.log(cmp.get("v.email.Label"));
                cmp.set("v.mobile.Label",obj.mobilephone); console.log(cmp.get("v.mobile.Label"));
                cmp.set("v.program.Label",obj.pLabel); console.log(cmp.get("v.program.Label"));
                cmp.set("v.member.Label",obj.mLabel); console.log(cmp.get("v.member.Label"));
            }else{
                var errors = response.getError();
                if(errors){
                    var i = 0;
                    for (i;i<errors.length;i++){
                        console.log("Error message: " + errors[i].message);                        
                    }
                }           
            }
        });            
        $A.enqueueAction(action);
        
        var action2 = cmp.get("c.getExtraFields");           
        action2.setParams({ 
            extraFields1 : cmp.get("v.fieldset1"),
            extraFields2 : cmp.get("v.fieldset2"),
            extraFields3 : cmp.get("v.fieldset3")
        });        
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var r = JSON.parse(response.getReturnValue());
                var i = 1;
                for(i;i<(r.length+1);i++){
                    cmp.set("v.ef"+i+".Object",r[i-1].object);
                    cmp.set("v.ef"+i+".Name",r[i-1].name);
                    cmp.set("v.ef"+i+".Label",r[i-1].label);
                    cmp.set("v.ef"+i+".Type",r[i-1].type);
                    
                    //console.log(cmp.get("v.ef"+i+".Name"));
                    //console.log(cmp.get("v.ef"+i+".Label"));
                    var div1 = cmp.find("ef"+i);
                    $A.util.addClass(div1, "inputContainer"); //console.log('chegaaquiii');
                }
                
            }else{
                console.log('ERROR');
            }
        });        
        $A.enqueueAction(action2);
        
        var member = cmp.get("v.member.Id"); 
        if(member){ 
            var action3 = cmp.get("c.getNames");           
            action3.setParams({ 
                memberId : cmp.get("v.member.Id")
            });            
            action3.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var obj = response.getReturnValue();
                    console.log(obj);
                    cmp.set("v.program.Name",obj.pName); console.log(cmp.get("v.program.Name"));
                    cmp.set("v.program.Id",obj.pId); console.log(cmp.get("v.program.Id"));
                    cmp.set("v.member.Name",obj.member); console.log(cmp.get("v.member.Name"));                   
                }else{
                    console.log('ERROR');
                }
            });            
            $A.enqueueAction(action3);
        }
                
    },    
    
    nextStep: function(cmp, event, helper) {
        //var smoker = cmp.get("v.smoker");
        //var showPrivacy = cmp.get("v.showPrivacy");
        cmp.set("v.showPrivacy",false);
        cmp.set("v.hideSuccessMsg",true);
        var i = 1;
        for(i;i<4;i++){
            console.log('chega aqui');
            //var div1 = cmp.find("ef"+i);
            $A.util.addClass(cmp.find("ef"+i), "inputContainer"); 
        }
    },    
    
    saveForm: function(cmp, event, helper){
        cmp.set("v.isWaiting",true);
        var createUser = cmp.get("v.createUser"); console.log(createUser);
        var createLead = cmp.get("v.createLead"); console.log(createLead);
        var createMember = cmp.get("v.createMember"); console.log(createMember);
        var createContact = cmp.get("v.createContact"); console.log(createContact);
        
        var firstname = cmp.get("v.firstname"); console.log(firstname);
        var lastname= cmp.get("v.lastname"); console.log(lastname);
        var email = cmp.get("v.email"); console.log(email);
        var program = cmp.get("v.program"); console.log(program);
        var member = cmp.get("v.member"); console.log(member);
        
        var fields2 = {Name: firstname,
                       LastName: lastname,
                       FieloPLT__Email__c:email,                       
                       FieloPLT__Program__c: program.Id,
                       ReferralMember__c: member.Id};
        
        var fields = JSON.stringify(fields2);
        var action = cmp.get("c.selfRegister");
        action.setParams({
            fields: fields,
            createUser: createUser,
            createLead: createLead,
            createMember: createMember,
            createContact: createContact
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.isWaiting",false);
                cmp.set("v.hideSuccessMsg", !cmp.get("v.hideSuccessMsg"));
                cmp.set("v.showSuccessMsg", !cmp.get("v.showSuccessMsg"));
            }else{
                cmp.set("v.isWaiting",false);
                var errors = response.getError();
                helper.showMyToast(cmp, event, helper,false,errors[0].message);
                if(errors){
                    var i = 0;
                    for (i;i<errors.length;i++){
                        console.log("Error message: " + errors[i].message);                        
                    }
                }           
            } 
        });       
        $A.enqueueAction(action);
        
    },
    
    
    
})