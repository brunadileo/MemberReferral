@isTest
public class modalControllerTest {
    @testSetup static void InsertTestData() {
        List<FieloPLT__Program__c> p = MockUpFactory.createPrograms('Default', 1);
        insert p;        
        
        List<FieloPLT__Member__c> m = MockUpFactory.createMemberwithContact(p[0].id, 1);
        insert m; System.debug(m);
                
        List<ParametersSettings__c> psList = new  List<ParametersSettings__c>();
        ParametersSettings__c psOut = new ParametersSettings__c();
            psOut.Name = 'OutboundLink';
            psOut.Parameter__c = 'name';
            psOut.ObjectApiName__c = 'Contact';
            psOut.FieldApiName__c = 'LastName';
            psOut.LookupRelationship__c = 'Fielo_MemberId__c';
            psList.add(psOut);
        
        ParametersSettings__c psOut2 = new ParametersSettings__c();
            psOut2.Name = 'OutboundLink2';
            psOut2.Parameter__c = 'member';
            psOut2.ObjectApiName__c = 'FieloPLT__Member__c';
            psOut2.FieldApiName__c = 'Id';
            psList.add(psOut2);
        
        ParametersSettings__c psOut3 = new ParametersSettings__c();
            psOut3.Name = 'OutboundLink3';
            psOut3.Parameter__c = 'program';
            psOut3.ObjectApiName__c = 'FieloPLT__Member__c';
            psOut3.FieldApiName__c = 'FieloPLT__Program__c';
            psList.add(psOut3);
        
        insert psList;
    }

    @isTest 
    static void getParamsTest1(){
        //get the memberId to pass a parameter to the method
        FieloPLT__Member__c[] member = [SELECT Id FROM FieloPLT__Member__c]; System.debug(member[0]);
        
        //call method
        String result = modalController.getParams('OutboundLink2', member[0].Id);
        
        Map<String,String> resMap = new Map<String,String>();
		resMap.put('member',member[0].Id);
        System.assertEquals(result, JSON.serialize(resMap));
    }
    
    @isTest 
    static void getParamsTest2(){
        //get the memberId to pass a parameter to the method
        FieloPLT__Member__c[] member = [SELECT Id, FieloPLT__Contact__c FROM FieloPLT__Member__c]; System.debug(member[0]);
        Contact[] contacts = [SELECT LastName, Fielo_MemberId__c FROM Contact WHERE Id =: member[0].FieloPLT__Contact__c];
        Contact[] contactsToUpdate = new Contact[]{};
        for(Contact c: contacts){
            c.Fielo_MemberId__c = member[0].Id; 
            contactsToUpdate.add(c);
        }
        update contactsToUpdate;
        //call method
        String result = modalController.getParams('OutboundLink', member[0].Id);
        
        
        Contact[] res = [SELECT LastName FROM Contact WHERE Id =: member[0].FieloPLT__Contact__c]; System.debug(res);
        Map<String,String> resMap = new Map<String,String>();
        resMap.put('name', res[0].LastName);
        //String resMap2 = JSON.serialize(resMap);
        System.assertEquals(result, JSON.serialize(resMap));
    }
    
    @isTest 
    static void getParamsTest3(){
        //get the memberId to pass a parameter to the method
        FieloPLT__Member__c[] member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c]; System.debug(member[0]);
        
        //call method
        String result = modalController.getParams('OutboundLink3', member[0].Id);
        
        Map<String,String> resMap = new Map<String,String>();
		resMap.put('program',member[0].FieloPLT__Program__c);
        System.assertEquals(result, JSON.serialize(resMap));
    }
    
}