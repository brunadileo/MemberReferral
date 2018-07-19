public class PublicMemberReferralController {
    @AuraEnabled
    public static String getParams(String fieldname,Integer quant){
        MemberReferral__c cs = MemberReferral__c.getInstance(fieldname);
        Map<String,String> csMap = new Map<String,String>();
        Integer i;
        for(i = 1; i <= quant; i++){
            System.debug(i);            
            csMap.put(cs.get('Parameter'+i+'__c').toString(),cs.get('Field'+i+'__c').toString());
        }
        csMap.put('subject',Label.EmailSubject);
        csMap.put('body',Label.EmailBody);
        csMap.put('socialmedia',Label.SocialMediaMessage);
        
        System.debug(csMap);
        return JSON.serialize(csMap);        
    }
    
    @AuraEnabled
    public static String queryMember(Map<String,String> params, String externalClass){
        Integer i = 0; Integer j;     
        
        //create a Set with the contact  
        String obj, fld, program;
        Contact c;
        String ct;
        for(String p:params.keySet()){
            if(p.contains('FieloPLT__Contact__c')){
                ct = p; 
            }else if(p.contains('FieloPLT__Program__c')){
                program = params.get(p); 
            }
        }
        
        if(String.isNotBlank(ct)){    
            String[] fieldset = ct.split(',');               
            fld = fieldset[1];           
            String fieldValue = params.get(ct);
            String cQuery = 'SELECT Id, FirstName, LastName, Email FROM Contact WHERE '+fld + ' =: fieldValue LIMIT 1';
            System.debug(cQuery);
            c = Database.query(cQuery); //query inside a loop -> NOT GOOD
        }
        
        
        //create a list the exact size from params
        List<String> str = new List<String>();        
        for(j= 0; j<params.size(); j++){
            str.add('str'+j);                
        }
        System.debug(str);
        
        String fieldsList = 'Id, Name, FieloPLT__Email__c, FieloPLT__Status__c,FieloPLT__Program__c';
        for(String s: params.keySet()){
            if((s != 'Id') && !fieldsList.contains(s)){
                if(s.contains(',')){ // it checks if the parameter is compound (if it's an object related to Member)
                    String[] temp =  s.split(',');
                    if(temp[0].contains('__c') && temp[1].contains('__c')){
                        fieldsList += (', '+temp[0].substringBeforeLast('__c')+'__r.'+temp[1]);                         
                    }
                }else{
                    fieldsList += (', '+s);  
                }            
            } 
        }        
        System.debug(fieldsList);
        
        String query = 'SELECT '+ fieldsList +' FROM FieloPLT__Member__c WHERE ';
        
        //iterate over parameters map and use them to narrow the search
        for(String s: params.keySet()){
            System.debug(s);
            System.debug(params.get(s));
            // check if the id to be used in the query is not null
            if(params.get(s) != 'null' && params.get(s) != null){         
                if(s == 'FieloPLT__Member__c' || s == 'Id'){
                    str[i] = params.get(s);   
                    query += (i>0 ? ' AND ' : '')+' Id IN :str';
                    i++;
                }else if(s.contains(',')){
                    str[i] = params.get(s);
                    String[] temp =  s.split(',');
                    if(temp[0].contains('__c')){
                        String field = temp[0].substringBeforeLast('__c')+'__r.'+temp[1];
                        query += (i>0 ? ' AND ' : '')+ field +' IN :str';
                        i++;
                    }
                }else{
                    str[i] = params.get(s);
                    query += (i>0 ? ' AND ' : '')+ s +' IN :str';
                    i++;
                }
            }
        }       
        
        query += ' LIMIT 1';
        System.debug(query);
        //must be a list because it can be a multi-program situation
        
        FieloPLT__Member__c member =  new FieloPLT__Member__c();
        try{
            member = Database.query(query);
            program = member.FieloPLT__Program__c;            
            System.debug(member);  
        }catch(Exception ex){
            member = null; 
        }
        
        
        if(member == null){ 
            if(externalClass != null){
                Type t = Type.forName(externalClass);
                MemberCreation msInstance = (MemberCreation)t.newInstance();
                Map<String, String> createdMembers = msInstance.createMembers(new Set<Id>{c.Id});
                String createdMember = createdMembers.values()[0];
                return createdMember;
                
            }else{              
                return createMember(c.FirstName,c.LastName,c.Email,program,c.Id);                        
            }
        } else{
            if(member.FieloPLT__Status__c == 'Active'){ //replace member.get('FieloPLT__Status__c') with member.FieloPLT__Status__c
                return member.Id;
            }else{
                return null;
            }
        }
        
    }
    
    public static String createMember(String firstname,String lastname,String email, String program, String contact){
        FieloPLT__Member__c m = new FieloPLT__Member__c(
            Name = firstname + ' '+lastname,
            FieloPLT__Email__c = email,
            FieloPLT__Contact__c = contact,
            FieloPLT__Program__c = program
        );
        
        insert m;
        return m.Id;
        
    }
}