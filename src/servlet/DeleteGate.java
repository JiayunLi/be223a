package servlet;

import connection.Database;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Created by jiayunli on 15/12/8.
 */
public class DeleteGate extends HttpServlet{
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doPost(request,response);
        // response.sendRedirect("");
    }
    protected void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
        String userName = (String)request.getParameter("userName");
        //String docDB = (String)request.getParameter("databaseName");
        String pipelineName = (String)request.getParameter("gatepipeline");

        Database database = new Database();
        try {
            database.updateGateAccess(userName,pipelineName);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        response.getWriter().write("You have successfully deleted " + pipelineName);
    }
}
