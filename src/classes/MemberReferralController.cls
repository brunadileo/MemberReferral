public class MemberReferralController {
    @AuraEnabled
    public static String getMember(){
        
        String user = UserInfo.getUserId();
        
        if(String.isNotBlank(user)){
            FieloPLT__Member__c[] members = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c 
                                             WHERE FieloPLT__User__c =:user];
            
            if(members.size() == 1){
                return members[0].Id;	                
            }else if(members.size() > 1){
                FieloPLT__Settings__c settings = FieloPLT__Settings__c.getInstance(UserInfo.getUserId());
                System.debug('member: '+ settings.CurrentMemberId__c);
                String res = (String)settings.CurrentMemberId__c;
                return res;
            }else{
                return null;
            }
        }else{
                return null;
            }
    }
    
    
    
    
    /*@AuraEnabled
public static String sendMail(List<String> emails, String subject, String message,String templateName) { 
Id templateId;
List<String> subjects = new List<String>();
subjects.add(subject); 
List<String> messages = new List<String>();
messages.add(message);
if(templateName != null){
templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: templateName].Id; System.debug('templateId:'+templateId);
}
EmailManager.sendMail(emails, subjects,messages,templateId);
return 'Email sent!';
}

@AuraEnabled
public static FieloPLT__Member__c getMember(){
FieloPLT__Settings__c settings = FieloPLT__Settings__c.getInstance(UserInfo.getUserId());
System.debug('member: '+ settings.CurrentMemberId__c);
if(settings.CurrentMemberId__c !=null){
FieloPLT__Member__c m = [SELECT Id, Name, FieloPLT__Program__c,FieloPLT__Program__r.Name FROM FieloPLT__Member__c 
WHERE Id =:settings.CurrentMemberId__c];

return m;
}else{
FieloPLT__Member__c m = [SELECT Id, Name, FieloPLT__Program__c FROM FieloPLT__Member__c 
WHERE Name = 'Test Member'];
return m;
}


}*/
    
    /*@AuraEnabled
public static String sgSendMail(List<String> emails,String emailTemplate, Map<String,String> p){
EmailTemplate et = [SELECT Id,Name,DeveloperName,Subject,Body,HTMLValue FROM EmailTemplate 
WHERE DeveloperName =: emailTemplate];
sendgrid2Mail sg = new sendgrid2Mail();
sendgrid2Mail.EmailData emaildata = new sendgrid2Mail.EmailData();

emaildata = sg.getEmailData(et,emails,null,p);
HttpResponse res = sendgrid2Mail.makeSendCallout(emaildata);
System.debug('res.getStatus(): '+res.getStatus());
return res.getStatus();        

}*/
    
    
    /*@AuraEnabled
public static String getShortLink2(String url){        
BitlyIntegration2 b = new BitlyIntegration2();
String shortUrl = b.shortenLink(url);
return shortUrl;

}

@AuraEnabled
public static String getParams(String fieldname,Integer quant, String emailSetup){
System.debug(quant);        
MemberReferral__c cs = MemberReferral__c.getInstance(fieldname);
Map<String,String> csMap = new Map<String,String>();
Integer i;
for(i = 1; i <= quant; i++){
System.debug(i);            
csMap.put(cs.get('Parameter'+i+'__c').toString(),cs.get('Field'+i+'__c').toString());
}
if(emailSetup != null){
MemberReferral__c cs2 = MemberReferral__c.getInstance(emailSetup);
csMap.put('subject',cs2.get('EmailSubject__c').toString());
csMap.put('body',cs2.get('EmailBody__c').toString());        
csMap.put('socialmedia',cs2.get('SocialMediaMessage__c').toString());
}
System.debug(csMap);
return JSON.serialize(csMap);        
}*/
    
    //TESTE    
    /* @isTest static void testSendEmail(){
List<String> emails = new List<String>();
emails.add('test@test.com');
String subject = 'Test subject';
String message = 'Test message';

String resp = modalController.sendMail(emails,subject,message);
System.assertEquals('Email sent!', resp);
}

@isTest static void testGetMember(){
Id p = [select id from profile where name='Fielo Partner Community User'].Id;

Account ac = new Account(name ='TestAcc') ;
insert ac; 

Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
insert con;  

User user = new User(alias = 'test123', email='test123@noemail.com',
emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
localesidkey='en_US', profileid = p, country='United States',IsActive =true,
ContactId = con.Id,
timezonesidkey='America/Los_Angeles', username='tester@noemail.com'+ System.currentTimeMillis());

insert user;

System.debug('user: '+ user);

System.runAs(user){

System.debug('Current User: ' + UserInfo.getUserId());

FieloPLT__Member__c m = modalController.getMember();
System.assert(m !=null);
}

}*/
    
}