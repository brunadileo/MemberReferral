public without sharing class MemberRegistrationController {
    
    @AuraEnabled
    public static String getRefferedByMember(String url, String inboundSetup){
        //read the parameters that came in the url
        Map<String,String> resultMap = new Map<String,String>();
        
        String[] urlParams = url.split('&');
        Map<String,String> paramsMap = new Map<String,String>();
        for(String s : urlParams){
            String[] temp = s.split('=');
            paramsMap.put(temp[0], temp[1]); // paramsMap: {parameterName: relatedData};
        }
        System.debug(paramsMap);
        
        
        String[] inboundList = inboundSetup.split(',');
        List<String> fields = new List<String>();
        Map<String,String> inboundMap = new Map<String,String>();
        List<String> queryFields = new List<String>();
        List<String> qWhereFields = new List<String>();
        String objName;
        for(String i: inboundList){
            ParametersSettings__c ps = ParametersSettings__c.getInstance(i);	
            if(paramsMap.keySet().contains(ps.Parameter__c)){
                fields.add(ps.FieldApiName__c);
                queryFields.add(ps.FieldApiName__c);
                qWhereFields.add(ps.FieldApiName__c+ ' = \''+ paramsMap.get(ps.Parameter__c)+'\'');
                if(String.isBlank(objName) || objName == ps.FieloMRF__ObjectApiName__c) objName = ps.FieloMRF__ObjectApiName__c;
            }
        }
        System.debug(inboundMap);
        queryFields.add('FieloPLT__Program__r.Name');
        queryFields.add('Name');
        String queryFieldset = String.join(queryFields,',');
        String qWhereFieldset = String.join(qWhereFields,' AND ');
        
        String query = 'SELECT '+ queryFieldset +' FROM '+objName+ ' WHERE '+qWhereFieldset; System.debug(query);
        List<sObject> result = Database.query(query); System.debug(result);
        
        for(String s : queryFields){
            System.debug(s);
            if(s.contains('.')){
                String[] tempList = s.split('\\.'); System.debug(tempList);
                sObject obj = result[0].getSObject(tempList[0]); System.debug(obj);
                resultMap.put('programName',(String)obj.get(tempList[1])); System.debug(resultMap);
            }else{
                resultMap.put(s,(String)result[0].get(s));
            }
        }
        System.debug(resultMap);
        
        return JSON.serialize(resultMap);
    }
    
    @AuraEnabled
    public static Map<String,String> createRecords(String fieldsetStr, String objectsToCreateStr, String otherObjects, String namespace){
        Map<String,Boolean> objectsToCreate = (Map<String,Boolean>) JSON.deserialize(objectsToCreateStr, Map<String,Boolean>.class);
        Map<String,String> fieldset = (Map<String,String>) JSON.deserialize(fieldsetStr, Map<String,String>.class);
        List<String> objectsList = new List<String>();
        if(String.isNotBlank(otherObjects)){
            objectsList = otherObjects.split(',');
        }
        Map<String,String> result = new Map<String,String>();
        
        //check which standard objects are to be created (Contact, Lead, Member, Account) and add them to the list
        for(String obj : objectsToCreate.keySet()){
            if(objectsToCreate.get(obj)){
                objectsList.add(obj);
            }
        }
        
        for(String s: objectsList){
            Type t = Type.forName(namespace,'create'+s); System.debug('create'+s);
            RecordCreationInterface rci = (RecordCreationInterface)t.newInstance();
            rci.createObject(fieldset);
        }
        
        return result;
        
    }
    
    @AuraEnabled
    public static String getFbUser(String token) {
        return MemberRegistrationController.callFacebookParser(MemberRegistrationController.callFacebookApi(token));
    }    
    
    public static HttpResponse callFacebookApi(String token) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'https://graph.facebook.com/me?fields=id,first_name,last_name,email&access_token='+ token
        );
        
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }       
    
    public static String callFacebookParser(HttpResponse res){
        
        Map<String,String> result = new Map<String,String>();
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'first_name')) {
                parser.nextToken();
                result.put('firstName',parser.getText());	                  
            }else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'last_name')) {
                parser.nextToken();
                result.put('lastName',parser.getText());
            }else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'email')) {
                parser.nextToken();
                result.put('email',parser.getText());
            }
        }
        System.debug(JSON.serialize(result));
        return JSON.serialize(result);
        
    }
    
    @AuraEnabled
    public static String getGoogleUser(String token){
        
        HttpResponse res = MemberRegistrationController.callGoogleApi1(token);
        String access_token =  MemberRegistrationController.callGoogle1parser(res); System.debug(access_token);
        HttpResponse res2 = MemberRegistrationController.callGoogleApi2(access_token);
        
        return MemberRegistrationController.callGoogle2parser(res2);
        
    }
    
    @AuraEnabled 
    public static String getSocialMediaSetup(String csName){
        Map<String,String> resultMap = new Map<String,String>();
        List<String> csList = new List<String>();
        
        SocialMediaSettings__c sm = SocialMediaSettings__c.getInstance(csName);
        if(csName == 'facebook'){
            resultMap.put('appId',sm.FacebookAppId__c);
            resultMap.put('redirectUrl',sm.FbRedirectURL__c);
        }else if(csName == 'google'){
            resultMap.put('clientId',sm.GoogleClientId__c);
            resultMap.put('redirectUrl',sm.GoogleRedirectURL__c);
        }
        return JSON.serialize(resultMap);
        
    }
    
    public static HttpResponse callGoogleApi1(String token){
        SocialMediaSettings__c sm = SocialMediaSettings__c.getInstance('google');
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setBody('code='+token+'&'+
                    'client_id='+sm.FieloMRF__GoogleClientId__c+'&'+
                    'client_secret='+sm.FieloMRF__GoogleClientSecret__c+'&'+
                    'redirect_uri='+sm.FieloMRF__GoogleRedirectURL__c+'&'+
                    'grant_type=authorization_code'
                   );
        req.setMethod('POST');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug(res.getBody());
        return res;
    }
    
    public static HttpResponse callGoogleApi2(String access_token){
        HttpRequest req2 = new HttpRequest();
        req2.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req2.setEndpoint('https://www.googleapis.com/plus/v1/people/me?fields=emails,name&access_token='+access_token);
        
        req2.setMethod('GET');
        
        Http http2 = new Http();
        HttpResponse res2 = http2.send(req2);
        
        System.debug(res2.getBody());
        return res2;
        
    }
    
    public static String callGoogle1parser(HttpResponse res){
        String access_token;
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                parser.nextToken();
                access_token = parser.getText();	                  
            }
        }
        return access_token;
    }
    
    public static String callGoogle2parser(HttpResponse res2){
        Map<String,String> result = new Map<String,String>(); System.debug(result);
        JSONParser parser2 = JSON.createParser(res2.getBody());
        while (parser2.nextToken() != null) {
            if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && (parser2.getText() == 'emails')) {
            }
            if (parser2.getCurrentToken() == JSONToken.START_ARRAY) {
                parser2.nextToken();
            }
            if (parser2.getCurrentToken() == JSONToken.START_OBJECT) {
                parser2.nextToken();
            }
            if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && (parser2.getText() == 'value')){
                parser2.nextToken(); //email @
                result.put('email',parser2.getText()); System.debug(parser2.getText());
            }
            if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && (parser2.getText() == 'type')) {
                parser2.nextToken(); //account @
                result.put('type',parser2.getText()); System.debug(parser2.getText());
            }
            if (parser2.getCurrentToken() == JSONToken.END_OBJECT) {   
                parser2.nextToken();
            }
            if (parser2.getCurrentToken() == JSONToken.END_ARRAY) {
                parser2.nextToken();
            }
            if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && (parser2.getText() == 'name')) {
                parser2.nextToken();
            }       
            if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && (parser2.getText() == 'givenName')) {
                parser2.nextToken();
                result.put('firstName',parser2.getText()); System.debug(parser2.getText());
            }
            if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && (parser2.getText() == 'familyName')) {
                parser2.nextToken();
                result.put('lastName',parser2.getText()); System.debug(parser2.getText());
            }
        }
        System.debug(JSON.serialize(result));
        return JSON.serialize(result);        
    }
}