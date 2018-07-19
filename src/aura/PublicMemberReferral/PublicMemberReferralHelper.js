({
    continueInit: function(cmp,event,helper,params) {  
        
        //get the url from the browser       
        var url = cmp.get("v.url"); console.log(url);
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
                //console.log(qptemp);
            }
            
            var params2 = Object.keys(params); console.log(params2);
            
            if(qptemp != ''){
                for(j;j< (qptemp.length+1); j++){         
                    if(j == 1 || j%2 == 1){
                        console.log(qptemp[j-1]);                        
                        if(params2.includes(qptemp[j-1])){
                            console.log(params[qptemp[j-1]]);
                            qp[params[qptemp[j-1]]] = qptemp[j];
                        }
                    }
                }
                console.log(qp);                
            }
        }
        
        var action = cmp.get("c.queryMember");
        action.setParams({
            params:qp,
            externalClass:cmp.get("v.MemberCreationExternalClass")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var res = response.getReturnValue();
                console.log(res);
                cmp.set("v.member",res);
                helper.openComponent(cmp,event,helper);
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
    
    openComponent: function(cmp,event,helper){
        $A.createComponent("c:modalCopyToClipboard",
                           {
                               "url":cmp.getReference("v.url"),
                               "showFB":cmp.getReference("v.showFB"),
                               "showTW":cmp.getReference("v.showTW"),
                               "showEmail":cmp.getReference("v.showEmail"),
                               "showCopy":cmp.getReference("v.showCopy"),
                               "showWP":cmp.getReference("v.showWP"),
                               "showLK":cmp.getReference("v.showLK"),
                               "showGO":cmp.getReference("v.showGO"),
                               "showVI":cmp.getReference("v.showVI"),
                               "communityURL":cmp.getReference("v.communityURL"),
                               "emailTool":cmp.getReference("v.emailTool"),
                               "member":cmp.getReference("v.member"),
                               "customSettingIn":cmp.getReference("v.customSettingIn"),
                               "customSettingOut":cmp.getReference("v.customSettingOut"),
                               "customSettingMessages":cmp.getReference("v.customSettingMessages"),
                               "pageName":cmp.getReference("v.pageName"),  
                               "socialmedia":cmp.getReference("v.socialmedia"),
                               "emailsubject":cmp.getReference("v.emailsubject"), 
                               "emailbody":cmp.getReference("v.emailbody"), 
                               
                           },
                           function(newComp, status, errorMessage){
                               //Add the new button to the body array
                               if (status === "SUCCESS") {
                                   var targetCmp = cmp.find("container");
                                   var body = targetCmp.get("v.body");
                                   body.push(newComp);
                                   targetCmp.set("v.body", body);                                     
                               }else if (status === "ERROR") {
                                   console.log("Error: " + errorMessage);
                                   // Show error message
                               }
                           }
                          );
        
    }
})