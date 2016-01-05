<%@ page import="connection.AccessFormat" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="connection.Database" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="gate.GateAccess" %>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午2:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="lib/favicon.ico">

  <title>Medical Dashboard</title>

  <!-- Bootstrap core CSS -->
  <link href="lib/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="dashboard.css" rel="stylesheet">
  <link rel="stylesheet" href="lib/jquery-ui.css">

  <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
  <!--[if lt IE 9]><script src="lib/ie8-responsive-file-warning.js"></script><![endif]-->
  <script src="lib/ie-emulation-modes-warning.js"></script>

  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>

<body>
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
 // int documentNum;
%>
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
        <li><button class ="navButton" id="run-gate">Run Gate</button></li>
        <li><a href="settings.jsp">Settings</a></li>
        <li><a href="index.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container-fluid">
  <div class="row">
    <div class="col-sm-3 col-md-2 sidebar">
      <ul class="nav nav-sidebar">
        <li class="active"><a href="#">OVERVIEW <span class="sr-only">(current)</span></a></li>
        <li><a href="database.jsp">DATABASE</a></li>
        <li><a href="gate.jsp">GATE</a></li>
      </ul>
      </div>
   <!-- <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
      <h1 class="page-header">Dashboard</h1>
    </div> -->
    <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
      <div class="table-responsive">
        <table id ="systemStatus" class="table table-striped">
          <thead>
          <tr>
            <th>Job Number</th>
            <th>Document database Name</th>
            <th>Document Table Name</th>
            <th>Current Status</th>
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<div id="gate-config" title="Run Gate">
  <form>
    <input type = "hidden" id = "userName" name = "userName" value = "<%=userName%>">

    <label for = "annotationDB">Annotation Database Name</label>
    <input type = "text" name = "annotationDB" id = "annotationDB">
    <label for = "annotationDBUser">Annotation Database UserName</label>
    <input type = "text" name = "annotationDBUser" id = "annotationDBUser">
    <label for = "annotationTable">Annotation Database Table</label>
    <input type = "text" name = "annotationTable" id = "annotationTable">
    <label for = "annotationDBPassword">Annotation Database Password</label>
    <input type = "password" name = "annotationDBPassword" id = "annotationDBPassword">
    </form>
  <form>
    <style>
      fieldset {
        border: 0;
      }
      label {
        display: block;
        margin: 30px 0 0 0;
      }
      select {
        width: 200px;
      }
      .overflow {
        height: 200px;
      }
    </style>
    <script>
      $(function() {
        $( "#docDB" ).selectmenu();
        $( "#pipelineName" ).selectmenu();
      });
    </script>
    <fieldset>
      <label for="docDB">select a document databases</label>
      <select name="docDB" id="docDB">
        <%
          Database database = new Database();
          LinkedList<AccessFormat> list = null;
          try {
            list = database.getAccessDatabaseList(userName);
          } catch (SQLException e) {
            e.printStackTrace();
          } catch (ClassNotFoundException e) {
            e.printStackTrace();
          }
          Iterator<AccessFormat> it = list.iterator();
          if (list != null) {
            it = list.iterator();
            while(it.hasNext()){
              AccessFormat accessFormat = it.next();
              out.println("<option>" + accessFormat.getDatabaseName() + "." + accessFormat.getTableName() + "</option>");
             // documentNum = accessFormat.getDocumentsNum();
             // out.println("<input type = 'hidden' name = 'documentNum' value = "+ documentNum + "/>");
            }
          }
        %>
      </select>
      <label for = "docUser">Database UserName</label>
      <input type = "text" name = "docUser" id = "docUser">
      <label for = "docDBPassword">document Database Password</label>
      <input type = "password" name = "docDBPassword" id = "docDBPassword">
      <label for="pipelineName">Select a pipeline</label>
      <select name="pipelineName" id="pipelineName">
        <%
          //Database database = new Database();
          // GateAccess gateAccess = new GateAccess();
          LinkedList<GateAccess> gatelist = new LinkedList<GateAccess>();
          try {
            gatelist = database.getPipelineList(userName);
          } catch (SQLException e) {
            e.printStackTrace();
          } catch (ClassNotFoundException e) {
            e.printStackTrace();
          }
          Iterator<GateAccess> gateit = gatelist.iterator();
          if (list != null) {
            gateit = gatelist.iterator();
            while(gateit.hasNext()){
              GateAccess gate = gateit.next();
             // out.println("<tr>");
              out.println("<option>" + gate.getPipelineName() + "</option>");
             // out.println("<td> " + gate.getPipelineDescription() + " </td>");
             // out.println("</tr>");
            }
          }
        %>
      </select>
    </fieldset>
    </form>

    <div id = "annotationType">
    <label>Choose Annotation Type: </label>
    <input type = "checkbox" value = "Token">Token<br>
    <input type = "checkbox" value = "Sentence">Sentence<br>
    <input type = "checkbox" value = "Number">Number<br>
    <input type = "checkbox" value = "Date">Date<br>
  </div>
  <button type = "submit" id = "dialogSubmit">Confirm</button>
  <button id = "dialogClose">Cancel</button>
  </div>
<span id="dashboardMsg" style="padding-left: 20%; padding-top: 10px; color: palevioletred;"></span>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="lib/bootstrap.min.js"></script>
<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="lib/ie10-viewport-bug-workaround.js"></script>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<script src="lib/jquery.js"> </script>
<script src="lib/jquery-ui.js"></script>
<script src="js/addJob.js"></script>
</body>
</html>