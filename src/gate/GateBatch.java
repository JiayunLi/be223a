package gate;
import gate.*;
import gate.creole.annic.apache.lucene.store.InputStream;
import gate.util.*;
import gate.util.persistence.PersistenceManager;
import gate.corpora.DocumentImpl;

import java.net.URL;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.HashSet;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.BufferedOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

import utils.db.DBConnection;

import com.datastax.driver.core.*;
import com.google.gson.Gson;

import javax.print.DocFlavor;


public class GateBatch
{

    private Connection conn;
    private Connection docConn;

    private Session session;
    private Cluster cluster;
    private Session docSession;
    private Cluster docCluster;

    private int batchSize;

    private Map<String, Boolean> annotationTypeMap;
    private boolean allFlag;
    private String dbType = "mysql";
    private String docDBType = "mysql";
    private String rq = "`";

    private PreparedStatement pstmt;
    private BoundStatement bstmt;

    private Gson gson;
    private List<File> fileList;
    private ResultSet rs;
    private com.datastax.driver.core.ResultSet cassRS;
    private File docFile;
    private boolean hasText;
    private int currDoc;
    private int docID;
    private boolean write;
    private String docNamespace;
    private String docTable;
    private String provenance;

    private int firstFile = 0;
    private int documentNum = 0;

    private File gappFile = null;
    private List annotTypesToWrite = null;
    private String encoding = null;
    private String user;
    private String password;
    private String docUser;
    private String docPassword;
    private String config;
    private String docHost;
    private String docDBName;
    private String docNumQuery;
    private Properties props;
    //static private final String tempDocFolder = "/Users/frankmeng/Documents/Research/annotation/test-docs/";

    public void setConfig (String user, String password, String docUser, String docPassword, String config) throws IOException {
        this.user = user;
        this.password = password;
        this.docUser = docUser;
        this.docPassword = docPassword;
        this.config = config;

        this.props = new Properties();
        props.load(getClass().getResourceAsStream(config));
        this.docDBType = props.getProperty("docDBType");
        this.docHost = props.getProperty("docHost");
        this.docDBName = props.getProperty("docDBName");
        this.docNumQuery = props.getProperty("docNumQuery");
    }
    /**
     * The main entry point.  First we parse the command line options (see
     * usage() method for details), then we take all remaining command line
     * parameters to be file names to process.  Each file is loaded, processed
     * using the application and the results written to the output file
     * (inputFile.out.xml).
     */

