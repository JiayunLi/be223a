<%@ page import="loginModule.User" %>
<%@ page import="loginModule.Registration"%>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午9:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<%
  String userName=(String)session.getAttribute("userName");
  String password=request.getParameter("password");
  String passwordV=request.getParameter("passwordV");
  if(passwordV.equals(password)){
    Registration registration=new Registration();
    User user=registration.getUserInfo(userName);
    registration.pwdUpdate(user,password);
    session.setAttribute("msg","suc");
    session.setAttribute("authenticated","true");
    response.sendRedirect("pwdReset.jsp");
    //out.print("Your password has been changed, please login");
  }else{
    session.setAttribute("msg","wrongPWD");
    session.setAttribute("authenticated","true");
    response.sendRedirect("pwdReset.jsp");
    //out.print("The two passwords are not similar, please confirm again");
  }
%>
</body>
</html>
