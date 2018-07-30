@isTest
public class PublicMemberReferralControllerTest {
    
    @testSetup static void InsertTestData() {
        List<FieloPLT__Program__c> program = MockUpFactory.createPrograms('Default', 1);
        insert program;        
        System.debug(program);

        List<FieloPLT__Member__c> m = MockUpFactory.createMemberwithContact(program[0].id, 1);
        insert m; System.debug(m);
        
        List<ParametersSettings__c> psList = new  List<ParametersSettings__c>();
        ParametersSettings__c psOut = new ParametersSettings__c();
            psOut.Name = 'InboundLink';
            psOut.Parameter__c = 'spiceid';
            psOut.ObjectApiName__c = 'Contact';
            psOut.FieldApiName__c = 'SpiceID__c';
            psOut.LookupRelationship__c = 'Fielo_MemberId__c';
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
        
        insert psList;
    }
    
      
    @isTest
    static void queryMemberTest1(){
        FieloPLT__Member__c m = [SELECT Id FROM FieloPLT__Member__c LIMIT 1];
        System.debug(m.Id);
        Map<String,String> params = new Map<String,String>();
		String url = 'language=en&member='+m.Id;        
        String result = PublicMemberReferralController.queryMember(url,'InboundLink2',null);
        String expected = m.Id;
        System.assertEquals(expected, result);
    }
    
    @isTest
    static void queryMemberTest2(){
        
        FieloPLT__Member__c[] member = [SELECT Id,FieloPLT__Contact__c FROM FieloPLT__Member__c];
        Contact[] contacts = [SELECT LastName,SpiceID__c,Fielo_MemberId__c FROM Contact WHERE Id =: member[0].FieloPLT__Contact__c];
        Contact[] contactsToUpdate = new Contact[]{};
        for(Contact c: contacts){
            c.Fielo_MemberId__c = member[0].Id;
            c.SpiceID__c = '123abc'+c.LastName;
            contactsToUpdate.add(c);
        }
        update contactsToUpdate;
        
        String url = 'language=en&spiceid='+contactsToUpdate[0].SpiceID__c;          System.debug(url);
        String result = PublicMemberReferralController.queryMember(url,'InboundLink',null);
        String expected = member[0].Id;
        System.assertEquals(expected, result);
    }
    
    @isTest
    static void queryMemberTest3(){        
        List<Contact> contacts = MockUpFactory.createContacts(1);
        for(Contact c: contacts){
            c.SpiceID__c = '123abc'+c.FirstName;
        }
        insert contacts;
        System.debug(contacts);
		
        FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];

        String url = 'language=en&spiceid='+contacts[0].SpiceID__c;          System.debug(url);
        String result = PublicMemberReferralController.queryMember(url,'InboundLink','TryMemberCreation');
        
        FieloPLT__Member__c m = [SELECT Id FROM FieloPLT__Member__c WHERE FieloPLT__Contact__r.SpiceID__c ='123abcNoMember' ]; 
        String expected = m.Id;
        System.assertEquals(expected, result);
    }
    
   
}