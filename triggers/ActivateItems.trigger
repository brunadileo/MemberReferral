trigger ActivateItems on FieloPLT__Program__c (after update) {
    Set<Id> activateProgramIds = new Set<Id>();
    
    for (FieloPLT__Program__c p : Trigger.new){
        if(p.ActivateItems__c == true && Trigger.oldMap.get(p.Id).ActivateItems__c != true) {
            activateProgramIds.add(p.Id);
        }
    }
    if (!activateProgramIds.isEmpty()) {
        ActivateItems.ChangeStatus(activateProgramIds);
    }
}