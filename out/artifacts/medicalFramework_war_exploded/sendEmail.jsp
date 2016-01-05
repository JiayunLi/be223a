<%@ page import="loginModule.*" %>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午5:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="loginModule.Registration"%>
<html>
<head>
    <title></title>
</head>
<body>
<%
  String type=(String)session.getAttribute("type");
  String email=request.getParameter("email");
  if(type!=null){
    if(type.equals("activate")){
      Registration registration=new Registration();
      if(registration.sendActivateEmail(email)){
        session.setAttribute("msg","true");
        response.sendRedirect("sendActivateEmail.jsp");
      }else{
        session.setAttribute("msg","false");
        response.sendRedirect("sendActivateEmail.jsp");
      }
    }else if(type.equals("pwd")){
      PwdRetrieval pwdRetrieval=new PwdRetrieval();
      if(pwdRetrieval.sendRetrievalMail(email)){
        session.setAttribute("msg","true");
        response.sendRedirect("sendPWDEmail.jsp");
      }else {
        session.setAttribute("msg", "false");
        response.sendRedirect("sendPWDEmail.jsp");
      }
    }
  }

%>
</body>
</html>