<%@ page import="loginModule.User" %>
<%@ page import="loginModule.Registration"%>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午6:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="">
<meta name="author" content="">
<link rel="icon" href="lib/favicon.ico">
<title>Sign Up</title>

<!-- Bootstrap core CSS -->
<link href="lib/bootstrap.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="accountActivate.css" rel="stylesheet">

<!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
<!--[if lt IE 9]><script src="lib/ie8-responsive-file-warning.js"></script><![endif]-->
<script src="lib/ie-emulation-modes-warning.js"></script>

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>-->

<head>
  <title></title>
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
      <div class="navbar-brand" style="color: white">Medical Dashboard</div>
    </div>
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="#">Contact</a></li>
        <li><a href="#">Help</a></li>
        </ul>
      </div>
    </div>
  </nav>
<div class="message">
  <%
    String userName=request.getParameter("userName");
    String checkCode=request.getParameter("checkCode");
    Registration registration=new Registration();
    User user=registration.getUserInfo(userName);
    if(user==null){
      out.print("Oops! Something is not right. Please try activate again");%>
  <a href="sendActivateEmail.jsp">Resent Activation Email?</a>
  <%
    }else{
      if(!user.isActivated()){
        if(user.getRandomCode().equals(checkCode)){
          if(registration.activate(user)){
            out.println("Thank you! "+userName);%><br>
  <%
    out.print("Your account has been successfully activated, please ");%>
  <a class="btn btn-success btn-lg" href="signin.jsp" style="color: white" role="button">Sign In &raquo;</a>
  <%
    }else{
      out.print("Oops! Something is not right. Please try activate again");
    }
  }else{

    out.print("Activation link is not right, please try again!  ");%>
  <a href="sendActivateEmail.jsp">Resent Activation Email?</a>
  <%
    }

  }else{
    out.println("Thank you! "+userName);
    out.println("\n");%><br>
  <%
    out.print("Your account has already been activated, please ");%>
  <a  class="btn btn-success btn-lg" href="signin.jsp" style="color: white" role="button">Sign In &raquo;</a>
  <%
      }
    }

  %>
</div>

</body>
</html>
