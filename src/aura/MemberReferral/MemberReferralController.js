({
    doInit : function(cmp, event, helper) {		
        
        
    },
    handleShowModal : function(component, event, helper) {
        
        var modalBody;
        $A.createComponent("c:modalCopyToClipboard",
                           {
                               "url": component.getReference("v.url"),
                               "memberMap":memberMap,
                               "showFB":component.getReference("v.showFB"),
                               "showWP":component.getReference("v.showWP"),
                               "showTW":component.getReference("v.showTW"),                                   
                               "showLK":component.getReference("v.showLK"),
                               "showGO":component.getReference("v.showGO"),
                               "showVI":component.getReference("v.showVI"),           
                               "showEmail":component.getReference("v.showEmail"),
                               "sendEmail":component.getReference("v.sendEmail"),
                               
                           },
                           function(content, status, url) {
                               if (status === "SUCCESS") {   
                                   modalBody = content;
                                   component.find('modalCopy').showCustomModal({
                                       header: "Send the link to yout friends!",  //create custom label
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal",
                                       
                                   })
                               }
                               else{
                                   console.log('chegando aqui 3');
                               }
                           })
    }
    
})