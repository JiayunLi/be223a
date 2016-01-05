package servlet;

import com.sun.net.httpserver.HttpServer;
import connection.Database;
import gate.GateLocation;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Created by jiayunli on 15/11/29.
 */
public class GateConfigServlet extends HttpServlet{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doPost(request,response);
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Database database = new Database();
        String userName = request.getParameter("userName");
        String gatePlugins = request.getParameter("gatePlugins");
        String gateSite = request.getParameter("gateSite");
        String gateHome = request.getParameter("gateHome");
        GateLocation gateLocation = new GateLocation();
        gateLocation.setGateHome(gateHome);
        gateLocation.setGatePlugins(gatePlugins);
        gateLocation.setGateSite(gateSite);
        String message = null;
        try {
            if(database.updateGateLocation(userName,gateLocation)){
                message = "You have successfully update GATE configuration information";
            }else{
                message = "Update failed, please try it again";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            message = "Update failed, please try it again";
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "Update failed, please try it again";
        }
        response.getWriter().write(message);
    }
}
