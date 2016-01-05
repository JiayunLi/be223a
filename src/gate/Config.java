package gate;

/**
 * Created by jiayunli on 15/11/11.
 */
public class Config {

    private String docDBName;
    private String docDBPassword;
    private String docNameSpace;
    private String docTable;
    public void setDocDBName(String docDBName){
        this.docDBName = docDBName;
    }
    public void setDocDBPassword(String docDBPassword){
        this.docDBPassword = docDBPassword;
    }
    public void setDocNameSpace(String docNameSpace){
        this.docNameSpace = docNameSpace;
    }
    public void setDocTable(String docTable){
        this.docTable = docTable;
    }
    public String getDocDBName(){
        return docDBName;
    }
    public String getDocDBPassword(){
        return docDBPassword;
    }
    public String getDocNameSpace(){
        return docNameSpace;
    }
    public String getDocTable(){
        return docTable;
    }
}
