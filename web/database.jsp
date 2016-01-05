<%@ page import="connection.Database" %>
<%@ page import="connection.AccessFormat" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.SQLException" %>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午10:53
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
</head>
<link rel="stylesheet" href="lib/jquery-ui.css">
<body>
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
        <li><a href="dashboard.jsp">Dashboard</a></li>
        <li><button class ="navButton" id="import-database">Import</button></li>
        <li><button class ="navButton" id="delete-database">Delete</button></li>
        <li><a href="index.jsp">Logout</a></li>
      </ul>
      </div>
    </div>
</nav>
<div id="dialog-form" title="Create new user">
  <form>
    <input type="hidden" id="userName" name="userName" value="<%=userName%>">
    <label for="databaseName">Database Name</label>
    <input type="text" name="databaseName" id="databaseName">
    <label for="tableName">Table Name</label>
    <input type="text" name="tableName" id="tableName">
    <label for="dbUserName">Database User Name</label>
    <input type="text" name="dbUserName" id="dbUserName">
    <label for="password">Password</label>
    <input type="password" name="password" id="password">
    <button type="button" id="dialogClose">Close</button>
    <button type="button" id="dialogSubmit">Submit</button>
  </form>
</div>
<div id = "dialog-delete" title = "Delete Database">
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
    <label for="docDB">select a document databases</label>
    <select name="docDB" id="docDB">

      <%
        Database ddatabase = new Database();
        LinkedList<AccessFormat> dlist = null;
        try {
          dlist = ddatabase.getAccessDatabaseList(userName);
        } catch (SQLException e) {
          e.printStackTrace();
        } catch (ClassNotFoundException e) {
          e.printStackTrace();
        }
        Iterator<AccessFormat> dit = dlist.iterator();
        if (dlist != null) {
          dit = dlist.iterator();
          while(dit.hasNext()){
            AccessFormat accessFormat = dit.next();
            out.println("<option>" + accessFormat.getDatabaseName() + "." + accessFormat.getTableName() + "</option>");
            // documentNum = accessFormat.getDocumentsNum();
            // out.println("<input type = 'hidden' name = 'documentNum' value = "+ documentNum + "/>");
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
        <li class="active"><a href="database.jsp">DATABASE <span class="sr-only">(current)</span></a></li>
        <li><a href="gate.jsp">GATE</a></li>
      </ul>
    </div>
    <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
      <div class="table-responsive">
        <table id ="currentDatabase" class="table table-striped">
          <thead>
          <tr>
            <th>Database Name</th>
            <th>Table Name</th>
            <th>Documents Number</th>
          </tr>
          </thead>
          <tbody>
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
              out.println("<tr>");
                out.println("<td> " + accessFormat.getDatabaseName() + " </td>" );
                out.println("<td> " + accessFormat.getTableName() + " </td>");
                out.println("<td>" + accessFormat.getDocumentsNum() + " </td>");
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
<span id="gatemsg" style="padding-left: 20%; padding-top: 10px; color: palevioletred;"></span>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<script src="lib/jquery.js"> </script>
<script src="lib/jquery-ui.js"></script>
<script src="js/importDatabase.js"></script>
<script src="js/deleteDatabase.js"></script>
</body>
</html>