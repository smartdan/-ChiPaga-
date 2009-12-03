class Notifier < ActionMailer::Base

   def generic_email(email_params)
      recipients  "<#{email_params["user"].email}>"
      from         "¿ChiPaga? <danielesabetta.com>"
      subject      "Administration notification"  
      sent_on     Time.now 
      body        :user => email_params["user"], :text => email_params["text"], :url => "https://chipaga.heroku.com/session/new"
   end
    
    def comment_email(email_params)
      recipients  "<#{email_params["user"].email}>"
      from          "<#{email_params["from"]}>"  
      subject      "Administration notification"  
      sent_on     Time.now 
      body        :user => email_params["user"], :from => email_params["from"] , :text => email_params["text"], :url => "http://chipaga.heroku.com/session/new"
   end
   
    def pagamenti_email(email_params)
      recipients  "<#{email_params["user"].email}>"
      from        "<#{email_params["from"]}>"  
      subject     "Notifica di chiusura spese mensili"  
      sent_on     Time.now 
      body        :user => email_params["user"], :house => email_params["house"], :inquilini_spesa => email_params["inquilini_spesa"] , :spesa_tot => email_params["spesa_tot"] , :from => email_params["from"] , :text => email_params["text"], :url => "http://chipaga.heroku.com/houses/" + email_params["house"].id.to_s
   end
      
end
