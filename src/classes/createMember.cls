global class createMember implements RecordCreationInterface {
    public static Map<String,String> createObject(Map<String,Object> fieldset){ 
        Savepoint sp = null;
        FieloPLT__Member__c member = new FieloPLT__Member__c();
        Map<String,String> result = new Map<String,String>();
        
        try{
            sp = Database.setSavepoint();               
            fieldset.put('Name', fieldset.get('FirstName') + ' ' + fieldset.get('LastName'));
            fieldset.remove('FirstName');
            fieldset.remove('LastName');  
            for(String field : fieldset.keySet()){                    
                member.put(field, fieldset.get(field));
            }
            member.FieloPLT__Type__c = 'Individual Account';            
            insert member;  
            result.put('success', member.Id);
        }catch (DmlException e) {
            result.put('error',e.getDmlMessage(0));
            throw new AuraHandledException(e.getDmlMessage(0));           
        } catch (Exception e) {
            result.put('error',e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
}