/*************************** - Fielo - *******************************
* Company: Fielo
* Developer: Bruna Dileo
* Created Date: 17/08/2018
* Description: 
**************************** - Fielo - ******************************/

@isTest
public class InitialMemberRegistrationControllerTest {
    @TestSetup
    static void setup(){
        List<FieloPLT__Program__c> program = MockUpFactory.createPrograms('Default', 1);
        insert program;        
        System.debug(program);
        
        List<FieloPLT__Member__c> m = MockUpFactory.createMembers(program[0].id, 2);        
        insert m; System.debug(m);
        
    }
    
    @isTest
    static void getMemberTest(){
        List<FieloPLT__Member__c> expectedList = [SELECT Id, Name, FieloPLT__Status__c, FieloPLT__Program__r.Name 
                                                  FROM FieloPLT__Member__c 
                                                  WHERE FieloPLT__Email__c = 'email1l@example.com'];
        
        List<FieloPLT__Member__c> memberList = InitialMemberRegistrationController.getMember('email1l@example.com');
        
        System.assertEquals(expectedList,memberList);
    }
    
    @isTest
    static void getProgramTest(){
        List<FieloPLT__Program__c> expectedList = [SELECT Id, Name FROM FieloPLT__Program__c];
        
        List<FieloPLT__Program__c> programList = InitialMemberRegistrationController.getProgram();
        
        System.assertEquals(expectedList,programList);
    }
    
    @isTest
    static void createMemberTest1(){
        Map<String,String> dataMap = new Map<String,String>();
        dataMap.put('firstName', 'Bru');
        dataMap.put('lastName', 'test');
        dataMap.put('email', 'lalale@email.co');
        
        String expectedResult = InitialMemberRegistrationController.createMember(dataMap);
        
        List<FieloPLT__Member__c> actualList = [SELECT Id FROM FieloPLT__Member__c 
                                                WHERE FieloPLT__Email__c = 'lalale@email.co'];
        
        Map<String,String> resultMap = new Map<String,String>();
        resultMap.put('success',actualList[0].Id);
        
        System.assertEquals(expectedResult,JSON.serialize(resultMap));
        
    }
    
    @isTest
    static void createMemberTest2(){
        Map<String,String> dataMap = new Map<String,String>();
       
        String expectedResult = InitialMemberRegistrationController.createMember(dataMap);
        
        Map<String,String> resultMap = (Map<String,String>)JSON.deserialize(expectedResult,Map<String,String>.class);
        Set<String> resultSet = (Set<String>)JSON.deserialize(JSON.serialize(resultMap.keySet()), Set<String>.class);
        
       String result = (new List<String>(resultSet))[0];

        System.assertEquals(result,'error');
        
    }
}