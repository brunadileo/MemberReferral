public class TryMemberCreation implements MemberCreation {
    
    public static Map<String, String> createMembers(Set<Id> cSet, Id programId){
        System.debug('programId:' +programId);
        System.debug('Set<Id> cSet:' +cSet);
        
        if(programId == null){
            FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];
            programId = p.Id;
        }
        
        Contact[] cList = [SELECT Id, FirstName, LastName, Email, FieloMRF__Member__c FROM Contact WHERE Id IN :cSet];
        List<FieloPLT__Member__c> members = new List<FieloPLT__Member__c>();
        
        for(Integer i=0; i< cList.size();i++){
            members.add(new FieloPLT__Member__c(Name= cList[i].Firstname + ' ' +cList[i].LastName,
                                                FieloPLT__Email__c = cList[i].Email,
                                                FieloPLT__Contact__c = cList[i].Id,
                                                FieloPLT__Program__c = programId));
            
        }
        insert members;
        
        Contact[] contacts = new Contact[]{};
            for(Integer i=0; i< cList.size();i++){
                if(cList[i].Id == members[i].FieloPLT__Contact__c){
                    cList[i].Member__c = members[0].Id;
                    contacts.add(cList[i]);
                }
            }
        update contacts;
        
        Map<String, String> resMap = new Map<String, String>();
        for(FieloPLT__Member__c m :members){
            resMap.put(m.FieloPLT__Contact__c,m.Id);
        }
        
        return resMap;
    }
    
}