public class createContact implements RecordCreationInterface {
    public static Map<String,String> createObject(Map<String,Object> fieldset){ 
        Contact c = new Contact();
        Savepoint sp = null;
        Map<String,String> result = new Map<String,String>();
        
        try{
            sp = Database.setSavepoint();               
            c.Email = (String)fieldset.get('FieloPLT__Email__c');
            c.FirstName = (String)fieldset.get('FirstName');
            c.LastName = (String)fieldset.get('LastName');
            c.FieloMRF__ReferredBy__c = (String) fieldset.get('FieloMRF__ReferralBy__c'); 
            insert c;
            
            result.put('success', c.Id);
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