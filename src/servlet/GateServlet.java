package servlet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import com.google.gson.Gson;
import connection.*;
import exception.GateException;
import exception.Message;
import exception.Msg;

/**
 * Created by jiayunli on 15/11/14.
 */
public class GateServlet  extends HttpServlet {
   // static int i=0;
    //protected GateThreadClass  gatethread = new GateThreadClass("Jiayun","root","annotations","results","documents","reports","be223","root","be223","Token","/gate/gate-batch-lung-cancer-screening.properties");
    protected int documentNum;
     static LinkedList<GateThreadClass> gatethreads = new LinkedList<GateThreadClass>();
    protected void doGet(HttpServletRequest request,
    HttpServletResponse response) throws IOException {
       doPost(request,response);
    }
    protected void doPost (HttpServletRequest request, HttpServletResponse response) throws IOException {
       // i++;
        String pipelineName = request.getParameter("pipelineName");
        String docDB = request.getParameter("docDB");
       // String[] temp = "documents.reports".split(".");
        String docDBName = docDB.split("\\.")[0];
        String docDBTable = docDB.split("\\.")[1];
        String annotationType = request.getParameter("annotationType");
        String userName = request.getParameter("userName");
        String docDBPassword = request.getParameter("docDBPassword");
        //Msg statusMsg = new Msg();
       // String [] annotationType =request.getParameterValues("annotationType[]");
        //annotationType.toString();
        String dbName = request.getParameter("annotationDB");
       // String[] temp2 = annotationDB.split(".");
        String dbTable = request.getParameter("annotationTable");
        String annotationDBUser = request.getParameter("annotationDBUser");
        String annotatioDBPassword = request.getParameter("annotationDBPassword");
        String docUser = request.getParameter("docUser");
        GateThreadClass gatethread = new GateThreadClass(String.valueOf(gatethreads.size()), pipelineName,userName,annotationDBUser,dbName,dbTable,docDBName,docDBTable,annotatioDBPassword,docUser,docDBPassword,annotationType,"/gate/gate-batch-lung-cancer-screening.properties");
       // gatethread.start();

        ExecutorService exec = Executors.newSingleThreadExecutor();

        //Future future = exec.submit(gatethread);
        gatethread.setDaemon(false);
        exec.execute(gatethread);

       // gatethread.run();
        gatethreads.add(gatethread);
      //  gatethread.reset();
        int size = gatethreads.size();
        try {
             documentNum = gatethread.getTotaldocNum();
        } catch (SQLException e) {
            e.printStackTrace();
        }

       // exec.execute(gatethreads.get(size-1));
        Message msg = new Message();
        msg.setTotal(String.valueOf(documentNum));
        msg.setThreadId(String.valueOf(size-1));
        Gson gson = new Gson();
        String json = gson.toJson(msg);
        response.getWriter().write(json);
        //String current = thread.call();
        //request.setAttribute("thread",thread);
        //response.getWriter().write(String.valueOf(current));
        //  int currentDoc =0;
     //   GateThreadClass gateThreadClass = new GateThreadClass("root","be223","root","be223","/gate/gate-batch-lung-cancer-screening.properties");
     //   exec.execute(gateThreadClass);
       // exec.shutdown();
       // response.setContentType("text/plain");
       // response.setCharacterEncoding("UTF-8");
      /*  try {
              currentDoc = Integer.parseInt(gateThreadClass.call());
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.getWriter().write(currentDoc);*/
    }
}
// gateThreadClass.run();
// String url = "/web/WEB-INF/gateProcess.jsp";


           /* while(!(gateThreadClass.call().equals("complete"))){
               // PrintWriter out= response.getWriter();
                //response.getWriter().write(gateThreadClass.call());
                request.setAttribute("progress",gateThreadClass.call());
                request.getRequestDispatcher("http://localhost:8080/medicalFramework_war_exploded/web/gateProcess.jsp").forward(request, response);
            }*/
// request.setAttribute("progress",gateThreadClass.call());
//   request.getRequestDispatcher("/gateProcess.jsp").forward(request, response);
// rd.forward(request, response);