    public void process()
    {
        try {
            annotationTypeMap = new HashMap<String, Boolean>();
            gson = new Gson();
            String tempDocFolder = props.getProperty("tempDocFolder");

            String annotationTypesStr = props.getProperty("annotationTypes");
            if (annotationTypesStr != null) {
                String[] annotationTypes = annotationTypesStr.split(",");

                for (int i=0; i<annotationTypes.length; i++) {
                    annotationTypeMap.put(annotationTypes[i].trim(), true);

                    if (annotationTypes[i].toLowerCase().equals("all"))
                        allFlag = true;
                }
            }

            dbType = props.getProperty("dbType");
            String host = props.getProperty("host");
            String dbName = props.getProperty("dbName");




            //String cassandraHost = props.getProperty("cassandraHost");
            //String cassandraKeyspace = props.getProperty("cassandraKeyspace");

            String annotInputTable = props.getProperty("annotationInputTable");
            String annotOutputTable = props.getProperty("annotationOutputTable");
            String metaMapTablePrefix = props.getProperty("metaMapTablePrefix");
            docNamespace = props.getProperty("documentNamespace");
            docTable = props.getProperty("documentTable");
            provenance = props.getProperty("provenance");

            System.setProperty("gate.plugins.home", props.getProperty("gate.plugins.home"));
            System.setProperty("gate.site.config", props.getProperty("gate.site.config"));
            System.setProperty("gate.home", props.getProperty("gate.home"));

            batchSize = 1000;
            String batchSizeStr = props.getProperty("batchSize");
            if (batchSizeStr != null)
                batchSize = Integer.parseInt(batchSizeStr);

            String fileRoot = props.getProperty("fileRoot");

            write = Boolean.parseBoolean(props.getProperty("write"));


            //log file
            String logFileName = props.getProperty("logFile");

            PrintWriter logPW = new PrintWriter(new FileWriter(logFileName));

            //set db write flag
            String dbWriteStr = props.getProperty("dbWrite");
            boolean dbWrite = true;
            if (dbWriteStr != null && dbWriteStr.length() > 0)
                dbWrite = Boolean.parseBoolean(props.getProperty("dbWrite"));

            //load annotations
            String loadAnnotStr = props.getProperty("loadAnnotationTypes");
            String[] loadAnnotationTypes = null;
            if (loadAnnotStr != null && loadAnnotStr.length() > 0)
                loadAnnotationTypes = loadAnnotStr.split(",");

            docFile = new File(tempDocFolder + "temp.txt");

            String docQuery = props.getProperty("docQuery");
            String docNumQuery = props.getProperty("docNumQuery");

            if (docDBType.equals("cassandra")) {
                docCluster = Cluster.builder().addContactPoint(docHost).withCredentials(docUser, docPassword).build();
                docSession = docCluster.connect(docDBName);
                cassRS = docSession.execute(docQuery);
                //rq = "\"";
            }
            else {
                    docConn = DBConnection.dbConnection(docUser, docPassword, docHost, docDBName, docDBType);
                    Statement stmtNum = docConn.createStatement();
                    ResultSet rsNum = stmtNum.executeQuery(docNumQuery);
                    if(rsNum.next()){
                        documentNum = rsNum.getInt(1);
                    }
                Statement stmt = docConn.createStatement();
                //ResultSet rs = stmt.executeQuery("select RECORD_ID, REPORT_IMPRESSION from RADIOLOGY_REPORTS");
                rs = stmt.executeQuery(docQuery);
            }

            String queryStr = "insert into " + annotOutputTable
                    + " (id, document_namespace, document_table, document_id, annotation_type, start, " + rq + "end" + rq + ", valueStr, features, provenance) "
                    + "	values (?,?,?,?,?,?,?,?,?,?)";


            if (!dbType.equals("cassandra")) {
                //Relational DBs
                conn = DBConnection.dbConnection(user, password, host, dbName, dbType);
                conn.setAutoCommit(false);
                rq = DBConnection.reservedQuote;

                pstmt = conn.prepareStatement(queryStr);

                pstmt.setString(2, docNamespace);
                pstmt.setString(3, annotOutputTable);
                pstmt.setString(10, provenance);


            }
            else {
                //cassandra
                cluster = Cluster.builder().addContactPoint(host).withCredentials(user, password).build();
                session = cluster.connect(dbName);
                bstmt = new BoundStatement(session.prepare(queryStr));
            }

            String gapp = props.getProperty("gappFile");
            URL url = getClass().getResource(gapp);
            gappFile = new File(url.getPath());
            // initialize GATE - this must be done before calling any GATE APIs
            Gate.init();

            // load the saved application
            CorpusController application =
                    (CorpusController)PersistenceManager.loadObjectFromFile(gappFile);

            // Create a Corpus to use.  We recycle the same Corpus object for each
            // iteration.  The string parameter to newCorpus() is simply the
            // GATE-internal name to use for the corpus.  It has no particular
            // significance.
            Corpus corpus = Factory.newCorpus("BatchProcessApp Corpus");
            application.setCorpus(corpus);

            fileList = new ArrayList<File>();

            if (fileRoot != null) {
                Path start = Paths.get(fileRoot);
                java.nio.file.Files.walkFileTree(start, new SimpleFileVisitor<Path>() {
                    @Override
                    public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException
                    {
                        fileList.add(file.toFile());
                        return FileVisitResult.CONTINUE;
                    }
                });
            }

            int count = 0;
            currDoc = 0;


            while (getNextDoc()) {

                if (!hasText)
                    continue;

                System.out.println("Processing document " + docID + "...");
                Document doc = Factory.newDocument(docFile.toURI().toURL(), encoding);
                DocumentContent docContent = doc.getContent();

                boolean loaded = true;
                int maxAnnotID = 0;
                if (loadAnnotationTypes != null) {
                    maxAnnotID = addAnnotationsFromDB(docID, doc.getAnnotations(), loadAnnotationTypes, annotInputTable);
                    ((DocumentImpl) doc).setNextAnnotationId(maxAnnotID+1);

                    //check to see if all annotations were loaded
                    for (int i=0; i<loadAnnotationTypes.length; i++) {
                        AnnotationSet loadAnnotSet = doc.getAnnotations().get(loadAnnotationTypes[i]);
                        if (loadAnnotSet.size() == 0) {
                            loaded = false;
                            break;
                        }
                    }
                }

                if (!loaded)
                    continue;

                // put the document in the corpus
                corpus.add(doc);

                // run the application
                try {
                    application.execute();
                }
                catch(Exception e)
                {
                    e.printStackTrace();
                    logPW.println("Error in document: " + docID);
                    logPW.println("Message: " + e.getMessage());
                    logPW.println("\n\n");
                    logPW.flush();
                    System.exit(-1);
                }

                System.out.println("Finished processing Gate...");

                AnnotationSet defaultAnnots = doc.getAnnotations();
                Iterator iter = defaultAnnots.iterator();

                while (iter.hasNext()) {
                    Annotation annot = (Annotation) iter.next();

                    if (annotationTypeMap.get(annot.getType()) != null || allFlag) {
                        //System.out.println("inserting : " + annot.getType());
                        //System.out.println(reportText.substring(annot.getStartNode().getOffset().intValue(), annot.getEndNode().getOffset().intValue()));
                        if (dbWrite)
                            insertIntoDB(annot, docID, docContent);
                    }

                    if (count % batchSize == 0) {
                        if (!dbType.equals("cassandra")) {
                            pstmt.executeBatch();
                            conn.commit();
                        }
                    }

                    count++;
                }

                if (!dbType.equals("cassandra")) {
                    pstmt.executeBatch();
                    conn.commit();
                }


                count = 0;

                // remove the document from the corpus again
                corpus.remove(0);
                corpus.unloadDocument(doc);
                corpus.clear();

                // Release the document, as it is no longer needed
                Factory.deleteResource(doc);

                currDoc++;
            }

            logPW.close();

            if (!dbType.equals("cassandra")) {
                pstmt.executeBatch();
                conn.commit();
                pstmt.close();
                conn.close();
            }
            else {
                session.close();
                cluster.close();
            }

            if (!docDBType.equals("cassandra")) {
                docConn.close();
            }
            else {
                docSession.close();
                docCluster.close();
            }

            System.out.println("All done");
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }

    private boolean getNextDoc() throws SQLException, IOException
    {
        if (fileList.size() > 0) {
            if (currDoc < fileList.size()) {
                docFile = fileList.get(currDoc);
                docID = currDoc;

                if (docFile.getTotalSpace() > 0)
                    hasText = true;
                else
                    hasText = false;

                return true;
            }
        }
        else {

            if (rs.next()) {
                docID = rs.getInt(1);
                String reportText = rs.getString(2);
                if (reportText != null && reportText.length() > 0) {
                    reportText = reportText.trim();
                    PrintWriter pw = new PrintWriter(new FileWriter(docFile));
                    pw.println(reportText);
                    pw.close();
                    hasText = true;
                }
                else
                    hasText = false;

                return true;
            }


            boolean flag = getNextDocFromDB();
            return flag;
        }

        return false;
    }

    private boolean getNextDocFromDB() throws SQLException, IOException
    {
        String reportText = null;
        boolean flag = false;

        if (!docDBType.equals("cassandra")) {
            if (rs.next()) {
                docID = rs.getInt(1);
                reportText = rs.getString(2);
                reportText = reportText.replaceAll("\r\n", "\n");
                flag = true;
            }
        }
        else {
            if (cassRS.iterator().hasNext()) {
                Row row = cassRS.iterator().next();
                docID = row.getInt(0);
                reportText = row.getString(1);
                flag = true;
            }
        }

        if (reportText != null && reportText.length() > 0) {
            reportText = reportText.trim();
            PrintWriter pw = new PrintWriter(new FileWriter(docFile));
            pw.println(reportText);
            pw.close();
            hasText = true;
        }
        else
            hasText = false;

        return flag;
    }


    private int addAnnotationsFromDB(int docID, AnnotationSet annotSet, String[] loadAnnotationTypes, String annotInputTable) throws SQLException, InvalidOffsetException
    {
        System.out.println("loading annotations...");
        Statement stmt = conn.createStatement();
        StringBuilder strBlder = new StringBuilder("select id, annotation_type, start, " + rq + "end" + rq + ", features from " + annotInputTable + " where (");

        boolean first = true;
        for (String annotType : loadAnnotationTypes) {
            if (!first)
                strBlder.append(" or ");
            else
                first = false;
            strBlder.append("annotation_type = '" + annotType + "'");
        }

        strBlder.append(") and document_id = " + docID + " order by id");

        ResultSet rs = stmt.executeQuery(strBlder.toString());
        int maxAnnotID = -1;
        while (rs.next()) {
            maxAnnotID = rs.getInt(1);
            FeatureMap fm = Factory.newFeatureMap();
            String features = rs.getString(5);
            Map<Object, Object> fm2 = new HashMap<Object, Object>();
            fm2 = gson.fromJson(features, fm2.getClass());
            for (Map.Entry<Object, Object> entry : fm2.entrySet()) {
                fm.put(entry.getKey(), entry.getValue());
            }

            annotSet.add(maxAnnotID, rs.getLong(3), rs.getLong(4), rs.getString(2), fm);
        }

        rs.close();
        stmt.close();

        return maxAnnotID;
    }

    private void insertIntoDB(Annotation annot, int docID, DocumentContent docContent) throws SQLException, InvalidOffsetException
    {
        String annotType = annot.getType();
        long start = annot.getStartNode().getOffset();
        long end = annot.getEndNode().getOffset();
        int id = annot.getId();
        String valueStr = docContent.getContent(start, end).toString();

        //System.out.println("docID: " + docID + " type: " + annotType + " start: " + start + " end: " + end + " id: " + id)

        String featureStr = getFeatureString(annot);

        if (dbType.equals("cassandra"))
            insertIntoCassandra(id, docID, annotType, (int) start, (int) end, valueStr, featureStr);
        else
            insertIntoRelational(id, docID, annotType, (int) start, (int) end, valueStr, featureStr);
    }

    private void insertIntoRelational(int id, int docID, String annotType, int start, int end, String valueStr, String featureStr) throws SQLException
    {
        pstmt.setInt(1, id);
        pstmt.setString(2, docNamespace);
        pstmt.setString(3, docTable);
        pstmt.setInt(4, docID);
        pstmt.setString(5, annotType);
        pstmt.setLong(6, start);
        pstmt.setLong(7, end);
        pstmt.setString(8, valueStr);
        pstmt.setString(9, featureStr);
        pstmt.addBatch();
    }

    private void insertIntoCassandra(int id, int docID, String annotType, int start, int end, String valueStr, String featureStr) throws InvalidOffsetException
    {
        String docName = docNamespace + "-" + docTable + "-" + docID;
        session.execute(bstmt.bind(id, docNamespace, docTable, docID, docName, annotType, start, end, valueStr, featureStr, provenance));
    }

    private String getFeatureString(Annotation annot)
    {
        FeatureMap featureMap = annot.getFeatures();
        StringBuilder strBlder = new StringBuilder("{");

        Iterator iter2 = featureMap.keySet().iterator();
        for (;iter2.hasNext();) {

            if (strBlder.length() > 1)
                strBlder.append(",");

            String key = (String) iter2.next();
            Object obj =  featureMap.get(key);
            String objStr = cleanObjString(obj.toString());
            if (!(obj instanceof List))
                //System.out.println(key + "=" + obj.toString());
                strBlder.append("\"" + key + "\":\"" + objStr + "\"");

            else {
                boolean first = true;
                StringBuilder listStr = new StringBuilder("\"" + key + "\":[");
                List valueList = (List) obj;
                for (Object value : valueList) {
                    if (!first) {
                        listStr.append(",");
                    }

                    //System.out.println(key + "=" + value.toString());
                    listStr.append("\"" + value.toString() + "\"");
                    first = false;
                }

                listStr.append("]");

                strBlder.append(listStr);
            }


        }

        strBlder.append("}");

        return strBlder.toString();
    }

    private String cleanObjString(String str)
    {
        StringBuilder strBlder = new StringBuilder();
        for (int i=0; i<str.length(); i++) {
            char ch = str.charAt(i);
            if (ch == '"') {
                strBlder.append("\\\"");
            }
            else if (ch == '\\')
                strBlder.append("\\\\");
            else
                strBlder.append(ch);
        }

        return strBlder.toString();
    }

    private Object convertValue(String value)
    {
        Object obj = value;
        boolean converted = false;
        try {
            obj = Double.parseDouble(value);
            converted = true;
        }
        catch(NumberFormatException e)
        {
        }

        if (!converted) {
            try {
                obj = Integer.parseInt(value);
                converted = true;
            }
            catch(NumberFormatException e)
            {
            }
        }

        if (!converted)
            obj = value;

        return obj;
    }

    public int getDocumentNum() throws SQLException, ClassNotFoundException {
        return documentNum;
    }

    public int getCurrDoc() {
        return currDoc;
    }

    public static void main(String[] args) throws IOException {

	/*  if (args.length != 5) {
		  System.out.println("usage: user password docUser docPassword config");
		  System.exit(0);/Users/jiayunli/Documents/workspace/GATE
	  }
	  */
        GateBatch gateBatch = new GateBatch();
        gateBatch.setConfig("root","be223","root","be223","src/gate-batch-lung-cancer-screening.properties");
        gateBatch.process();
        // gateBatch.process(args[0], args[1], args[2], args[3], args[4]);
    }

}