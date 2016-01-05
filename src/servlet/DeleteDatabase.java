package servlet;

import connection.Database;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;

/**
 * Created by jiayunli on 15/12/8.
 */
public class DeleteDatabase extends HttpServlet{
    //static int i;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doPost(request,response);
        // response.sendRedirect("");
    }
    protected void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
         String userName = (String)request.getParameter("userName");
         //String docDB = (String)request.getParameter("databaseName");
        String docDB = request.getParameter("docDB");
        String docDBName = docDB.split("\\.")[0];
        String docDBTable = docDB.split("\\.")[1];
        Database database = new Database();
        try {
            database.updateAccessDocDB(userName,docDBName,docDBTable);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        response.getWriter().write("You have successfully deleted " + docDBTable + "in " + docDBName );
    }
}
