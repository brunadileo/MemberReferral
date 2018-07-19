public class modalController {
       
    @AuraEnabled
    public static String getParams(String outboundSetup, String member){
        System.debug(member);
        List<String> outboundList = outboundSetup.split(',');
        Map<String,String> paramsMap = new Map<String,String>();
        List<String> fieldApiNames =  new List<String>();
        String ObjectApiName;
        
        Boolean memberProcess = false;
        Boolean hasMemberLookup = false;
        
        for(String outboundRecord: outboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(outboundRecord);	System.debug(ps.Parameter__c);
            if(ps.ObjectApiName__c == 'FieloPLT__Member__c'){
                if(ps.FieldApiName__c == 'Id'){
                    paramsMap.put(ps.Parameter__c,ps.FieldApiName__c);                    
                }else{
                    memberProcess = true;
                    paramsMap.put(ps.Parameter__c,ps.FieldApiName__c);	System.debug(paramsMap);
                    fieldApiNames.add(ps.FieldApiName__c);  
                }
            }else{
                hasMemberLookup = true;
            }
        }
        
        if(memberProcess){            
            String fields = String.join(fieldApiNames,',');
            String query = 'SELECT '+fields+ ' FROM FieloPLT__Member__c WHERE Id =: member'; System.debug(query);
            FieloPLT__Member__c m = Database.query(query); 
            for(String parameter : paramsMap.keySet()){
                paramsMap.put(parameter,(String)m.get(paramsMap.get(parameter)));
            }
        }
         
        if(hasMemberLookup){
            return findRelatedInfo(outboundList,paramsMap, member);
        }else{
            return JSON.serialize(paramsMap);
        }
        
    }
    
    public static String findRelatedInfo(String[] outboundList, Map<String,String> paramsMap, String member){
        String obj;
        String qWhere;
        Map<String,String> fieldsMap = new Map<String,String>();
        for(String o: outboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(o);	System.debug(ps.Parameter__c);
            if(String.isNotBlank(ps.LookupRelationship__c)){                
                fieldsMap.put(ps.Parameter__c,ps.FieldApiName__c);	System.debug(fieldsMap);
                obj = ps.ObjectApiName__c;
                qWhere = ps.LookupRelationship__c;
            }
        }
        String fields = String.join(fieldsMap.values(),',');
        String query = 'SELECT '+fields+ ' FROM '+obj+' WHERE '+qWhere+' =: member'; System.debug(query);
        sObject sobj = Database.query(query);
        for(String field : fieldsMap.keySet()){
            paramsMap.put(field,(String)sobj.get(fieldsMap.get(field)));
        }
        
        return JSON.serialize(paramsMap);
        
    }
    
    @AuraEnabled
    public static String getShortLink(String url,String classname){        
        Type t = Type.forName(classname);
        LinkShortener link = (LinkShortener)t.newInstance();                
        return link.shortenLink(url);
    }
    
}