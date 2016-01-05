<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午4:42
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

  <title>Activate your account</title>

  <!-- Bootstrap core CSS -->
  <link href="lib/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="sendActivateEmail.css" rel="stylesheet">

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
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <div class="navbar-brand" style="color: white">Project name</div>
    </div>
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="#">Contact</a></li>
        <li><a href="#">Help</a></li>
      </ul>
      <!-- <form class="navbar-form navbar-right">
         <input type="text" class="form-control" placeholder="Search...">
       </form>-->
    </div>
  </div>
</nav>
<div class="container">

  <form class="form-activate" action="sendEmail.jsp" method="post">
    <h2 class="form-activate-heading">Activate your account!</h2>
    <label for="inputEmail" class="sr-only">Email address</label>
    <input type="email" id="inputEmail" class="form-control" name="email" placeholder="Email address" required autofocus>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Send</button>
  </form>
</div>
<%
  session.setAttribute("type","activate");
%>
<div class="message">
  <%
    String msg=(String)session.getAttribute("msg");
    if(msg!=null){
      if(msg.equals("true")){
        session.removeAttribute("msg");
        out.println("The activation Email has already been sent, please check your Email box");
      }else{
        session.removeAttribute("msg");
        out.println("Unable to sent Email, please check your Email address");
      }
    }
  %>
</div>
<script src="lib/ie10-viewport-bug-workaround.js"></script>
</body>
</html>
