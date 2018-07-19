@isTest
public class PublicMemberReferralControllerTest {
    
    @testSetup static void InsertTestData() {
        List<FieloPLT__Program__c> program = MockUpFactory.createPrograms('Default', 1);
        insert program;        
        System.debug(program);

        List<FieloPLT__Member__c> members = MockUpFactory.createMembers(program[0].id, 1);
        insert members;
        System.debug(members);
        
        List<Contact> contacts = MockUpFactory.createContacts(1);
        insert contacts;
        System.debug(contacts);
        
        //Please insert all MemberReferral record in a list, don't use individual insert
        List<MemberReferral__c> mrList = new List<MemberReferral__c>();
        MemberReferral__c csIn = new MemberReferral__c();
        csIn.Name = 'InboundLink';
        csIn.Parameter1__c = 'member';
        csIn.Parameter2__c = 'contact';
        csIn.Field1__c = 'Id';
        csIn.Field2__c = 'FieloPLT__Contact__c,FirstName';
        mrList.add(csIn);
        
        MemberReferral__c csIn2 = new MemberReferral__c();
        csIn2.Name = 'InboundLink2';
        csIn2.Parameter1__c = 'member';
        csIn2.Parameter2__c = 'contact';
        csIn2.Parameter3__c = 'prog';
        csIn2.Field1__c = 'Id';
        csIn2.Field2__c = 'FieloPLT__Contact__c,FirstName';
        csIn2.Field3__c = 'FieloPLT__Program__c';
        mrList.add(csIn2);
        
        MemberReferral__c csIn3 = new MemberReferral__c();
        csIn3.Name = 'InboundLink3';
        csIn3.Parameter1__c = 'contact';
        csIn3.Parameter2__c = 'prog';
        csIn3.Field1__c = 'FieloPLT__Contact__c,FirstName';
        csIn3.Field2__c = 'FieloPLT__Program__c';
        mrList.add(csIn3);
        
        MemberReferral__c csOut = new MemberReferral__c();
        csOut.Name = 'OutboundLink';
        csOut.Parameter2__c = 'contact';
        csOut.Field2__c = 'FieloPLT__Contact__c,FirstName';
        mrList.add(csOut);
        
        insert mrList;
        
    }
    
    @isTest
    static void getParamsTest(){        
        String result = PublicMemberReferralController.getParams('InboundLink', 2);
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('member','Id');        
        resMap.put('contact','FieloPLT__Contact__c,FirstName');
        resMap.put('subject',Label.EmailSubject);
        resMap.put('body',Label.EmailBody);
        resMap.put('socialmedia',Label.SocialMediaMessage);
        
        String expected = JSON.serialize(resMap);
        System.assertEquals(expected, result);
    }


    
    @isTest
    static void queryMemberTest1(){
        FieloPLT__Member__c m = [SELECT Id, FieloPLT__Contact__r.FirstName FROM FieloPLT__Member__c LIMIT 1];
        System.debug(m.Id);
        System.debug(m.FieloPLT__Contact__r.FirstName);
        Map<String,String> params = new Map<String,String>();
        params.put('Id',m.Id);
        params.put('FieloPLT__Contact__c,FirstName',m.FieloPLT__Contact__r.FirstName);       
        String result = PublicMemberReferralController.queryMember(params, null);
        String expected = m.Id;
        System.assertEquals(expected, result);
    }
    
    @isTest
    static void queryMemberTest2(){
        
        FieloPLT__Member__c m = [SELECT Id, FieloPLT__Contact__r.FirstName,FieloPLT__Program__c FROM FieloPLT__Member__c LIMIT 1];
        Map<String,String> params = new Map<String,String>();
        params.put('Id',m.Id);
        params.put('FieloPLT__Contact__c,FirstName',m.FieloPLT__Contact__r.FirstName);  
        params.put('FieloPLT__Program__c',m.FieloPLT__Program__c);       
        String result = PublicMemberReferralController.queryMember(params, null);
        String expected = m.Id;
        System.assertEquals(expected, result);
    }
    
    @isTest
    static void queryMemberTest3(){        
        FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];
        Contact c = [SELECT Id, FirstName FROM Contact WHERE FirstName = 'NoMember'];
        System.debug(c);
        Map<String,String> params = new Map<String,String>();        
        params.put('FieloPLT__Contact__c,FirstName',c.FirstName);  
        params.put('FieloPLT__Program__c',p.Id);       
        String result = PublicMemberReferralController.queryMember(params, null);
        System.debug(result);
        FieloPLT__Member__c m = [SELECT Id, FieloPLT__Contact__r.FirstName,FieloPLT__Program__c FROM FieloPLT__Member__c
                                 WHERE Id =: result LIMIT 1];
        String expected = m.Id;
        System.assertEquals(expected, result);
    }
    
    @isTest
    static void queryMemberTest4(){
        
        FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];
        Contact c = [SELECT Id, FirstName FROM Contact WHERE FirstName = 'NoMember'];
        Map<String,String> params = new Map<String,String>();        
        params.put('FieloPLT__Contact__c,FirstName',c.FirstName);  
        params.put('FieloPLT__Program__c',p.Id);       
        String result = PublicMemberReferralController.queryMember(params, 'MemberCreationTest');
        FieloPLT__Member__c m = [SELECT Id, FieloPLT__Contact__r.FirstName,FieloPLT__Program__c FROM FieloPLT__Member__c
                                 WHERE Id =: result];
        String expected = m.Id;
        System.assertEquals(expected, result);
    }
    
}