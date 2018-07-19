public class PublicMemberReferralController {
 
    @AuraEnabled
    public static String queryMember(String url, String inboundSetup, String memberCreationClass){
        
        String[] urlParams = url.split('&');
        Map<String,String> paramsMap = new Map<String,String>();
        for(String s : urlParams){
            String[] temp = s.split('=');
            paramsMap.put(temp[0], temp[1]); // paramsMap: {parameterName: relatedData};
        }
        System.debug(paramsMap);
        
        //change it to see if its Id, if not query to find result - Id of member
        String[] inboundList = inboundSetup.split(',');
        Boolean memberProcess = false;
        String parameter, qWhere;
        for(String i: inboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(i);	
            if(ps.ObjectApiName__c == 'FieloPLT__Member__c' && paramsMap.keySet().contains(ps.Parameter__c)){
                memberProcess = true;
                parameter = ps.Parameter__c;
                qWhere = ps.FieldApiName__c;  
            }
        }
        System.debug(inboundList);
        
        String fields = 'Id';
        if(memberProcess){
            String value = (String)paramsMap.get(parameter);
            if(qWhere != fields){
                fields += (', '+qWhere);
            }
            String query = 'SELECT '+fields+ ' FROM FieloPLT__Member__c WHERE '+qWhere+'=: value'; System.debug(query);
            FieloPLT__Member__c m = Database.query(query);        System.debug(m);

            return m.Id;
        }else{
            return PublicMemberReferralController.findRelatedMember(paramsMap,inboundList, memberCreationClass);
        }
        
    }
    
    public static String findRelatedMember(Map<String,String> paramsMap, String[] inboundList, String memberCreationClass){
        
        String programId, lookupRelationship;
        Map<String,String> createMemberMap = new Map<String,String>();
        
        //{ObjectApiName__c: {FieldApiName__c(1): fieldValue(1), FieldApiName__c(2): fieldValue(2)}}
        Map<String,Map<String,String>> objFields = new Map<String,Map<String,String>>();
		
        //iterate over the Inbound link Setup (list of custom settings)        
        for(String i: inboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(i);
            if(paramsMap.keySet().contains(ps.Parameter__c)){
                if(String.isNotBlank(ps.LookupRelationship__c)){
                    lookupRelationship = ps.LookupRelationship__c;    System.debug(lookupRelationship);                 
                    Map<String,String> fields = new Map<String,String>();                    
                    fields.put(ps.FieldApiName__c, paramsMap.get(ps.Parameter__c)); System.debug(fields);
                        createMemberMap.put('field','Id');
                        createMemberMap.put('object',ps.ObjectApiName__c);
                    if(objFields.keySet().contains(ps.ObjectApiName__c)){
                        Map<String,String> temp = objFields.get(ps.ObjectApiName__c);
                        temp.put(ps.FieldApiName__c, paramsMap.get(ps.Parameter__c)); 
                    }else{
                        objFields.put(ps.ObjectApiName__c,fields);
                    }
                }else if(ps.ObjectApiName__c == 'FieloPLT__Program__c'){
                    programId = paramsMap.get(ps.ObjectApiName__c);
                }
            }else{
                //if the parameter that is in the property is not in the link, the code should ignore it and continue
                continue; 
            } 
        }
        
        //checks if there is Inbound Link config has a object with Member Lookup Field
        //create the query and do the check
        String fieldset = lookupRelationship;
        String obj, objWhere;
        
        if(!objFields.isEmpty()){
            for(String s: objFields.keySet()){ 
                obj = s; System.debug(obj);
                Map<String,String> fieldList = new Map<String,String>(objFields.get(s));
                for(String field : fieldList.keySet()){
                    String o = fieldList.get(field);
                    if(fieldset == null){ 
                        fieldset = (field + ' ,');
                    }else{ 
                        fieldset += (' ,'+ field); 
                    }
                    
                    if(objWhere == null){
                        objWhere = (field + ' =: o AND '); 
                    }else{ 
                        objWhere += (field + ' =: o AND '); 
                    }
                }
            }
            fieldset = fieldset.substringBeforeLast(' ,');
            objWhere = objWhere.substringBeforeLast(' AND ');
            
        }else{
            return null;
        }
        String objQuery = 'SELECT '+fieldset+' FROM '+obj + ' WHERE '+ objWhere ;
        System.debug(objQuery);
        
        sObject sobj;
        String memberId;
        try{
            sobj = Database.query(objQuery); System.debug(sobj);
            memberId = (String)sobj.get(lookupRelationship); System.debug(memberId);
			createMemberMap.put('value',sobj.Id);
        }catch(Exception e){
            sobj = null;
            memberId =null;
        }
        
        if(String.isNotBlank(memberId)){
            return memberId;
        }else{
            return createMember(memberCreationClass, createMemberMap, programId);
        }
        
    }
    
    public static String createMember(String className, Map<String,String> createMemberMap, Id programId){
        if(String.isNotBlank(className)){
            Type t = Type.forName(className);
            MemberCreation msInstance = (MemberCreation)t.newInstance();
            Map<String, String> createdMembers = msInstance.createMembers(new Set<Id>{createMemberMap.get('value')},programId);
            String createdMember = createdMembers.values()[0];
            return createdMember;
        }else{ 
            return 'Error';
        }
    }
               
    
}