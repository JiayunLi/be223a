package loginModule;

import connection.Database;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;

/**
 * Created by jiayunli on 15/10/25.
 */
public class Registration {
    private Connection conn;
    private Database database;
    private final String activateSub="Activate your medical dashboard account";
    private final String activateMsg="Please click the following link to activate your medical dashboard account\n";
    public Registration(){
        database=new Database();
    }
    public User getUserInfo(String nameOrEmail) throws SQLException, ClassNotFoundException {
        boolean exist=false;
        User user=new User();
        conn=database.getConnected();
        Statement stmt=conn.createStatement();
        ResultSet rs=stmt.executeQuery("select * from user where UserName= "+"'"+nameOrEmail+"' "+"|| EmailAddress= "+"'"+nameOrEmail+"' ;");
        while(rs.next()){
            exist=true;
            user.setUserName(rs.getString("UserName"));
            user.setEmail(rs.getString("EmailAddress"));
            user.setPassword(rs.getString("Password"));
            user.setActivated(rs.getBoolean("Activated"));
            user.setRandomCode(rs.getString("RandomCode"));
            user.setRandomPassCode(rs.getString("RandomPassCode"));
        }
        if(exist){
            stmt.close();
            conn.close();
            return user;
        }else{
            return null;
        }

    }
    public boolean activate(User user) throws SQLException, ClassNotFoundException {
        conn=database.getConnected();
        Statement stmt=conn.createStatement();
        int i=stmt.executeUpdate("UPDATE user set Activated=1 where EmailAddress= "+"'"+user.getEmail()+"'");
        if(i>0){
            return true;
        }else{
            return false;
        }
    }
    public boolean userNameCheck(String userName) throws SQLException, ClassNotFoundException {
        conn=database.getConnected();
        Statement stmt=conn.createStatement();
        ResultSet rs=stmt.executeQuery("select * from user where UserName='"+userName+"'");
        if(rs.next()){
            stmt.close();
            conn.close();
            return false;
        }else{
            stmt.close();
            conn.close();
            return true;
        }
    }
    public boolean emailCheck(String email) throws SQLException, ClassNotFoundException {
        conn=database.getConnected();
        Statement stmt=conn.createStatement();
        ResultSet rs=stmt.executeQuery("select * from user where EmailAddress='"+email+"'");
        if(rs.next()){
            stmt.close();
            conn.close();
            return false;
        }else{
            stmt.close();
            conn.close();
            return true;
        }
    }

    public boolean register(String username,String email,String password) throws SQLException, ClassNotFoundException {
        conn=database.getConnected();
        Statement stmts=conn.createStatement();
        String randomUUID=UUID.randomUUID().toString();
        int i=stmts.executeUpdate("INSERT into user (UserName,EmailAddress,Password,Activated,RandomCode) VALUES (" + "'"
                + username + "'," + "'" + email + "'" + "," + "'" + password + "'"+","+0+","+"'"+randomUUID+"'"+")");
        conn.close();
        if(i>0){
            User user=new User();
            user.setActivated(false);
            user.setEmail(email);
            user.setUserName(username);
            user.setRandomCode(randomUUID);
            GenerateLinkUtils generateLinkUtils=new GenerateLinkUtils();
            SendEmail sendEmail=new SendEmail();
            sendEmail.sendEmail(email,activateSub,activateMsg+"\n"+generateLinkUtils.generateActivateLink(user,randomUUID)+"\n\n\n"+"Thank you\n"+"Medical Dashboard");
            return true;
        }
        return false;
    }
    public boolean sendActivateEmail(String email) throws SQLException, ClassNotFoundException {
        conn=database.getConnected();
        Statement stmts=conn.createStatement();
        String randomUUID=UUID.randomUUID().toString();
        User user=getUserInfo(email);
       // user.setActivated(false);
        user.setRandomCode(randomUUID);
       // user.setEmail(email);
        GenerateLinkUtils generateLinkUtils=new GenerateLinkUtils();
        SendEmail sendEmail=new SendEmail();
        int i=stmts.executeUpdate("UPDATE user set RandomCode="+"'"+randomUUID+"'"+" where EmailAddress= "+"'"+user.getEmail()+"'");
        if(sendEmail.sendEmail(email,activateSub,activateMsg+"\n"+generateLinkUtils.generateActivateLink(user,randomUUID)+"\n\n\n"+"Thank you\n"+"Medical Dashboard")){
            return true;
        }
        return false;

    }
    public boolean pwdUpdate(User user,String password) throws SQLException, ClassNotFoundException {
        conn=database.getConnected();
        Statement stmt=conn.createStatement();
        int i=stmt.executeUpdate("UPDATE user set Password="+"'"+password+"'"+" where UserName= "+"'"+user.getUserName()+"'");
        stmt.close();
        conn.close();
        if(i>0){
            return true;
        }else{
            return false;
        }
    }

}
