public class createLead implements RecordCreationInterface{
	public static Map<String,String> createObject(Map<String,Object> fieldset){ 
        Lead l = new Lead();
        Savepoint sp = null;
        Map<String,String> result = new Map<String,String>();
        
        try{
            sp = Database.setSavepoint();               
            l.Email = (String)fieldset.get('FieloPLT__Email__c');
            l.FirstName = (String)fieldset.get('FirstName');
            l.LastName = (String)fieldset.get('LastName');
            l.FieloMRF__ReferredBy__c = (String)fieldset.get('FieloMRF__ReferredBy__c'); 
            l.Status='Open - Not Contacted';
            l.Company=(String)fieldset.get('FirstName') +' '+(String)fieldset.get('LastName');
            
            insert l;
            result.put('success', l.Id);
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