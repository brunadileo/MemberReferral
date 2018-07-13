public class modalController {
    
    @AuraEnabled
    public static String getShortLink(String url,String classname){        
        Type t = Type.forName(classname);
        LinkShortener link = (LinkShortener)t.newInstance();                
        return link.shortenLink(url);
    }
    
    @AuraEnabled
    public static String getParamsSendLink(String fieldname,Integer quant, String memberId){  
        MemberReferral__c cs = MemberReferral__c.getInstance(fieldname);
        Map<String,String> csMap = new Map<String,String>();
        Integer i;
        for(i = 1; i <= quant; i++){
            System.debug(i);
            if(cs.get('Parameter'+i+'__c') != null){
                System.debug(cs.get('Parameter'+i+'__c'));
                if(cs.get('Field'+i+'__c').toString().contains(',')){
                    System.debug(cs.get('Field'+i+'__c').toString());
                    String[] temp =  cs.get('Field'+i+'__c').toString().split(',');
                    if(temp[0].contains('__c')){
                        csMap.put(cs.get('Parameter'+i+'__c').toString(),temp[0].substringBeforeLast('__c')+'__r.'+temp[1]);
                        //csMap.put(cs.get('Parameter'+i+'__c').toString(),cs.get('Field'+i+'__c').toString());
                    }
                }else{
                    csMap.put(cs.get('Parameter'+i+'__c').toString(),cs.get('Field'+i+'__c').toString());
                }
            }
        }
        System.debug(csMap);
        
        String fieldsList = 'Id';
        for(String p: csMap.values()){
            if((p != 'Id')){
                fieldsList += (','+p);  
            }            
        }
        
        System.debug(fieldsList);
        
        String query = 'SELECT ' + fieldsList +' FROM FieloPLT__Member__c WHERE Id =: memberId LIMIT 1';
        System.debug(query);
        
        sObject member = Database.query(query);
        System.debug(member);
        Map<String,Object> resultMap = new Map<String,Object>();
        for (String p: csMap.keySet()){
            String[] temp = fieldsList.split(',');
            for(i=0;i< temp.size();i++){
                if(csMap.get(p).contains('.')){
                    String[] objField = csMap.get(p).split('\\.');
                    System.debug(member.getSObject(objField[0]).get(objField[1]));
                    if(csMap.get(p) == temp[i].trim() && (member.getSObject(objField[0]).get(objField[1]) != null) ){ 
                        resultMap.put(p,member.getSObject(objField[0]).get(objField[1]));                                      
                    }
                }else if(csMap.get(p) == temp[i].trim() && (member.get(temp[i].trim()) != null)){
                    resultMap.put(p,member.get(temp[i].trim()));
                }
            }
        }
        
        System.debug(resultMap);
        return JSON.serialize(resultMap); 
    }
    
}