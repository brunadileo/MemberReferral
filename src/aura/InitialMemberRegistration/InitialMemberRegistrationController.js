({
    searchMember : function(cmp, event, helper) {
        
        var action = cmp.get("c.getMember");
        action.setParams({            
            email:cmp.get("v.email")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS") { 
                cmp.set("v.showSearch",false);
                var memberList = response.getReturnValue(); console.log(memberList);                
                if(memberList){
                    cmp.set("v.memberList",memberList);
                    if(memberList.length == 0){
                        var defaultProgram = cmp.get("v.defaultProgram"); console.log(defaultProgram);
                        if(!defaultProgram){
                            helper.findProgram(cmp, event, helper);
                            cmp.set("v.showProgramList", true);
                        }
                        cmp.set("v.showRegistration",true);
                    }else if(memberList.length == 1){
                        if(memberList[0].FieloPLT__Status__c == 'Active'){
                            cmp.set("v.member",memberList[0].Id); console.log(cmp.get("v.member"));
                            helper.fireSearchMemberEvent(cmp, event, helper);
                        }else{
                            helper.showErrorToast(cmp, event, helper,$A.get("$Label.c.MemberStatus")+' '+memberList[0].FieloPLT__Status__c);
                        	cmp.set("v.showSearch",true);
                        }
                    }else{
                        var newList = [];
                        for (var i = 0; i < memberList.length; i++) {
                            if(memberList[i].FieloPLT__Status__c == 'Active'){
                                newList.push(memberList[i]);
                            }
                        }console.log(newList);
                        if(newList.length>1){
                            for (var i = 0; i < memberList.length; i++) {
                                var row = newList[i];
                                if (row.FieloPLT__Program__r){ 
                                    row.programName = row.FieloPLT__Program__r.Name;
                                }
                            }
                            cmp.set("v.data",newList);console.log(cmp.get("v.data"));
                            cmp.set("v.showMemberList",true);    
                        }else if(newList.length==1){
                            cmp.set("v.member",newList[0].Id); console.log(cmp.get("v.member"));
                            helper.fireSearchMemberEvent(cmp, event, helper);
                        }else{
                            helper.showErrorToast(cmp, event, helper,$A.get("$Label.c.MemberStatus")+' '+memberList[0].FieloPLT__Status__c);
                        	cmp.set("v.showSearch",true);
                        } 
                    }
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }  
        });
        $A.enqueueAction(action);
    },
    
    backMemberList : function(cmp, event, helper) {
        cmp.set("v.showSearch",true);
        cmp.set("v.showRegistration",false);
        cmp.set("v.showMemberList",false);
        cmp.set("v.showProgramList",false);
    },
    
    nextMemberList : function(cmp, event, helper) {
        var member = cmp.get('v.selectedData');
        cmp.set('v.member',member[0].Id);
        helper.fireSearchMemberEvent(cmp, event, helper);
    },
    
    backProgramList : function(cmp, event, helper) {
        cmp.set("v.showSearch",true);
        cmp.set("v.showRegistration",false);
        cmp.set("v.showMemberList",false);
        cmp.set("v.showProgramList",false);       
    },
    
    nextProgramList : function(cmp, event, helper) {
        cmp.set("v.showProgramList", false);  
        cmp.set("v.showRegistration",true);
    },
    
    updateSelectedMember : function(cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedData', selectedRows);
        console.log(cmp.get('v.selectedData'));
    },
    
    updateSelectedProgram : function(cmp, event, helper){
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.defaultProgram', selectedRows[0].Id);
        console.log(cmp.get('v.defaultProgram'));
        
    },
    
    backRegistration : function(cmp, event, helper) {
        var reset = cmp.get('v.resetDefaultProgram');
        if(reset){
            cmp.set("v.showSearch",false);
            cmp.set("v.showRegistration",false);
            cmp.set("v.showMemberList",false);
            cmp.set("v.showProgramList",true);    
        }else{
            cmp.set("v.showSearch",true);
            cmp.set("v.showRegistration",false);
            cmp.set("v.showMemberList",false);
            cmp.set("v.showProgramList",false);
        }
    },
    
    
    clickSave : function(cmp, event, helper) {
        
        var agreement1 = cmp.get('v.input1'); console.log(agreement1);
        var agreement2 = cmp.get('v.input2'); console.log(agreement2);
        var agreement3 = cmp.get('v.input3'); console.log(agreement3);
        
        function dataMap(firstName, lastName, email, program){
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.program = program;
            
        }
        if(agreement1 && agreement2 && agreement3){
            cmp.set('v.isLoading',true);
            cmp.set("v.showRegistration",false);
            /*function createData(contact, lead, account){
            this.contact = contact;
            this.lead = lead;
            this.account = account;                           
        }*/
            
            var dataMap = new dataMap(cmp.get("v.firstName"),cmp.get("v.lastName"),cmp.get("v.email"), cmp.get("v.defaultProgram"));
            //var createData = new createMap(cmp.get("v.createContact"),cmp.get("v.createLead"),cmp.get("v.createAccount"));
            
            var action = cmp.get("c.createMember");
            action.setParams({   
                dataMap:dataMap
            })
            action.setCallback(this, function(response) {
                var state = response.getState();           
                if (state === "SUCCESS") { 
                    cmp.set("v.showSearch",false);
                    var member = JSON.parse(response.getReturnValue()); console.log(member);
                    if(member.success){
                        cmp.set('v.isLoading',false);
                        cmp.set("v.member",member.success); console.log(cmp.get("v.member"));      
                        helper.fireSearchMemberEvent(cmp, event, helper);
                    }else if(member.error){
                        console.log("Error message: " + member.error);
                    }
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
        }else{
            helper.showErrorToast(cmp, event, helper,'You need to check all checkboxes.');
        }
    },
    
    doInit : function(cmp, event, helper) {
        var defaultProgram = cmp.get('v.defaultProgram');
        if(defaultProgram == null){
            cmp.set('v.resetDefaultProgram',true);
        }else{
            cmp.set('v.resetDefaultProgram',false);
        }
    }
    
})