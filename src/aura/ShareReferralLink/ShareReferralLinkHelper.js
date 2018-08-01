({
    showMyToast : function(component, event, helper, type) {
        var device = component.get("v.device");
        var success = {"type": "success", "message": $A.get("$Label.c.CopytoClipboardSuccess") };
        var error = {"type": "error", "message": "Error trying to create link" };
        
        var toastEvent = $A.get("e.force:showToast");
        if(type == 'success'){
            toastEvent.setParams(success); 
        }else{
            toastEvent.setParams(error);
        }
        toastEvent.fire(); 
        
    },
    
    continueInit: function(cmp,event,helper,params) {  
        
        var url = cmp.get("v.communityURL"); console.log('LEITURA: '+url);
        var pagename = cmp.get("v.pageName");
        var classname = cmp.get("v.LinkShortenerClass");
        
        var link = url+pagename+'?';
        for(var s in params){            
            link += (s +'='+params[s]+'&');
        }
        link = link.slice(0, -1); console.log(link);console.log(classname);
        
        if(link && classname){
            var action = cmp.get("c.getShortLink");
            action.setParams({
                url: link,
                classNameComplete:classname,
                apiKey: LinkShortenerApiKey   
            });            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {    
                    console.log("Shortened Link: " + response.getReturnValue());
                    cmp.set("v.shortURL",response.getReturnValue());                  
                }
            });
            $A.enqueueAction(action);            
        }else if (link && (!classname)){
            cmp.set("v.shortURL",link)
        }
    },    
    
})