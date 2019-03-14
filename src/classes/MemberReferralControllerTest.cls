/*************************** - Fielo - *******************************
* Company: Fielo
* Developer: Bruna Dileo
* Created Date: 19/07/2018
* Description: 
**************************** - Fielo - ******************************/

@isTest
public class MemberReferralControllerTest {
    @testSetup static void InsertTestData() {
        List<FieloPLT__Program__c> program = MockUpFactory.createPrograms('Default', 1);
        insert program;        
        System.debug(program);
        
        List<User> users = MockUpFactory.createUsers(1);
        insert users;
        
        List<FieloPLT__Member__c> m = MockUpFactory.createMemberwithContact(program[0].id, 1);
        m[0].FieloPLT__User__c = users[0].Id;
        insert m; System.debug(m);
        
        Contact c = [SELECT Id FROM Contact WHERE Id =: m[0].FieloPLT__Contact__c];
        c.Member__c =  m[0].Id;
        update c; System.debug(m);
        
        List<ParametersSettings__c> psList = new  List<ParametersSettings__c>();
        ParametersSettings__c psOut = new ParametersSettings__c();
        psOut.Name = 'InboundLink';
        psOut.Parameter__c = 'contact';
        psOut.ObjectApiName__c = 'Contact';
        psOut.FieldApiName__c = 'Id';
        psOut.LookupRelationship__c = 'Member__c';
        psList.add(psOut);
        
        ParametersSettings__c psOut2 = new ParametersSettings__c();
        psOut2.Name = 'InboundLink2';
        psOut2.Parameter__c = 'member';
        psOut2.ObjectApiName__c = 'FieloPLT__Member__c';
        psOut2.FieldApiName__c = 'Id';
        psList.add(psOut2);
        
        ParametersSettings__c psOut3 = new ParametersSettings__c();
        psOut3.Name = 'InboundLink3';
        psOut3.Parameter__c = 'program';
        psOut3.ObjectApiName__c = 'FieloPLT__Member__c';
        psOut3.FieldApiName__c = 'FieloPLT__Program__c';
        psList.add(psOut3);
        
        /*ParametersSettings__c psOut4 = new ParametersSettings__c();
        psOut4.Name = 'InboundLink4';
        psOut4.Parameter__c = 'contact';
        psOut4.ObjectApiName__c = 'Contact';
        psOut4.FieldApiName__c = 'Id';
        psOut4.LookupRelationship__c = 'Member__c';
        psList.add(psOut4);*/
        
        insert psList;
    }
    
/*		TEST 1
        Tested method: queryMember
        Scenario: inbound url has memberId 
        Expected result: OK
*/
    
    @isTest
    static void queryMemberTest1(){
        FieloPLT__Member__c m = [SELECT Id FROM FieloPLT__Member__c LIMIT 1];
        Map<String,String> params = new Map<String,String>();
        String url = 'language=en&member='+m.Id;        
        String result = MemberReferralController.queryMember(url,'InboundLink2',null);
        
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('member', m.Id);
        System.assertEquals(result, JSON.serialize(resMap));
    }
    
/*		TEST 2
        Tested method: queryMember
        Scenario: Inbound url has contactId and the contact has a related member.
        Expected result: OK
*/
    
    @isTest
    static void queryMemberTest2(){
        
        FieloPLT__Member__c[] member = [SELECT Id,FieloPLT__Contact__c FROM FieloPLT__Member__c];
        Contact[] contacts = [SELECT LastName,Member__c FROM Contact WHERE Id =: member[0].FieloPLT__Contact__c];
        Contact[] contactsToUpdate = new Contact[]{};
            for(Contact c: contacts){
                c.Member__c = member[0].Id;
                contactsToUpdate.add(c);
            }
        update contactsToUpdate;
        
        String url = 'language=en&contact='+contactsToUpdate[0].Id;          System.debug(url);
        String result = MemberReferralController.queryMember(url,'InboundLink',null);
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('member', member[0].Id);
        System.assertEquals(result, JSON.serialize(resMap));
    }
    
/*		TEST 3
     	Tested method: queryMember
		Scenario: Get memberId through logged-in user
		Expected result: OK
*/
    @isTest
    static void queryMemberTest3(){
        User[] u = [SELECT Id FROM User WHERE Alias = 'alias'];
        String member;
        System.runAs(u[0]) {
            member = MemberReferralController.setMemberbyUser();
        }
        
        Map<String,String> params = new Map<String,String>();
        String url = 'language=en&member='+member;        
        String result = MemberReferralController.queryMember(url,'InboundLink2',null);        
        String expected = member;
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('member', member);
        System.assertEquals(result, JSON.serialize(resMap));
    }
    
/*		TEST 4
     	Tested method: queryMember
		Scenario: Inbound url has contactId and the contact didn't have a related member. Return error when try to create it
		Expected result: NOK
*/    
    
    @isTest
    static void queryMemberTest4(){        
        List<Contact> contacts = MockUpFactory.createContacts(1);
        
        FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];
        
        String url = 'language=en&contact='+contacts[0].Id;          System.debug(url);
        String result = MemberReferralController.queryMember(url,'InboundLink',null);
        
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('error','Attempt to de-reference a null object');
        System.assertEquals(result, JSON.serialize(resMap));
        
    }
    
/*		TEST 5
     	Tested method: queryMember
		Scenario: Inbound url has contactId and the contact didn't have a related member. Return created member
		Expected result: OK
*/     
    @isTest
    static void queryMemberTest5(){        
        List<Contact> contacts = MockUpFactory.createContacts(1); System.debug(contacts);
        insert contacts;
        
        FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];
        
        String url = 'language=en&contact='+contacts[0].Id;          System.debug(url);
        String result = MemberReferralController.queryMember(url,'InboundLink','TryMemberCreation');
        FieloPLT__Member__c member = [SELECT Id FROM FieloPLT__Member__c WHERE FieloPLT__Contact__c =: contacts[0].Id];
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('member', member.Id);
        System.assertEquals(result, JSON.serialize(resMap));
    }

/*		TEST 6
     	Tested method: queryMember
		Scenario: Inbound url has contactId and the contact didn't have a related member. Return error when try to create it
		Expected result: NOK
*/     
    @isTest
    static void queryMemberTest6(){        
        List<Contact> contacts = MockUpFactory.createContacts(1); 
        
        FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];
        
        String url = 'language=en&contact='+contacts[0].Id;          System.debug(url);
        String result = MemberReferralController.queryMember(url,'InboundLink','FieloELR,TryMemberCreation');
        
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('error','Attempt to de-reference a null object');
        System.assertEquals(result, JSON.serialize(resMap));
    }
    
}