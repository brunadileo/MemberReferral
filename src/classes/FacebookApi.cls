global class FacebookApi {
    public static String accessFacebook(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'https://graph.facebook.com/v3.1/oauth/access_token?'+
            'client_id=2053196668268524'+ 
            '&redirect_uri=https://www.facebook.com/connect/login_success.html'+
            '&client_secret=d9a21317b150142f1beee4d09fd70382'+
            '&grant_type=client_credentials'
        );
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug(res);
		
        String acesstoken;
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    acesstoken = parser.getText();
                    system.debug(acesstoken);
                }
        }
        
        return acesstoken;
    }
    
}