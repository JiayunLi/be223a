<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/29
  Time: 下午1:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="connection.Database"%>
<%@ page import="java.sql.SQLException" %>
<%@ page import="gate.GateLocation" %>
<html>
<head>
<script src="lib/ie8-responsive-file-warning.js"></script><![endif]-->
<script src="lib/ie-emulation-modes-warning.js"></script>
<link href="lib/bootstrap.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="dashboard.css" rel="stylesheet">
<link rel="stylesheet" href="lib/jquery-ui.css">
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="lib/favicon.ico">

  <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
  <!--[if lt IE 9]><script src="lib/ie8-responsive-file-warning.js"></script><![endif]-->
  <script src="lib/ie-emulation-modes-warning.js"></script>
  <title>Settings</title>
</head>
<%
  String userName=(String)session.getAttribute("userName");
  String msg = (String)session.getAttribute("login");
  boolean login = true;
  if(msg==null){
    login = false;
  } else if(!msg.equals("true")){
    login = false;
  }
  if(!login){
    response.sendRedirect("index.jsp");
    session.removeAttribute("login");
  }
  session.removeAttribute("login");
  session.setAttribute("login","true");
  session.setAttribute("userName",userName);
  GateLocation gateLocation = new GateLocation();
%>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <div class="navbar-brand" style="color: white">Medical Dashboard</div>
    </div>
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="dashboard.jsp">Home</a></li>
        <li><a href="index.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>
<%
  Database database = new Database();
  try {
    gateLocation = database.getGateLocation(userName);
  } catch (SQLException e) {
    e.printStackTrace();
  } catch (ClassNotFoundException e) {
    e.printStackTrace();
  }


%>
<form method="post" action="gateConfig.jsp">
  <div class="form-group">
    <input type = "hidden" id = "userName" name = "userName" value = "<%=userName%>">
    <label style = "padding-top:5%; padding-left: 10%;" for="gate-plugins"  autofocus>Gate plugings location</label>
    <div style="padding-left: 10%; width: 80%">
     <div style = "padding-top: 10px"> <input  type = "text" class = "form-control" id = "gate-plugins" name ="gate-plugins" autofocus
      <%if(gateLocation.getGatePlugins()!=null)
           out.print("value = " + gateLocation.getGatePlugins() + ">");
        else
           out.print("placeholder = 'ex: /Applications/GATE_Developer_8.1/plugins'" + ">");
      %></div>
      <label style="padding-top: 10px"for = "gate-site">Gate Site Home Location</label>
      <div> <input  type = "text" class = "form-control" id = "gate-site" name = "gate-site"
       <%if(gateLocation.getGateSite()!=null)
            out.print("value = " + gateLocation.getGateSite() + ">");
         else
            out.print("placeholder = 'ex: /Applications/GATE_Developer_8.1/gate.xml'" + ">");
       %></div>
      <label style="padding-top: 10px" for = "gate-home">Gate Site Home Location</label>
      <div><input  type = "text" class = "form-control" id = "gate-home" name = "gate-home"
      <%if(gateLocation.getGateHome()!=null)
           out.print("value = "+gateLocation.getGateSite() + ">");
         else
           out.print("placeholder = 'ex: /Applications/GATE_Developer_8.1/Gate_Developer_8.1'" + ">");
        %></div>
    </div>
    <div style="padding-left: 10%; padding-top: 10px;"><input type = "submit" class="btn btn-lg btn-primary btn-block" id ="saveGateConfig" style ="width: 20%; alignment: center;" value = "Save"></div>
  </div>
  </form>
<div id = "message" style = "padding-top: 10px; font-size: 15px;  color: indianred; padding-left: 10%">
  <%
    if(session.getAttribute("msg")!=null){
      out.print(session.getAttribute("msg"));
      session.removeAttribute("msg");
    }
  %>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="lib/bootstrap.min.js"></script>
<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="lib/ie10-viewport-bug-workaround.js"></script>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<script src="lib/jquery.js"> </script>
<script src="lib/jquery-ui-gate.js"></script>
</body>
</html>
