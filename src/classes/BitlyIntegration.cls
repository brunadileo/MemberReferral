public class BitlyIntegration implements LinkShortener2{
    
    public String shortenLink(String url, String apiKey){
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'https://api-ssl.bitly.com/v3/shorten?'+
            'access_token='+ apiKey + 
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