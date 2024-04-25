@RestResource(urlMapping='/api/webhooks/firstApex/*')
global with sharing class firstApex {
    @HttpPost
    global static void firstApex() {
        try {
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
        } catch (Exception e) {
            System.debug('Exception Happend :'+ e.getMessage());
        }
    }
}