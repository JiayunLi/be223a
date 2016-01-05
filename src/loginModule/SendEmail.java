package loginModule;

/**
 * Created by jiayunli on 15/10/25.
 */

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;

public class SendEmail {
    private String host = "smtp.gmail.com";
    private String port = "587";
    private String userName="medicaldashboardmii@gmail.com";
    private String password="Mail%Beginnering#";
    private void mailer(String toAddress, String subject, String message) throws MessagingException {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", port);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        // creates a new session with an authenticator
        Authenticator auth = new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(userName, password);
            }
        };
        Session session = Session.getInstance(properties, auth);
        // creates a new e-mail message
        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(userName));
        InternetAddress[] toAddresses = { new InternetAddress(toAddress) };
        msg.setRecipients(Message.RecipientType.TO, toAddresses);
        msg.setSubject(subject);
        msg.setSentDate(new Date());
        // set plain text message
        msg.setText(message);
        // sends the e-mail
        Transport.send(msg);
    }
    public boolean sendEmail(String toAddress,
                             String subject, String message){
        try {
            mailer(toAddress,subject,message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }

    }
}
