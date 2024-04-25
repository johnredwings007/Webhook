@RestResource(urlMapping='/api/webhooks/createlead/*')
global with sharing class googleLeadsWebhook {
    @HttpPost
    global static void googleLeadsWebhook() {
         String jsonString = RestContext.request.requestBody.toString();
         Map<String, Object> leadData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
 
         // Extract lead data from the JSON payload
         String firstName = (String) leadData.get('first_name');
         String lastName = (String) leadData.get('last_name');
         String email = (String) leadData.get('email');
         String phone = (String) leadData.get('phone_number');
 
         // Create a new Lead record
         Lead newLead = new Lead();
         newLead.FirstName = firstName;
         newLead.LastName = lastName;
         newLead.Email = email;
         newLead.Phone = phone;
 
         // Insert the new Lead record
         try {
             insert newLead;
 
             // Send email notification
             sendEmailNotification(newLead.Id, firstName, lastName, email, phone);
         } catch (Exception e) {
             // Handle any errors
         }
    }

    global static void sendEmailNotification(Id leadId, String firstName, String lastName, String email, String phone) {
        // Construct email message
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setToAddresses(new List<String>{'johnpaul.john@aesconsulting.in'}); // Specify recipient email address
        emailMessage.setSubject('New Lead from Google Ads');
        String body = 'A new lead has been submitted via Google Ads:\n\n';
        body += 'First Name: ' + firstName + '\n';
        body += 'Last Name: ' + lastName + '\n';
        body += 'Email: ' + email + '\n';
        body += 'Phone: ' + phone + '\n';
        body += '\nView lead in Salesforce: https://your-salesforce-instance/' + leadId;
        emailMessage.setPlainTextBody(body);

        // Send email
        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailMessage});
        } catch (Exception e) {
            // Handle email sending errors
        }
    }
}