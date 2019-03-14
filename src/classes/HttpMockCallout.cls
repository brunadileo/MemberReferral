global class HttpMockCallout implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        //Facebook
        String fbUrl = 'https://graph.facebook.com/me?fields=id,first_name,last_name,email&access_token=';
        String token = 'EAAdLXxoQ7ZBwBAIo6HXvwooiMvA1KEpWu1z86Cobi33bAAw0IF6eLW7jmalTVCtkEJZCBt1oDmBIvbGggAeN4dvAYZC6kzvKtj5GuwNXuSEnqDXZBzShSVYUeP4onyTE3mhLioX3C7ZBg2ghuRF977SRX9jZBjb2RNHtf2znQvZBbsZAojZB2JvRPFWwgqSq8ZBcy9CELpq9GJOgZDZD';

        //Google1
        String google1Url = 'https://accounts.google.com/o/oauth2/token';
        
        //Google2       
        
        if(req.getEndpoint() == (fbUrl+token)){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"email":"brunagdileo@gmail.com","lastName":"Diléo","firstName":"Bruna"}');
            res.setStatusCode(200);
            return res;
        } else if(req.getEndpoint() == google1Url){
            HttpResponse res = new HttpResponse();
            res.setBody('{"access_token": "ya29.GmBkBlfRHHq1x4GOWlSkAdusN41tFmRV-4qg7WlDfdKbO_Q0mzvgfbVjXHkZUge3a8Ay7KHtroDhq1jNGhV1JnPeWyZr6nFAUZPuQDMk3E4I3bkZzyXyEqbdyavHWWoXW28"}');
            res.setStatusCode(200);
            return res;
        } else{
            HttpResponse res = new HttpResponse();
            res.setBody('{"emails": [{"value": "brunagdileo@gmail.com","type": "account"}],"name": {"familyName": "Diléo","givenName": "Bruna"}}');
            res.setStatusCode(200);
            return res;
            
        }            
        
        
        // Create a fake response
        /*HttpResponse res = new HttpResponse();
res.setHeader('Content-Type', 'application/json');
res.setBody('{"email":"brunagdileo@gmail.com","lastName":"Diléo","firstName":"Bruna"}');
res.setStatusCode(200);
return res;*/
    }
    
}