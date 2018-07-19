trigger activeMember on Lead (before insert) {
    FieloPLT__Settings__c settings = FieloPLT__Settings__c.getInstance(UserInfo.getUserId());
    
    String memberId =  settings.CurrentMemberId__c;
    System.debug('memberId: '+ memberId);
    
    if(memberId != null){ 
        for (Lead l : Trigger.New){
            l.Member__c	= memberId;
            System.debug('chegou aqui');
        }        
    }    
}