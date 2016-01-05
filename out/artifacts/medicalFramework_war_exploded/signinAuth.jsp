<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/2
  Time: 下午11:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="loginModule.Registration"%>
<%@ page import="loginModule.User"%>
<%@ page import="java.sql.SQLException" %>

<html>
<head>
    <title></title>
</head>
<body>
<%
  String nameorMail=request.getParameter("nameOrMail");
  String passwordU=request.getParameter("password");
  if(nameorMail.equals("")||passwordU.equals("")){
    response.sendRedirect("index.jsp");
  }else{
    Registration registration=new Registration();
    User user= null;
    try {
      user = registration.getUserInfo(nameorMail);
    } catch (SQLException e) {
      e.printStackTrace();
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    if(user!=null){
      if((user.getPassword()).equals(passwordU)){
        if(user.isActivated()){
          //  out.print("Welcome "+user.getUserName());
          session.setAttribute("userName",user.getUserName());
          session.setAttribute("login","true");
          response.sendRedirect("dashboard.jsp");
        }else{
          session.setAttribute("msg","NoActivated");
          response.sendRedirect("signin.jsp");
          //  out.print("Your account is not activated, please check your mailbox "+user.getEmail());
        }
      }else{
        session.setAttribute("msg","WrongPWD");
        response.sendRedirect("signin.jsp");
        //  out.print("Invalid password, try again!");
      }%>

<% }else{
  session.setAttribute("msg","Noreg");
  response.sendRedirect("signin.jsp");
  //out.print("UserName or Email address not exist. Please try again!");
}
  }
%>
</body>
</html>
