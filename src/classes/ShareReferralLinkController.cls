/*************************** - Fielo - *******************************
* Company: Fielo
* Developer: Bruna Dileo
* Created Date: 19/07/2018
* Description: 
**************************** - Fielo - ******************************/

public without sharing class ShareReferralLinkController {
    
    @AuraEnabled
    public static String getParams(String outboundSetup, String member){
        
        List<String> outboundList = outboundSetup.split(',');
        Map<String,String> paramsMap = new Map<String,String>(); //map with parameters names and values
        List<String> fieldApiNames =  new List<String>(); //list with field API names
        String ObjectApiName, relatedField; //ObjectApiName is the name of the object that is going to be queried
        
        Boolean memberProcess = false; //go through the part of the code that get Member Information
        Boolean hasMemberLookup = false; //go through the part of the code that queries an Object that has an lookup field to Member
        List<String> fieldList = new List<String>(); 
        
        for(String outboundRecord: outboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(outboundRecord);	System.debug(ps.Parameter__c);
            if(ps.ObjectApiName__c == 'FieloPLT__Member__c'){                
                if(ps.FieldApiName__c == 'Id'){
                    fieldApiNames.add(ps.FieldApiName__c);
                    paramsMap.put(ps.Parameter__c,ps.FieldApiName__c);  System.debug(paramsMap);
                }else{
                    fieldApiNames.add(ps.FieldApiName__c);
                    paramsMap.put(ps.Parameter__c,ps.FieldApiName__c);	System.debug(paramsMap);
                }
            }else{
                hasMemberLookup = true; System.debug('hasMemberLookup: '+hasMemberLookup);
            }
        }
        
        System.debug(fieldApiNames);
        System.debug(paramsMap);
        
        String fields = String.join(fieldApiNames,','); System.debug(fields);
        if(String.isNotBlank(fields)){
            if(fields == 'Id'){
                for(String parameter : paramsMap.keySet()){
                    paramsMap.put(parameter,member);System.debug(paramsMap);
                }   
            }else{
                String query = 'SELECT '+fields+ ' FROM FieloPLT__Member__c WHERE Id =: member'; System.debug(query);
                FieloPLT__Member__c m = Database.query(query); System.debug(m);
                for(String parameter : paramsMap.keySet()){                   
                    
                    paramsMap.put(parameter,(String)m.get(paramsMap.get(parameter)));
                }
                
            }
        }
        
        if(hasMemberLookup){
            return findRelatedInfo(outboundList,paramsMap, member);
        }else{
            return JSON.serialize(paramsMap);
        }
        
    }
    
    public static String findRelatedInfo(String[] outboundList, Map<String,String> paramsMap, String member){
        System.debug(member);
        String obj, qWhere;
        Boolean queryUser = false, queryOtherObj = false;
        List<String> fieldApiNames =  new List<String>();
        Map<String,String> fieldsMap = new Map<String,String>();
        Map<String,String> fieldsUserMap = new Map<String,String>();
        
        for(String outboundRecord: outboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(outboundRecord);	System.debug(ps.Parameter__c);
            if(String.isNotBlank(ps.LookupRelationship__c)){
                queryOtherObj = true;                
                fieldsMap.put(ps.Parameter__c,ps.FieldApiName__c);	System.debug(fieldsMap);
                obj = ps.ObjectApiName__c;
                qWhere = ps.LookupRelationship__c;
            }else if(ps.ObjectApiName__c == 'User'){
                queryUser = true;
                fieldsUserMap.put(ps.Parameter__c,ps.FieldApiName__c);
                fieldApiNames.add(ps.FieldApiName__c); System.debug(ps.FieldApiName__c);
            }
        }
        System.debug(fieldApiNames);
        
        if(queryOtherObj){
            try{
                String fields = String.join(fieldsMap.values(),',');            
                String query = 'SELECT '+fields+ ' FROM '+obj+' WHERE '+qWhere+' =: member LIMIT 1'; System.debug(query);
                sObject sobj = Database.query(query); System.debug(sobj);
                System.debug(paramsMap);
                for(String field : fieldsMap.keySet()){
                    System.debug(sobj.get(fieldsMap.get(field)));
                    paramsMap.put(field,(String)sobj.get(fieldsMap.get(field)));
                }
            }catch(Exception e){
                FieloPLT__ErrorLog__c errorLogToAdd = new FieloPLT__ErrorLog__c();
                errorLogToAdd.FieloPLT__Message__c = e.getMessage();
                errorLogToAdd.FieloPLT__LineNumber__c = e.getLineNumber();
                insert errorLogToAdd ;
                return e.getMessage();
            }
        }
        if(queryUser){
            try{
                String fieldsUser = String.join(fieldApiNames,',');
                Id userId = UserInfo.getUserId();
                String queryUserString = 'SELECT '+fieldsUser+ ' FROM User WHERE Id =: userId';
                User u = Database.query(queryUserString);
                for(String field : fieldsUserMap.keySet()){
                    paramsMap.put(field, (String)u.get((String)fieldsUserMap.get(field)));
                }
            }catch(Exception e){
                FieloPLT__ErrorLog__c errorLogToAdd = new FieloPLT__ErrorLog__c();
                errorLogToAdd.FieloPLT__Message__c = e.getMessage();
                errorLogToAdd.FieloPLT__LineNumber__c = e.getLineNumber();
                insert errorLogToAdd ;
                return e.getMessage();
            }
        }
        
        return JSON.serialize(paramsMap);
        
    }
    
    @AuraEnabled
    public static String getShortLink(String url,String classNameComplete, String apiKey){ 
        List<String> classNameList = new List<String>();
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
            Type t = Type.forName(namespace,classname);
            LinkShortener2 link = (LinkShortener2)t.newInstance();                
            return link.shortenLink(url,apiKey);
        }catch(Exception e){
            FieloPLT__ErrorLog__c errorLogToAdd = new FieloPLT__ErrorLog__c();
            errorLogToAdd.FieloPLT__Message__c = e.getMessage();
            insert errorLogToAdd ;
            return e.getMessage();
        }
    }
    
}