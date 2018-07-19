@isTest
public class NewRegistrationControllerTest {
    @testSetup static void setup(){
        User u = new User(LastName = 'Test User', 
                          Email = 'bruna.dileo@fielo.com',
                          ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%Administrator' LIMIT 1].Id,
                          Username = 'bruna.dileo@fielo.com' + System.currentTimeMillis(),
                          CompanyName = 'TEST',
                          Title = 'title',
                          Alias = 'alias',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          EmailEncodingKey = 'UTF-8',
                          LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US');
        insert u;
        
        FieloPLT__Program__c p = new FieloPLT__Program__c(Name = 'Test Program');
        insert p;
        
        FieloPLT__Member__c m = new FieloPLT__Member__c(Name = 'Test Member', 
                                                        FieloPLT__Email__c = 'bruna.dileo@fielo.com',
                                                        FieloPLT__User__c = u.Id,
                                                        FieloPLT__Program__c = p.Id);
        insert m;
        
        FieloPLT__Settings__c s = new FieloPLT__Settings__c(CurrentMemberId__c = m.Id);
    }
    
    @isTest static void testGetNames(){
        
        FieloPLT__Program__c p = [SELECT Name FROM FieloPLT__Program__c];      
        FieloPLT__Member__c m = [SELECT Name FROM FieloPLT__Member__c];
        
        Map<String,String> lista = NewRegistrationController.getNames(p.Id, m.Id);
        System.debug('lista.size(): '+lista.size());
        System.assert(lista.size()>0);
        
    }
    
    @isTest static void testSelfRegister(){
		
			Map<String,String> fieldset = new Map<String, String>();
			fieldset.put('Name', 'Test Name');
			fieldset.put('LastName', 'Test Last Name');
			fieldset.put('FieloPLT__Email__c', 'test@test.com');
			
			String fields = JSON.serialize(fieldset);
			
			String registration = NewRegistrationController.selfRegister(fields);
        
    }
}