package loginModule;

/**
 * Created by jiayunli on 15/10/26.
 */
import javax.servlet.ServletRequest;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class GenerateLinkUtils {
    private static final String CHECK_CODE = "checkCode";
    public static String generateActivateLink(User user,String randomCode) {
        return "http://localhost:8080/medicalFramework_war_exploded/accountActivate.jsp?userName="
                + user.getUserName() + "&" + CHECK_CODE + "=" +randomCode;
    }

    /**
     * 生成重设密码的链接
     */
    public static String generateResetPwdLink(User user,String randomCode) {
        return "http://localhost:8080/medicalFramework_war_exploded/pwdResetAuthen.jsp?userName="
                + user.getUserName() + "&" + CHECK_CODE + "=" + randomCode;
    }

    /**
     * 生成验证帐户的MD5校验码
     * @param user  要激活的帐户
     * @return 将用户名和密码组合后，通过md5加密后的16进制格式的字符串
     */
    public static String generateCheckcode(User user) {
        String userName = user.getUserName();
        String randomCode = user.getRandomCode();
        return md5(userName + ":" + randomCode);
    }


    public static boolean verifyCheckcode(User user,ServletRequest request) {
        String checkCode = request.getParameter(CHECK_CODE);
        return generateCheckcode(user).equals(checkCode);
    }

    private static String md5(String string) {
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("md5");
            md.update(string.getBytes());
            byte[] md5Bytes = md.digest();
            return bytes2Hex(md5Bytes);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return null;
    }

    private static String bytes2Hex(byte[] byteArray)
    {
        StringBuffer strBuf = new StringBuffer();
        for (int i = 0; i < byteArray.length; i++)
        {
            if(byteArray[i] >= 0 && byteArray[i] < 16)
            {
                strBuf.append("0");
            }
            strBuf.append(Integer.toHexString(byteArray[i] & 0xFF));
        }
        return strBuf.toString();
    }
}
