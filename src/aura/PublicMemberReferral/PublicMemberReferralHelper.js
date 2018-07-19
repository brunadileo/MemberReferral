({
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