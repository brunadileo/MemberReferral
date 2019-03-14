global interface MemberCreation{
    //please use this signature
    // Response has the following structure:
    // success ----> [Id][MemberId]
    // Error ----> [Id][messageError]
    Map<String, String> createMembers(Set<Id> recordsIds, Id programId);
    
}