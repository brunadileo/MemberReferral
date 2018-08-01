public without sharing class MemberReferralController {
    @AuraEnabled
    public static String queryMember(String url, String inboundSetup, String memberCreationClass){
        Map<String,String> resultMap = new Map<String,String>();
        
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
        List<String> parameters = new List<String>(); // list of parameters name
        List<String> fields = new List<String>{'Id','FieloPLT__Status__c' };
            Map<String,String> queryWhere = new Map<String,String>(); //{fieldApiName : field value}
        for(String i: inboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(i);	
            if(ps.ObjectApiName__c == 'FieloPLT__Member__c' && paramsMap.keySet().contains(ps.Parameter__c)){
                memberProcess = true;
                if(ps.FieldApiName__c != 'Id' && ps.FieldApiName__c != 'FieloPLT__Status__c' ){
                    fields.add(ps.FieldApiName__c);
                }
                queryWhere.put(ps.FieldApiName__c,paramsMap.get(ps.Parameter__c));
            }
        }
        System.debug(inboundList);
        
        if(memberProcess){
            String fieldset = String.join(fields, ',');
            String query = 'SELECT '+fieldset+ ' FROM FieloPLT__Member__c WHERE ';
            List<String> qWhereList = new List<String>();
            for(String q: queryWhere.keySet()){
                query += (q + ' = ' +  '\''+queryWhere.get(q)+ '\'');
            }
            System.debug(query);
            FieloPLT__Member__c m = Database.query(query); System.debug(m);
            if(m.FieloPLT__Status__c == 'Active'){
                resultMap.put('member',m.Id);            
                return JSON.serialize(resultMap);
            }else{
                resultMap.put('error',Label.MemberStatus +' '+ m.FieloPLT__Status__c);            
                return JSON.serialize(resultMap);
            }
        }else{
            return findRelatedMember(paramsMap,inboundList, memberCreationClass);
        }
        
    }
    
    public static String findRelatedMember(Map<String,String> paramsMap, String[] inboundList, String memberCreationClass){
        Map<String,String> resultMap = new Map<String,String>();
        
        String programId, lookupRelationship;
        Map<String,String> createMemberMap = new Map<String,String>{'field' => 'Id'};
            
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
                    createMemberMap.put('object',ps.ObjectApiName__c);
                    if(objFields.keySet().contains(ps.ObjectApiName__c)){
                        Map<String,String> temporaryMap = objFields.get(ps.ObjectApiName__c);
                        temporaryMap.put(ps.FieldApiName__c, paramsMap.get(ps.Parameter__c)); 
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
        System.debug(lookupRelationship.substringBeforeLast('__c'));
        String memberStatus = lookupRelationship.substringBeforeLast('__c')+'__r.FieloPLT__Status__c';
        List<String> fieldList = new List<String>{lookupRelationship, memberStatus};
            String obj;
        //List<String> queryWhere = new List<String>();
        Map<String,String> fieldMap= new Map<String,String>();
        if(!objFields.isEmpty()){
            for(String s: objFields.keySet()){ 
                obj = s; System.debug(obj); 
                fieldMap = objFields.get(s);
                for(String field : fieldMap.keySet()){
                    String o = fieldMap.get(field);
                    fieldList.add(field);                    
                }
            }
            
        }else{
            return null;
        }
        
        String fieldset = String.join(fieldList,',');
        String objQuery = 'SELECT '+ fieldset +' FROM '+ obj + ' WHERE ';
        for(String field: fieldMap.keySet()){
            objQuery += (field + ' = ' +  '\''+fieldMap.get(field)+ '\'');
        }
        System.debug(objQuery);
        
        sObject sobj;
        String memberId;
        try{
            sobj = Database.query(objQuery); System.debug(sobj);
            memberId = (String)sobj.get(lookupRelationship); System.debug(memberId);
			createMemberMap.put('value',sobj.Id);System.debug(createMemberMap);            
            sObject memberInfo = sobj.getSObject(lookupRelationship.substringBeforeLast('__c')+'__r'); System.debug(memberInfo);    
            String memberStatus2 = (String)memberInfo.get('FieloPLT__Status__c'); System.debug(memberStatus2); 
            if(memberStatus2 == 'Active'){
                resultMap.put('member',memberId);            
                return JSON.serialize(resultMap);
            }else{
                resultMap.put('error',Label.MemberStatus +' '+ memberStatus2);            
                return JSON.serialize(resultMap);
            }
            
        }catch(Exception e){
            sobj = null;
            memberId = null;
        }
        
        if(String.isNotBlank(memberId)){
            resultMap.put('member',memberId);
            return JSON.serialize(resultMap);
        }else{
            System.debug(createMemberMap);  
            try{
                return createMember(memberCreationClass, createMemberMap, programId);
            }catch(Exception e){
                FieloPLT__ErrorLog__c errorLogToAdd = new FieloPLT__ErrorLog__c();
                errorLogToAdd.FieloPLT__Message__c = e.getMessage();
                errorLogToAdd.FieloPLT__LineNumber__c = e.getLineNumber();  
                insert errorLogToAdd ;
                resultMap.put('error',e.getMessage());
                return JSON.serialize(resultMap);
            }
        }
        
    }
    
    public static String createMember(String classNameComplete, Map<String,String> createMemberMap, Id programId){
        Map<String,String> resultMap = new Map<String,String>();
        String[] classNameList;
        String namespace, className;
        
        if(classNameComplete.contains(',')){
            classNameList = classNameComplete.split(',');
            namespace = classNameList[0]; 
            className = classNameList[1]; 
        }else{
            namespace = null; 
            className = classNameComplete; 
        }
        
        try{
            Type t = Type.forName(namespace,className);
            MemberCreation msInstance = (MemberCreation)t.newInstance();
            Map<String, String> createdMembers = msInstance.createMembers(new Set<Id>{createMemberMap.get('value')},programId);
            if(createdMembers.keySet().contains('error')){
                FieloPLT__ErrorLog__c errorLogToAdd = new FieloPLT__ErrorLog__c();
                errorLogToAdd.FieloPLT__Message__c = createdMembers.values()[0];
                insert errorLogToAdd ;
                resultMap.put('error',createdMembers.values()[0]);
                return JSON.serialize(resultMap);
            }else{
                resultMap.put('member',createdMembers.values()[0]);
                return JSON.serialize(resultMap);
            }
        }catch(Exception e){
            FieloPLT__ErrorLog__c errorLogToAdd = new FieloPLT__ErrorLog__c();
            errorLogToAdd.FieloPLT__Message__c = e.getMessage();
            errorLogToAdd.FieloPLT__LineNumber__c = e.getLineNumber();
            insert errorLogToAdd ;
            resultMap.put('error',e.getMessage());
            return JSON.serialize(resultMap);
        }        
    }
    
    @auraEnabled    
    public static String setMember(String memberId){
        FieloPLT__Settings__c settings = FieloPLT__Settings__c.getInstance(UserInfo.getUserId());
        settings.CurrentMemberId__c = memberId;
        upsert settings;
        
        return  settings.CurrentMemberId__c;
    }
    
    @auraEnabled    
    public static String setMemberbyUser(){
        String userId = UserInfo.getUserId();
        
        if(String.isNotBlank(userId)){
            FieloPLT__Member__c[] m = [SELECT Id FROM FieloPLT__Member__c WHERE FieloPLT__User__c =: userId];
            return m[0].Id;
        }else{
            return null;
        }
        
    }
}