public class BitlyIntegration implements LinkShortener{
    
    public String shortenLink(String url){
        //FieloPLT__PublicSettings__c	p = FieloPLT__PublicSettings__c.getInstance();
        String apikey = '98ad872f0bcb486037aab03f808749a5c1e64e24'; //p.BitlyAPIKey__c;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'https://api-ssl.bitly.com/v3/shorten?'+
            'access_token='+ apikey + 
            '&longUrl=' + EncodingUtil.urlEncode(url, 'UTF-8')
        );
        req.setHeader('Accept','application/json');
        req.setMethod('POST');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        String shorturl;
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'url')) {
                    parser.nextToken();
                    shorturl = parser.getText();
                    system.debug(shorturl);
                }
        }
        return shorturl;
        
    }
}