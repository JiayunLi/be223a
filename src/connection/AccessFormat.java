package connection;

import java.util.HashMap;

/**
 * Created by jiayunli on 15/11/10.
 */
public class AccessFormat {
    private String dbUserName;
    private String dbPassword;
    private String databaseName;
    private String tableName;
    private int documentsNum;
    public String getDbUserName(){
        return dbUserName;
    }
    public String getDatabaseName(){
        return databaseName;
    }
    public String getTableName(){
        return tableName;
    }
    public String getDbPassword() {
        return dbPassword;
    }
    public int getDocumentsNum(){
        return documentsNum;
    }
    public void setDbUserName(String dbUserName){
        this.dbUserName = dbUserName;
    }
    public void setDbPassword (String dbPassword){
        this.dbPassword = dbPassword;
    }

    public void setDatabaseName (String databaseName){
        this.databaseName = databaseName;
    }
    public void setDocumentsNum (int documentsNum){
        this.documentsNum = documentsNum;
    }
    public void setTableName (String tableName){
        this.tableName = tableName;
    }
}
