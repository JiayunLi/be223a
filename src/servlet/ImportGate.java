package servlet;

import connection.Database;
import gate.GateLocation;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

/**
 * Created by jiayunli on 15/11/29.
 */
@MultipartConfig(maxFileSize = 16177215)
public class ImportGate extends HttpServlet {
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws IOException, ServletException {
        doPost(request,response);
    }
    protected void doPost (HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
       // Database database = new Database();
       // String userName = request.getParameter("userName");
        String userName = request.getParameter("userName");
        String pipelineName = request.getParameter("pipelineName");
        String description = request.getParameter("description");
        String message = null;
        InputStream inputStream = null;
        Part filePart = request.getPart("fileUpload");
        if (filePart != null) {
            inputStream = filePart.getInputStream();
            Database database = new Database();
            try {
               message = database.importGate(userName, pipelineName,description,inputStream);
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
            request.setAttribute("status",message);
            response.sendRedirect("/medicalFramework_war_exploded/gate.jsp");
            //request.setAttribute();
            //session.setAttribute("status","suc");
            // session.setAttribute("pipelineName",pipelineName);
            // session.setAttribute("description",description);
        }
       /* try {
            GateLocation gateLocation = database.getGateLocation(userName);
            if(gateLocation.getGatePlugins()==null||gateLocation.getGateHome()==null||gateLocation.getGateSite()==null){
                response.getWriter().write("Please input GATE configuration information first in the setting page!!");
                //request.setAttribute("msg","Please input GATE configuration information first in the setting page!!");
            }else{
                String pipelineName = request.getParameter("pipelineName");
                String description = request.getParameter("pipelineDescription");
                String filePath = request.getParameter("pipelinePath");
                // String location = request.getParameter("pipelineLocation");
                InputStream inputStream = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }*/


       // Part filePart = request.getPart("fileUpload");
       // inputStream = filePart.getInputStream();

        // forwards to the message page
       //getServletContext().getRequestDispatcher("/gate.jsp").forward(request, response);

        //File file = request.getParameter("uploadFile");
    }
}
