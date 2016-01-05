package connection;

/**
 * Created by jiayunli on 15/10/25.
 */

import com.google.gson.Gson;
import gate.GateAccess;
import gate.GateLocation;
import org.apache.pdfbox.io.IOUtils;
import utils.db.DBConnection;

import java.io.*;
import java.net.URL;
import java.sql.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;

import loginModule.User;

import javax.swing.plaf.nimbus.State;

public class Database {
    private Connection conn;
    //private String duser="root";
    //  private String dpassword="";
    private String host="localhost";
    private String dbType="mysql";
    private String dbRegPassword="be223";
    private String dbRegUser="root";
    private String dbRegName="register";
    private String regTable = "user";
    private String accessTable = "accessRecords";
    private String accessDetails;
    private String gateTable = "gatePipeline";
    //  private String dbName="register";
    public Connection getConnected() throws SQLException, ClassNotFoundException {
        conn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        return conn;
    }
    private LinkedList<AccessFormat> loadAccessList (String user) throws SQLException, ClassNotFoundException {
        LinkedList<AccessFormat> accessList = new LinkedList<AccessFormat>();
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt = regConn.createStatement();
        ResultSet rs = stmt.executeQuery("select * from " + accessTable + " JOIN " + regTable + " ON "
                + accessTable + ".id = " + regTable + ".id" + " WHERE UserName= " + "'" + user + "'");
        while(rs.next()){
            Gson gson = new Gson();
            String features = rs.getString("DatabaseFeature");
            AccessFormat accessFormat = gson.fromJson(features, AccessFormat.class);
            accessList.add(accessFormat);
        }
        return accessList;
    }
    private File gappFile (String pipelineName,String userName,int threadId) throws SQLException, ClassNotFoundException, IOException {
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt = regConn.createStatement();
        Statement stmt1 = regConn.createStatement();
        ResultSet rs1 = stmt1.executeQuery("select Id from " + regTable + " where UserName = " + "'" + userName + "'");
        URL tempurl = getClass().getResource("/gappFile/");
        File file = new File(tempurl.getPath() + threadId +"temp.txt");
        // gappFile = new File(url.getPath());
       // File file = new File(url.getPath());
        int id =0;
        if(rs1.next()){
            id = rs1.getInt("Id");
        }
        ResultSet rs = stmt.executeQuery("Select * from " + gateTable + " where PipelineName = " + "'" +pipelineName + "'" +" and Id = " + id);
        if(rs.next()){
            InputStream inputStream = rs.getBinaryStream("Pipeline");
            OutputStream outputStream = new FileOutputStream(file);
            byte[] buffer = new byte[2048];
            while (inputStream.read(buffer) > 0) {
                outputStream.write(buffer);
            }
            outputStream.close();
            inputStream.close();
           // IOUtils.copy(inputStream, outputStream);
           // outputStream.close();
        }
        return file;
    }
    public File getGappFile(String pipelineName, String userName, int threadId) throws SQLException, IOException, ClassNotFoundException {
        return gappFile(pipelineName,userName, threadId);
    }
    private LinkedList<GateAccess> PipelineList(String userName) throws SQLException, ClassNotFoundException {
        LinkedList<GateAccess> accesses = new LinkedList<GateAccess>();
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt = regConn.createStatement();
        ResultSet rs = stmt.executeQuery("select * from " + gateTable + " JOIN " + regTable + " ON "
                + gateTable + ".id = " + regTable + ".id" + " WHERE UserName= " + "'" + userName + "'");
        while(rs.next()){
            GateAccess gateAccess = new GateAccess();
            gateAccess.setPipelineName(rs.getString("PipelineName"));
            gateAccess.setPipelineDescription(rs.getString("Description"));
            accesses.add(gateAccess);
        }
        return accesses;
    }
    public LinkedList<GateAccess> getPipelineList(String userName) throws SQLException, ClassNotFoundException {
        return PipelineList(userName);
    }
    private GateLocation GateLocations(String userName) throws SQLException, ClassNotFoundException {
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt = regConn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * from " + regTable + " " + "WHERE UserName = " + "'" + userName + "'");
        String gatePlugins = null;
        String gateSite = null;
        String gateHome = null;
        GateLocation gateLocation = new GateLocation();
        if(rs.next()){
            gatePlugins = rs.getString("GatePlugins");
            gateSite = rs.getString("GateSite");
            gateHome = rs.getString("GateHome");
            gateLocation.setGatePlugins(gatePlugins);
            gateLocation.setGateSite(gateSite);
            gateLocation.setGateHome(gateHome);
        }
        stmt.close();
        regConn.close();
        return gateLocation;
    }
    public GateLocation getGateLocation (String userName) throws SQLException, ClassNotFoundException {
        return GateLocations(userName);
    }
    private boolean GateLocation (String userName,GateLocation gateLocation) throws SQLException, ClassNotFoundException {
        String gatePlugins = gateLocation.getGatePlugins();
        String gateSite = gateLocation.getGateSite();
        String gateHome = gateLocation.getGateHome();
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt = regConn.createStatement();
      //  int i=stmt.executeUpdate("UPDATE user set RandomPassCode="+"'"+randomPassCode+"'"+"where UserName= "+"'"+user.getUserName()+"'")
        int rs = stmt.executeUpdate("UPDATE " + regTable + " set GatePlugins =" + "'" + gatePlugins + "' ," + "GateSite =" + "'" + gateSite + "' ,"
        + "GateHome = " + "'" + gateHome + "'" + "WHERE userName = " + "'" + userName + "'");
        stmt.close();
        regConn.close();
        if(rs>0)
            return true;
        else
            return false;
    }
    public boolean updateGateLocation (String userName, GateLocation gateLocation) throws SQLException, ClassNotFoundException {
        return GateLocation(userName,gateLocation);
    }
    public LinkedList<AccessFormat> getAccessDatabaseList (String user) throws SQLException, ClassNotFoundException {
        return loadAccessList(user);
    }
    public String importGate(String userName, String pipelineName, String description,InputStream inputStream) throws SQLException, ClassNotFoundException {
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
       // Statement stmt = regConn.createStatement();
        Statement stmt = regConn.createStatement();
        int id = 0;
        ResultSet rs = stmt.executeQuery("SELECT Id from " + regTable + " " + "where UserName = " + "'" + userName + "'");
        String msg = null;
        if(rs.next()){
            id = rs.getInt("Id");
            stmt = regConn.createStatement();
            ResultSet rs1 = stmt.executeQuery("select * from " + gateTable + " "+"where Id = " + id + " And PipelineName = " + "'" + pipelineName + "'");
            if(rs1.next()){
                msg = "You have already imported this pipline";
                stmt.close();
                regConn.close();
                return msg;}
        }
        PreparedStatement statement = regConn.prepareStatement("insert  into " + gateTable + " "+"(Id, PipelineName, Description, Pipeline) values (?,?,?,?)");
        statement.setInt(1, id);
        statement.setString(2,pipelineName);
        statement.setString(3, description);
        if (inputStream != null) {
            // fetches input stream of the upload file for the blob column
            statement.setBlob(4, inputStream);
        }
        int row = statement.executeUpdate();
        if (row > 0) {
            msg = "File uploaded and saved into database";
        }
        return msg;
    }
    public boolean updateAccessDocDB(String user,String databaseName, String tableName) throws SQLException, ClassNotFoundException {
        int id = 0;
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt = regConn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = stmt.executeQuery("select Id from " + regTable + " " + "where UserName = " + "'" + user + "'");
        boolean success = false;
        if(rs.next()){
            id = rs.getInt("Id");
            //ResultSet rs1 = stmt.executeQuery("select * from " + accessTable + " "+"where Id = " + id);
            ResultSet rs1 = stmt.executeQuery("select * from " + accessTable + " "+"where Id = " + id);

            while(rs1.next()){
                String features = rs1.getString("DatabaseFeature");
                Gson gson = new Gson();
                AccessFormat accessFormat = gson.fromJson(features,AccessFormat.class);
                String currentDatabaseName = accessFormat.getDatabaseName();
                String  currentTableName = accessFormat.getTableName();
                if(currentDatabaseName.equals(databaseName)&&currentTableName.equals(tableName)){
                   // stmt.execute("DELETE from " + accessTable + "where Id ")
                   // stmt.executeUpdate("UPDATE " + accessTable + " SET DatabaeFeature" + )
                   rs1.deleteRow();
                    success = true;
                }
            }
        }
        return success;
    }
    public boolean updateGateAccess(String userName, String pipeline) throws SQLException, ClassNotFoundException {
        boolean success = false;
        int id = 0;
        Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt = regConn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = stmt.executeQuery("select Id from " + regTable + " " + "where UserName = " + "'" + userName + "'");
        if(rs.next()){
            id = rs.getInt("Id");
            //ResultSet rs1 = stmt.executeQuery("select * from " + accessTable + " "+"where Id = " + id);
            ResultSet rs1 = stmt.executeQuery("select * from " + gateTable + " "+"where Id = " + id);

            while(rs1.next()){
                String currentPipeline = rs1.getString("PipelineName");
                if(currentPipeline.equals(pipeline)){
                    // stmt.execute("DELETE from " + accessTable + "where Id ")
                    // stmt.executeUpdate("UPDATE " + accessTable + " SET DatabaeFeature" + )
                    rs1.deleteRow();
                    success = true;
                }
            }
        }
        return success;
    }
    public String importDatabase(String user,String dbuserName,String password,String databaseName,String tableName) throws  ClassNotFoundException {
        int id=0;
        String msg;
        try {
            Connection regConn = DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
            Statement stmt = regConn.createStatement();
            ResultSet rs = stmt.executeQuery("select Id from " + regTable + " " + "where UserName = " + "'" + user + "'");
            if(rs.next()){
                id = rs.getInt("Id");
                stmt = regConn.createStatement();
                ResultSet rs1 = stmt.executeQuery("select * from " + accessTable + " "+"where Id = " + id);
                while(rs1.next()){
                    String features = rs1.getString("DatabaseFeature");
                    Gson gson = new Gson();
                    AccessFormat accessFormat = gson.fromJson(features,AccessFormat.class);
                    String currentDatabaseName = accessFormat.getDatabaseName();
                    String  currentTableName = accessFormat.getTableName();
                    if(currentDatabaseName.equals(databaseName)){
                        if(currentTableName.equals(tableName)){
                            stmt.close();
                            regConn.close();
                            msg = "You have already import this database";
                            return msg;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            conn = DBConnection.dbConnection(dbuserName, password, host, databaseName, dbType);
            Statement stmt=conn.createStatement();
            ResultSet rs=stmt.executeQuery("select * from " + tableName);

            if(rs.next()){
                int i = 0;
                rs = stmt.executeQuery("select COUNT(*) from "+ tableName);
                if(rs.next()){
                    i = rs.getInt(1);
                }
                AccessFormat accessFormat=new AccessFormat();
                accessFormat.setDbPassword(password);
                accessFormat.setDbUserName(dbuserName);
                accessFormat.setDatabaseName(databaseName);
                accessFormat.setTableName(tableName);
                accessFormat.setDocumentsNum(i);
                Gson gson = new Gson();
                String json = gson.toJson(accessFormat);
                accessDetails = json;
                addDatabaseAccess(id,json, user, dbRegUser, dbRegPassword,dbRegName);
                stmt.close();
                conn.close();
                return null;
            }else{
                stmt.close();
                conn.close();
                msg = "Table not exist in the database " + databaseName;
                return msg;
            }
        } catch (SQLException e) {
            msg = "Database " + databaseName + " not exist!";
            return msg;
            // e.printStackTrace();
        }
    }

    public String getAcessDetails(){
        return accessDetails;
    }
    public void addDatabaseAccess(int id,String json,String userName,String dbRegUser,String dbRegPassword,String dbRegName) throws SQLException, ClassNotFoundException {

        conn=DBConnection.dbConnection(dbRegUser, dbRegPassword, host, dbRegName, dbType);
        Statement stmt=conn.createStatement();

        stmt.executeUpdate("insert  into " + accessTable + " "+"(Id, DatabaseFeature) values (" + id + ", '" + json + "'" + ")");
        stmt.close();
        conn.close();
    }
}