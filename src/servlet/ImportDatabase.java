package servlet;

import com.google.gson.Gson;
import connection.AccessFormat;
import connection.Database;
import exception.Msg;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by jiayunli on 15/12/8.
 */
public class ImportDatabase extends HttpServlet {
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws IOException, ServletException{
        doPost(request,response);

    }
    protected void doPost(HttpServletRequest request,
                         HttpServletResponse response) throws IOException, ServletException{
        Database database = new Database();
        String userName=request.getParameter("userName");
        String databaseName = request.getParameter("databaseName");
        String dbUserName = request.getParameter("dbUserName");
        String password = request.getParameter("password");
        String tableName = request.getParameter("tableName");

        String msg = null;
        try {
            msg = database.importDatabase(userName,dbUserName,password,databaseName,tableName);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        Msg message = new Msg();
        if(msg==null){
            String json = database.getAcessDetails();
            Gson gson = new Gson();
            AccessFormat accessFormat = gson.fromJson(json,AccessFormat.class);
            int documentNum = accessFormat.getDocumentsNum();

            message.setType("suc");
            message.setMessage("<tr>" + "<td>" +
                    databaseName+"</td>" + "<td>" + tableName + "</td>" + "<td>" + documentNum + "</td>" + "</tr>" );
           // response.getWriter().write("<tr>" + "<td>" +
                  //  databaseName+"</td>" + "<td>" + tableName + "</td>" + "<td>" + documentNum + "</td>" + "</tr>" );
        }else{
            message.setType("error");
            message.setMessage(msg);
           // response.getWriter().write(msg);
        }
        Gson gson = new Gson();
        String json = gson.toJson(message);
        response.getWriter().write(json);

    }
}
