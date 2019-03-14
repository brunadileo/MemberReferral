@isTest(SeeAllData=true)
public class MemberRegistrationControllerTest {
    /*@testSetup static void InsertTestData() {
        List<FieloPLT__Program__c> program = MockUpFactory.createPrograms('Default', 1);
        insert program;        
        System.debug(program);
        
        List<User> users = MockUpFactory.createUsers(1);
        insert users;
        
        List<FieloPLT__Member__c> m = MockUpFactory.createMemberwithContact(program[0].id, 1);
        m[0].FieloPLT__User__c = users[0].Id;
        insert m; System.debug(m);
        
        List<ParametersSettings__c> psList = new  List<ParametersSettings__c>();
        
        ParametersSettings__c psOut2 = new ParametersSettings__c();
        psOut2.Name = 'InboundLink';
        psOut2.Parameter__c = 'member';
        psOut2.ObjectApiName__c = 'FieloPLT__Member__c';
        psOut2.FieldApiName__c = 'Id';
        psList.add(psOut2);
        
        ParametersSettings__c psOut3 = new ParametersSettings__c();
        psOut3.Name = 'InboundLink2';
        psOut3.Parameter__c = 'program';
        psOut3.ObjectApiName__c = 'FieloPLT__Member__c';
        psOut3.FieldApiName__c = 'FieloPLT__Program__c';
        psList.add(psOut3);
        
        SocialMediaSettings__c sm1 = new SocialMediaSettings__c();
        sm1.Name = 'facebook';
        sm1.FacebookAppId__c = '2053196668268524';
        sm1.FbRedirectURL__c = 'https://demo-fielomrf-developer-edition.na53.force.com/s/fblogin';  
        
        insert psList;
        insert sm1;
    }*/
    
    @isTest 
    static void getRefferedByMemberTest1(){
        FieloPLT__Member__c m = [SELECT Id,FieloPLT__Program__c FROM FieloPLT__Member__c][0];
        String url = 'member='+m.Id+'&program='+m.FieloPLT__Program__c;
        String inboundSetup = 'parameter2,parameter3';
        
        String result = MemberRegistrationController.getRefferedByMember(url, inboundSetup);
        
        System.debug(result);
        Map<String,String> resultMap = (Map<String,String>)JSON.deserialize(result, Map<String,String>.class);
        System.assertEquals('Loyalty Program', resultMap.get('programName'));
        
    }
    
    @isTest 
    static void createRecordsTest1(){
        FieloPLT__Program__c p = [SELECT Id FROM FieloPLT__Program__c][0];
        String fieldsetStr = '{"FirstName":"ll3l","LastName":"njfnjk","FieloPLT__Email__c":"epoffymmuqa-7459@yopmail.com","FieloPLT__Program__c":"'+p.Id+'"}';
        String objectsToCreateStr =  '{"Account":false,"Lead":false,"Contact":false,"Member":true}';
        Map<String,String> resultMap =  MemberRegistrationController.createRecords(fieldsetStr, objectsToCreateStr,null,null);
        
        System.assertEquals(null, resultMap.get('success'));
        
    }
    
    @isTest 
    static void getSocialMediaSetupTest1(){
        
        String result = MemberRegistrationController.getSocialMediaSetup('facebook');
        
        Map<String,String> resultMap = (Map<String,String>)JSON.deserialize(result, Map<String,String>.class);
        
        System.assertEquals('2053196668268524', resultMap.get('appId'));
        
    }
    
    @isTest
    static void callFacebookApiTest(){
        Test.StartTest();
        System.debug('callFacebookApiTest');
        Test.setMock(HttpCalloutMock.class, new HttpMockCallout());
        
        String token = 'EAAdLXxoQ7ZBwBAIo6HXvwooiMvA1KEpWu1z86Cobi33bAAw0IF6eLW7jmalTVCtkEJZCBt1oDmBIvbGggAeN4dvAYZC6kzvKtj5GuwNXuSEnqDXZBzShSVYUeP4onyTE3mhLioX3C7ZBg2ghuRF977SRX9jZBjb2RNHtf2znQvZBbsZAojZB2JvRPFWwgqSq8ZBcy9CELpq9GJOgZDZD';
        HttpResponse res = MemberRegistrationController.callFacebookApi(token);
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"email":"brunagdileo@gmail.com","lastName":"Diléo","firstName":"Bruna"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        Test.StopTest();

    }
    
