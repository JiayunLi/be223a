<%@ page import="connection.Database" %>
<%@ page import="connection.AccessFormat" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="servlet.ImportGate"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="gate.GateAccess" %>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午10:57
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

  <title>Dashboard Template for Bootstrap</title>

  <!-- Bootstrap core CSS -->
  <link href="lib/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="dashboard.css" rel="stylesheet">


  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
  <link rel="stylesheet" href="lib/jquery-ui.css">
</head>
<%
  String userName = (String)session.getAttribute("userName");
  String login = (String)session.getAttribute("login");
  boolean in = true;
  if(login==null){
    in = false;
  }else if(!login.equals("true")){
    in = false;
  }
  if(!in){
    session.removeAttribute("userName");
    session.removeAttribute("login");
    response.sendRedirect("index.jsp");
  }
  session.setAttribute("userName",userName);
  session.setAttribute("login","true");
  int documentNum;
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
        <li><a href="dashboard.jsp">Dashboard</a></li>
        <li><button class ="navButton" id="gateImport">Import GATE</button></li>
        <li><button class ="navButton" id="delete">Delete</button></li>
        <li><a href="index.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div id="dialog-gate" title="Import new Gate Pipeline">
<!-- enctype="multipart/form-data-->
  <form enctype="multipart/form-data" method = "post" action="servlet/ImportGate">
  <input type = "hidden" id = "userName" name = "userName" value = "<%=userName%>">
  <label for = "pipelineName">Enter the Pipeline Name</label>
  <input type = "text" id = "pipelineName" name = "pipelineName">
  <!--<label for = "pipelineLocation">Pipeline Locations</label>
  <input type = "text" id = "pipelineLocation" name = "piplineLocation">      -->
  <label for ="description" >Description</label>
  <input type = "text" id = "description" name = "description">
  <!--<button type = "submit" id = "dialogSubmit">Confirm</button>-->
  <div style="padding-top: 5px;"> <input type = "file" id = "fileUpload" name = "fileUpload" ></div>
    <button type = "submit" id = "dialogSubmit">Confirm</button>
    <button style="padding-top: 5px;" id = "dialogClose">Cancel</button>
</form>
    <!--<button id = "dialogSubmit">Submit</button>-->

</div>
<div id = "delete-gate" title = "Delete gate pipeline">
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
    <input type = "hidden" id = "loginUser" name = "loginUser" value = "<%=userName%>">
    <fieldset>
      <label for="gatepipeline">select a gate pipeline to delete</label>
      <select name="gatepipeline" id="gatepipeline">
        <%
          Database ddatabase = new Database();
          // GateAccess gateAccess = new GateAccess();
          LinkedList<GateAccess> dlist = new LinkedList<GateAccess>();
          dlist = ddatabase.getPipelineList(userName);
          Iterator<GateAccess> dit = dlist.iterator();
          if (dlist != null) {
            dit = dlist.iterator();
            while(dit.hasNext()){
              GateAccess gate = dit.next();
              out.println("<option>" + gate.getPipelineName() + "</option>");
            }
          }
        %>
        </select>
      </fieldset>
    <br style = "padding-top:5px">
    <button  type="button" id="ddialogClose">Close</button>
    <button  type="button" id="ddialogSubmit">Submit</button>
  </form>

</div>

<div class="container-fluid">
  <div class="row">
    <div class="col-sm-3 col-md-2 sidebar">
      <ul class="nav nav-sidebar">
        <li><a href="dashboard.jsp">OVERVIEW </a></li>
        <li><a href="database.jsp">DATABASE</a></li>
        <li class="active"><a href="gate.jsp">GATE <span class="sr-only">(current)</span></a></li>
      </ul>
    </div>
    <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
      <div class="table-responsive">
        <table id ="gate-table" class="table table-striped">
          <thead>
          <tr>
            <th>Pipeline Name</th>
            <th>Pipeline Description</th>
          </tr>
          </thead>
          <tbody>
          <%
            Database database = new Database();
           // GateAccess gateAccess = new GateAccess();
            LinkedList<GateAccess> list = new LinkedList<GateAccess>();
            list = database.getPipelineList(userName);
            Iterator<GateAccess> it = list.iterator();
            if (list != null) {
              it = list.iterator();
              while(it.hasNext()){
                GateAccess gate = it.next();
                out.println("<tr>");
                out.println("<td> " + gate.getPipelineName() + " </td>");
                out.println("<td> " + gate.getPipelineDescription() + " </td>");
                out.println("</tr>");
              }
            }

          %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<span id="gatemsg" style="padding-left: 20%; padding-top: 10px; color: palevioletred;">
  <%
    if(request.getAttribute("status")!=null){
      out.print(request.getAttribute("status"));
    }
  %>
</span>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="lib/bootstrap.min.js"></script>
<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="lib/ie10-viewport-bug-workaround.js"></script>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<script src="lib/jquery.js"> </script>
<script src="lib/jquery-ui.js"></script>
<script src="js/addGatePipeline.js"></script>
<script src="js/deleteGate.js"></script>
</body>

</html>
<!--
<form method="post" enctype="multipart/form-data" lang="en">
<label for="userName">User Name</label>
<input type="text" name="userName" id="userName">
<script>function getFile(){
document.getElementById("upfile").click();
}
function sub(obj){
var file = obj.value;
var fileName = file.split("\\");
document.getElementById("yourFile").innerHTML = fileName[fileName.length-1];
document.myForm.submit();
event.preventDefault();
}</script>
<div id="yourBtn"  onclick="getFile()"><button>click to upload a file</button></div>
<!-- this is your file input tag, so i hide it!-->
<!-- i used the onchange event to fire the form submission-->
<!--<div style='height: 0px;width: 0px; overflow:hidden;'><input id="upfile" type="file" value="upload" onchange="sub(this)"/></div>
<div id ="yourFile"></div>
<button type="button" id="dialogClose">Close</button>
<button type="button" id="dialogSubmit">Submit</button>
</form>
-->