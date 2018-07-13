@isTest
public class modalControllerTest {
    @testSetup static void InsertTestData() {
        List<FieloPLT__Program__c> p = MockUpFactory.createPrograms('Default', 1);
        insert p;        
        
        List<FieloPLT__Member__c> m = MockUpFactory.createMembers(p[0].id, 1);
        m.addAll(MockUpFactory.createMembers(p[0].id, 1));
        insert m;
        
        MemberReferral__c csOut = new MemberReferral__c();
        csOut.Name = 'OutboundLink';
        csOut.Parameter1__c = 'contact';
        csOut.Field1__c = 'FieloPLT__Contact__c';
        insert csOut;
        
        MemberReferral__c csOut2 = new MemberReferral__c();
        csOut2.Name = 'OutboundLink2';
        csOut2.Parameter1__c = 'contact';
        csOut2.Field1__c = 'FieloPLT__Contact__c,Name';
        insert csOut2;
    }

    @isTest 
    static void getParamsSendLinkTest(){
        FieloPLT__Member__c[] member = [SELECT Id FROM FieloPLT__Member__c];
        System.debug(member[0]);
        String resultado = modalController.getParamsSendLink('OutboundLink', 1, member[0].Id);       
        FieloPLT__Member__c[] res = [SELECT FieloPLT__Contact__c FROM FieloPLT__Member__c];
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('contact', res[0].FieloPLT__Contact__c);
        String resMap2 = JSON.serialize(resMap);
        System.assertEquals(resultado, resMap2);
    }
    
    @isTest 
    static void getParamsSendLinkTest2(){
        FieloPLT__Member__c[] member = [SELECT Id FROM FieloPLT__Member__c];
        System.debug(member[0]);
        String resultado = modalController.getParamsSendLink('OutboundLink2', 1, member[0].Id);       
        FieloPLT__Member__c[] res = [SELECT FieloPLT__Contact__r.Name FROM FieloPLT__Member__c];
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('contact', res[0].FieloPLT__Contact__r.Name);
        String resMap2 = JSON.serialize(resMap);
        System.assertEquals(resultado, resMap2);
    }
    
}