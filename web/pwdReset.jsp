<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午8:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="lib/favicon.ico">

  <title>Password Retrieve</title>

  <!-- Bootstrap core CSS -->
  <link href="lib/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="pwdReset.css" rel="stylesheet">

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
  if(((String)session.getAttribute("authenticated"))==null){
    session.invalidate();
    request.logout();
  }else if(!(((String)session.getAttribute("authenticated")).equals("true"))){
    session.invalidate();
    request.logout();
  }
  String userName=(String)session.getAttribute("userName");
 // out.println(session.getAttribute("userName"));
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
      <div class="navbar-brand" style="color: white">Welcome back <%out.print(userName);%></div>
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

  <form class="form-signin" action="pwdUpdate.jsp" method="post">
    <div class="form-pwdreset-heading">Reset your password!</div>
    <label for="password" class="sr-only">Password</label>
    <input type="password" id="password" class="form-control" name="password" placeholder="New Password" required autofocus>
    <label for="confirmPassword" class="sr-only">Confirm Password</label>
    <input type="password" id="confirmPassword"  class="form-control" name="passwordV" placeholder="Confirm Password" required>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Reset</button>
  </form>
  </div>
<div class="message">
  <%
    String msg=(String)session.getAttribute("msg");
    if(msg!=null){
      if(msg.equals("wrongPWD")){
        session.removeAttribute("msg");
        out.println("Passwords don't match, please try again");
      }else if(msg.equals("suc")){
        out.print("Your password has been changed, please ");%>
  <!--<button type="button" class="btn btn-lg btn-primary"><a href="signin.jsp" style="text-decoration: none; color: white">Sign in</a></button>-->
  <a href="signin.jsp">Sign in</a>
  <%
      }
    }
  %>
</div>
</body>
<%
  session.setAttribute("userName",userName);
  session.removeAttribute("authenticated");
  session.removeAttribute("msg");
  //session.removeAttribute("username");
%>
</html>
