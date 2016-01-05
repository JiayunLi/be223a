package loginModule;

import connection.Database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Created by jiayunli on 15/10/26.
 */
public class PwdRetrieval {
    private Connection conn;
    private String randomPassCode;
    private final String resetObj="Password Retrieval";
    private final String resetMsg="Hi, please click on the following link to reset your password!";
    public boolean sendRetrievalMail(String email) throws SQLException, ClassNotFoundException {
        Registration registration=new Registration();
        User user=registration.getUserInfo(email);
        if(user==null)
            return false;
        GenerateLinkUtils generateLinkUtils=new GenerateLinkUtils();
        randomPassCode=generateLinkUtils.generateCheckcode(user);
        SendEmail sendEmail=new SendEmail();
        if(sendEmail.sendEmail(user.getEmail(),resetObj,resetMsg+"\n\n"+
                generateLinkUtils.generateResetPwdLink(user,randomPassCode)+"\n\n\n"+"Thank you\n"+"Medical dashboard")){
            Database database=new Database();
            conn=database.getConnected();
            Statement stmt=conn.createStatement();
            int i=stmt.executeUpdate("UPDATE user set RandomPassCode="+"'"+randomPassCode+"'"+"where UserName= "+"'"+user.getUserName()+"'");
            stmt.close();
            conn.close();
            if(i>0){
                return true;
            }else
                return false;
        }else {
            return false;
        }

    }

}
