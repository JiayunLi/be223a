package loginModule;

/**
 * Created by jiayunli on 15/10/25.
 */
public class User {
    // Id number
    private int id;
    // 用户名
    private String userName;
    // 密码
    private String password;
    // email
    private String email;
    // 是否激活
    private boolean activated;
    // 随机码(激活帐户与生成重设密码链接时使用)
    private String randomCode;
    private String randomPassCode;
    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public boolean isActivated() {
        return activated;
    }
    public void setActivated(boolean activated) {
        this.activated = activated;
    }
    public String getRandomCode() {
        return randomCode;
    }
    public void setRandomCode(String randomCode) {
        this.randomCode = randomCode;
    }
    public void setRandomPassCode(String randomPassCode){
        this.randomPassCode=randomPassCode;
    }
    public String getRandomPassCode(){
        return randomPassCode;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
}
