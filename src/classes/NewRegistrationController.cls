global class NewRegistrationController {
    public NewRegistrationController() {
        
    }
    @AuraEnabled
    public static Map<String,String> getLabels(){
        Map<String,String> labelList = new Map<String,String>();
        String[] labels = new String[]{'firstname','lastname','email','mobilephone'};
            Map<String, Schema.SobjectField> fields = Contact.sObjectType.getDescribe().fields.getMap();
        
        for (String s : labels) {           
            String label = fields.get(s).getDescribe().getLabel();
            labelList.put(s,label);            
        }
        
        Map<String, Schema.SobjectField> fields3 = FieloPLT__Member__c.sObjectType.getDescribe().fields.getMap();
        String label2 = fields3.get('fieloplt__program__c').getDescribe().getLabel();
        labelList.put('pLabel',label2);
        String label3 = fields3.get('referralmember__c').getDescribe().getLabel();
        labelList.put('mLabel',label3);
        System.debug(labelList);
        
        return labelList;
    }
    
    @AuraEnabled
    public static Map<String,String> getNames(Id memberId){
        Map<String,String> lista = new Map<String,String>();
        
        FieloPLT__Member__c  m = [SELECT Name,FieloPLT__Program__c, FieloPLT__Program__r.Name FROM FieloPLT__Member__c WHERE Id =:memberId];
        lista.put('pId',m.FieloPLT__Program__c);
        lista.put('pName',m.FieloPLT__Program__r.Name);        
        lista.put('member',m.Name);        
        System.debug(lista);
               
        return lista;
    }
    
    @AuraEnabled
    public static String selfRegister(String fields, Boolean createUser, Boolean createLead,Boolean createMember, Boolean createContact) {
        Savepoint sp = null;
        Map<String,Object> fieldset = (Map<String, Object>) JSON.deserializeUntyped(fields);          
        String firstname = (String) fieldset.get('Name');         
        String lastname = (String) fieldset.get('LastName');
        String email = (String) fieldset.get('FieloPLT__Email__c'); 
        String accountId = (String) fieldset.get('FieloPLT__Account__c'); 
        String referralId = (String) fieldset.get('ReferralMember__c'); 
        fieldset.remove('LastName');
        
        User u = new User();
        Id userId; 
        Lead l;
        Contact c;
        FieloPLT__Member__c member = new FieloPLT__Member__c(); 
        
        if(createUser){
            try{
                sp = Database.setSavepoint();                
                u.Username = email;
                u.put('Email',email);           
                u.FirstName = firstname;
                u.LastName = lastname;            
                String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
                nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
                u.put('CommunityNickname', nickname);                                               
                // lastName is a required field on user, but if it isn't specified, we'll default it to the username
                userId = Site.createExternalUser(u, accountId, null);
            } catch (DmlException e) {
                throw new AuraHandledException(e.getDmlMessage(0));
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        if(createLead){
            try{
                sp = Database.setSavepoint();
                l = new Lead(LastName= lastname, 
                             Email=email,
                             FirstName= firstname,
                             Status='Open - Not Contacted',
                             Company='Fielo');
                insert l;
                
            }catch (DmlException e) {
                throw new AuraHandledException(e.getDmlMessage(0));
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }        
        if(createMember){
            try{
                sp = Database.setSavepoint();               
                fieldset.put('Name', firstname + ' ' + lastname);            
                fieldset.put('FieloPLT__User__c', userId);
                for(String field : fieldset.keySet()){                    
                    member.put(field, fieldset.get(field));
                }
                member.FieloPLT__Type__c = 'Individual Account';            
                insert member;                 
            }catch (DmlException e) {
                throw new AuraHandledException(e.getDmlMessage(0));
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }        
        if(createContact && (createMember == false)){
            try{
                
            }catch (DmlException e) {
                throw new AuraHandledException(e.getDmlMessage(0));
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        
        FieloPLT__Event__c e1 = new FieloPLT__Event__c(FieloPLT__Member__c= referralId,
                                                       FieloPLT__Type__c = 'Referral');
        
        FieloPLT__Event__c e2 = new FieloPLT__Event__c(FieloPLT__Member__c= member.Id,
                                                       FieloPLT__Type__c = 'Registration');
        
        List<FieloPLT__Event__c> e = new List<FieloPLT__Event__c>();
        e.add(e1);
        e.add(e2);
        insert e;
        
        return null;
    }
    
    @AuraEnabled
    public static String getExtraFields(String extraFields1, String extraFields2, String extraFields3){
        String[] objList = new String[]{};                 
                String[] fieldList = new String[]{};
                    Map<String, String> typeList = new Map<String, String>();
        
        if(!String.isBlank(extraFields1)){
            String[] efList1 = extraFields1.split(','); //System.debug(efList1);
            objList.add(efList1[0].trim());
            fieldList.add(efList1[1].trim().toLowerCase());
            typeList.put(efList1[1].trim(),efList1[2].trim());
        }
        if(!String.isBlank(extraFields2)){
            String[] efList2 = extraFields2.split(','); //System.debug(efList2);
            objList.add(efList2[0].trim());
            fieldList.add(efList2[1].trim().toLowerCase());
            typeList.put(efList2[1].trim(),efList2[2].trim());            
        }
        if(!String.isBlank(extraFields3)){
            String[] efList3 = extraFields3.split(','); //System.debug(efList3);
            objList.add(efList3[0].trim());
            fieldList.add(efList3[1].trim().toLowerCase());
            typeList.put(efList3[1].trim(),efList3[2].trim());      
        }
        System.debug(objList);
        System.debug(fieldList);
        
        /* String[] objs = new String[]{'Lead','Contact','FieloPLT__Member__c'};
                for(String s: objList){
                    if(objs.contains(s)){
                        objList2.add(s);
                    }
                }*/
        List<Map<String,String>> fieldDesc = new List<Map<String,String>>(); 
        //Map<String,Map<String,String>> fieldDesc = new Map<String,Map<String,String>>(); 
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        //iterate over object list
        for(String t: objList){
            System.debug(t);
            //get the fields from the object
            Schema.SObjectType sobj = gd.get(t);
            Map<String, Schema.SobjectField> fields = sobj.getDescribe().fields.getMap();
            //System.debug(fields);
            //iterate over the field map from the object
            for (String s : fields.keySet()) {
                //check if the field is in the initial list
                if(fieldList.contains(s)){
                    System.debug(s);
                    //create a temporary map
                    Map<String,String> temp = new Map<String,String>();
                    temp.put('object',t);
                    
                    //get the api name from the field
                    String name = fields.get(s).getDescribe().getName();
                    temp.put('name',name);
                    temp.put('type',typeList.get(name));
                    //get the label from the field
                    String label = fields.get(s).getDescribe().getLabel();
                    temp.put('label',label);
                    //add the infos to the final map
                    fieldDesc.add(temp);                    
                }
            }   
        }
        System.debug(fieldDesc);
        //convert the map to json
        String json = JSON.serialize(fieldDesc);
        System.debug(json);
        return json;
        
    }
    
}