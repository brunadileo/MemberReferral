public class MockUpFactory {
    public static List<FieloPLT__Program__c> createPrograms(String basename, Integer count) {
        List<FieloPLT__Program__c> results = new List<FieloPLT__Program__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Program__c p = new FieloPLT__Program__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__OnlineTransactionProcessing__c = true;
            results.add(p);
        }
        return results;
    }
    
    public static List<FieloPLT__Member__c> createMembers(String programId, Integer count){
        List<FieloPLT__Member__c> membersToCreate = new List<FieloPLT__Member__c>();
        for(Integer x = 0; x < count; x++){
            membersToCreate.add(new FieloPLT__Member__c(
                Name='Member '+String.valueOf(x),
                FieloPLT__Email__c='email'+String.valueOf(x)+'l@example.com',
                FieloPLT__Type__c='Individual Account',
                FieloPLT__Program__c=programId
            )
                               );
        }
        return membersToCreate;
    }
    
    public static List<Contact> createContacts(Integer count){
        List<Contact> contactsToCreate = new List<Contact>();
        for(Integer x = 0; x < count; x++){
            contactsToCreate.add(new Contact(
                FirstName='NoMember',
                LastName='Contact '+String.valueOf(x),
                Email='email'+String.valueOf(x)+'l@example.com'               
            )
                                );
        }
        return contactsToCreate;
    }
    
    public static List<User> createUsers(Integer count){
        List<User> users = new List<User>();
        for(Integer j = 0; j < count; j++){
            users.add(new User(LastName = 'Test User'+String.valueOf(j), 
                               Email = 'bruna.test'+String.valueOf(j)+'@example.com',
                               ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%Administrator' LIMIT 1].Id,
                               Username = 'bruna.test'+String.valueOf(j)+'@example.com' + System.currentTimeMillis(),
                               CompanyName = 'TEST',
                               Title = 'title',
                               Alias = 'alias',
                               TimeZoneSidKey = 'America/Los_Angeles',
                               EmailEncodingKey = 'UTF-8',
                               LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US'));
        }
        return users;
    }
}