   @isTest
    static void callFacebookParserTest(){
        System.debug('parseJsonResTest');
        Test.setMock(HttpCalloutMock.class, new HttpMockCallout());
        HttpResponse res = new HttpResponse();
        res.setBody('{"email":"brunagdileo@gmail.com"}');
        
        String result = MemberRegistrationController.callFacebookParser(res);
        System.debug(result);
        System.assertEquals('{"email":"brunagdileo@gmail.com"}', result);
    }
    
    @isTest
    static void callGoogleApi1Test(){
        Test.StartTest();
		  System.debug('callFacebookApi1Test');
        Test.setMock(HttpCalloutMock.class, new HttpMockCallout());
        
        String token = '4/pQBfBMZC0SEyI6TolNMr-De6Y3G6WCn1U5657x2003LfZKKb_HaFCQC1lsbdt5KBU1viL5ydE_UbbIVHRrkCyf4';
        HttpResponse res = MemberRegistrationController.callGoogleApi1(token);
        
        System.assertEquals(200, res.getStatusCode());      
        Test.StopTest();
    }

	@isTest
    static void callGoogleApi2Test(){
        Test.StartTest();
		System.debug('callFacebookApi2Test');
        Test.setMock(HttpCalloutMock.class, new HttpMockCallout());
        
        String code = 'ya29.GmBkBlfRHHq1x4GOWlSkAdusN41tFmRV-4qg7WlDfdKbO_Q0mzvgfbVjXHkZUge3a8Ay7KHtroDhq1jNGhV1JnPeWyZr6nFAUZPuQDMk3E4I3bkZzyXyEqbdyavHWWoXW28';
        HttpResponse res = MemberRegistrationController.callGoogleApi2(code);
        
        System.assertEquals(200, res.getStatusCode());      
        Test.StopTest();
    }

    @isTest
    static void callGoogle1parserTest(){
		System.debug('callGoogle1parserTest');
        Test.setMock(HttpCalloutMock.class, new HttpMockCallout());
        HttpResponse res = new HttpResponse();
            res.setBody('{"access_token": "ya29.GmBkBlfRHHq1x4GOWlSkAdusN41tFmRV-4qg7WlDfdKbO_Q0mzvgfbVjXHkZUge3a8Ay7KHtroDhq1jNGhV1JnPeWyZr6nFAUZPuQDMk3E4I3bkZzyXyEqbdyavHWWoXW28"}');
        String code = 'ya29.GmBkBlfRHHq1x4GOWlSkAdusN41tFmRV-4qg7WlDfdKbO_Q0mzvgfbVjXHkZUge3a8Ay7KHtroDhq1jNGhV1JnPeWyZr6nFAUZPuQDMk3E4I3bkZzyXyEqbdyavHWWoXW28';
        String result = MemberRegistrationController.callGoogle1parser(res);
        System.assertEquals('ya29.GmBkBlfRHHq1x4GOWlSkAdusN41tFmRV-4qg7WlDfdKbO_Q0mzvgfbVjXHkZUge3a8Ay7KHtroDhq1jNGhV1JnPeWyZr6nFAUZPuQDMk3E4I3bkZzyXyEqbdyavHWWoXW28', code);
        
    }
    
    @isTest
    static void callGoogle2parserTest(){
		System.debug('callGoogle2parserTest');
        Test.setMock(HttpCalloutMock.class, new HttpMockCallout());
        HttpResponse res = new HttpResponse();
            res.setBody('{"emails": [{"value": "brunagdileo@gmail.com","type": "account"}],"name": {"familyName": "Diléo","givenName": "Bruna"}}');
        
        String result = MemberRegistrationController.callGoogle2parser(res);
        System.assertEquals('{"firstName":"Bruna","lastName":"Diléo","type":"account","email":"brunagdileo@gmail.com"}',result);
        
    }
}