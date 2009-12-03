 class UserMailer < ActionMailer::Base
      def signup_notification(user)
       recipients "<#{user.email}>"
       from       "¿Chipaga? <danielesabetta@gmail.com>"
       subject    "[¿Chipaga?] Notifica: Attiva il tuo account"
       body       :user => user, :url => "#{SITE}/activate/#{user.activation_code}"
       sent_on    Time.now
      end

      def activation(user)
       recipients "<#{user.email}>"
       from       "¿Chipaga¿ <danielesabetta@gmail.com>"
       subject    "[¿Chipaga?] Notifica: Il tuo account è attivo!"
       body       :user => user, :url => "#{SITE}/"
       sent_on    Time.now
      end

      def forgot_password(user) 
        recipients "<#{user.email}>"
        from       "¿Chipaga? <danielesabetta@gmail.com>"
        subject    "[¿Chipaga?] Notifica: Hai richiesto il cambiamento della password"
        body       :user => user, :url => "#{SITE}/reset_password/#{user.password_reset_code}"
        sent_on    Time.now
      end

      def reset_password(user)
        recipients "<#{user.email}>"
        from       "¿Chipaga? <danielesabetta@gmail.com>"
        subject    "[¿Chipaga?] Notifica: Password resettata con successo."
        body       :user => user
        sent_on    Time.now
      end

end