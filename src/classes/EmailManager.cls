public with sharing class EmailManager{
    
    public static void sendMail(String [] addresses, String [] subjects, String [] messages, String templateId) {
        Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
            Integer totalMails = addresses.size();
        System.debug('addresses.size():' +addresses.size());
        for(Integer i=0; i < totalMails; i++){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(subjects[0]);
            email.setToAddresses(new List<String> { addresses[i] });
            if(templateId != null){
                email.setTemplateId(templateId);
            }
            email.setPlainTextBody(messages[0]);
            emails.add(email);
        }
        Messaging.sendEmail(emails);
    }
}