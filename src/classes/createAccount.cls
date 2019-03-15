public class createAccount implements RecordCreationInterface {
    public static Map<String,String> createObject(Map<String,Object> fieldset){ 
        Account a = new Account();
        Savepoint sp = null;
        Map<String,String> result = new Map<String,String>();
        
        try{
            sp = Database.setSavepoint();               
            a.Name = (String)fieldset.get('FirstName') + ' ' + (String)fieldset.get('LastName');
            a.FieloMRF__ReferredBy__c = (String) fieldset.get('FieloMRF__ReferredBy__c'); 
            
            insert a;
            result.put('success', a.Id);
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