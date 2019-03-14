/*************************** - Fielo - *******************************
* Company: Fielo
* Developer: Bruna Dileo
* Created Date: 13/08/2018
* Description: 
**************************** - Fielo - ******************************/

global without sharing class InitialMemberRegistrationController {
    
    @AuraEnabled
    public static FieloPLT__Member__c[] getMember(String email){
        List<FieloPLT__Member__c> memberList = [SELECT Id, Name, FieloPLT__Status__c, FieloPLT__Program__r.Name FROM FieloPLT__Member__c WHERE FieloPLT__Email__c =: email];
        
        return memberList;
    }
    
    @AuraEnabled
    public static FieloPLT__Program__c[] getProgram(){
        List<FieloPLT__Program__c> programList = [SELECT Id, Name FROM FieloPLT__Program__c];
        System.debug(programList);
        return programList;
    }
    
    @AuraEnabled
    public static String createMember(Map<String,String> dataMap){
        System.debug(dataMap);
        Map<String,String> resultMap = new Map<String,String>();
        FieloPLT__Member__c m = new FieloPLT__Member__c(Name= dataMap.get('firstName') + ' ' + dataMap.get('lastName'),
                                                        FieloPLT__Email__c = dataMap.get('email'),
                                                        FieloPLT__Status__c = 'Active',
                                                        FieloPLT__Type__c = 'Individual Account',
                                                        FieloPLT__Program__c = dataMap.get('program'));        
        try{
            insert m;
            resultMap.put('success',m.Id);
            return JSON.serialize(resultMap);
        }catch(Exception e){
            resultMap.put('error',e.getMessage());
            return JSON.serialize(resultMap);
        }
    }
    
    
    
    
}