<%@ page import="connection.Database" %>
<%@ page import="gate.GateLocation" %>
<%@ page import="java.sql.SQLException" %>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/29
  Time: 下午10:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<%
  Database database = new Database();
  String userName = request.getParameter("userName");
  String gatePlugins = request.getParameter("gate-plugins");
  String gateSite = request.getParameter("gate-site");
  String gateHome = request.getParameter("gate-home");
  String message = null;
  if(userName==null||gatePlugins==null||gateSite==null||gateHome==null){
    message = "Please complete all required information";
    session.setAttribute("msg",message);
    response.sendRedirect("settings.jsp");
  }else{
    GateLocation gateLocation = new GateLocation();
    gateLocation.setGateHome(gateHome);
    gateLocation.setGatePlugins(gatePlugins);
    gateLocation.setGateSite(gateSite);
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
    session.setAttribute("msg",message);
    response.sendRedirect("settings.jsp");
  }

%>
</body>
</html>
