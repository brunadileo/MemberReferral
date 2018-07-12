({
    afterRender : function(cmp,helper){
        this.superAfterRender();
        //worked
        /*var bgcolor = cmp.get("v.bgcolor");
        cmp.find('body').getElements()[0].style.backgroundColor = bgcolor;*/
        
        //worked
        /*document.styleSheets[0].addRule('.cHeader','background-color: pink;',1); 
        document.styleSheets[0].addRule('.cCenterPanel','background-color: blue;',1);      
        document.styleSheets[0].addRule('.inputContainer','background-color: #ccc;',1);
        document.styleSheets[0].addRule('.registration-input','background-color: red;',1);
        for(var i=0;inputs.length<i;i++){
            
            //document.styleSheets[0].addRule('.slds-input,'background-color: #000 !important;',1);
        }*/
        
        
        /*var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = 'https://c.na59.visual.force.com/resource/1529102890000/FacebookJS';
        document.body.appendChild(script);*/
        
    }
    
})