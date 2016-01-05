<%@ page import="loginModule.User" %>
<%@ page import="loginModule.Registration"%>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/3
  Time: 下午8:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<%String nameOrEmail=(String)request.getParameter("userName");
String randomPassCode=request.getParameter("checkCode");
Registration registration=new Registration();
User user=registration.getUserInfo(nameOrEmail);

if(user.getRandomPassCode().equals(randomPassCode)){
session.setAttribute("userName",nameOrEmail);
session.setAttribute("authenticated","true");
response.sendRedirect("pwdReset.jsp");
}else{
  out.println("<html> <link href=\"signup.css\" rel=\"stylesheet\">");
  out.println("<link href=\"lib/bootstrap.min.css\" rel=\"stylesheet\">");
  out.println("<body>");
  out.println("<nav class=\"navbar navbar-inverse navbar-fixed-top\">\n" +
          "  <div class=\"container-fluid\">\n" +
          "    <div class=\"navbar-header\">\n" +
          "      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#navbar\" aria-expanded=\"false\" aria-controls=\"navbar\">\n" +
          "        <span class=\"sr-only\">Toggle navigation</span>\n" +
          "        <span class=\"icon-bar\"></span>\n" +
          "        <span class=\"icon-bar\"></span>\n" +
          "        <span class=\"icon-bar\"></span>\n" +
          "      </button>\n" +
          "      <div class=\"navbar-brand\" style=\"color: white\">Project name</div>\n" +
          "    </div>\n" +
          "    <div id=\"navbar\" class=\"navbar-collapse collapse\">\n" +
          "      <ul class=\"nav navbar-nav navbar-right\">\n" +
          "        <li><a href=\"index.jsp\">Home</a></li>\n" +
          "        <li><a href=\"#\">Contact</a></li>\n" +
          "        <li><a href=\"#\">Help</a></li>\n" +
          "      </ul>\n" +
          "    </div>\n" +
          "  </div>\n" +
          "</nav>");
  out.print("<div class='pwdAuth'>Something is not right, Please try again! </div>");
  out.print(" ");%>
  <div class='retrieve'><a href="sendPWDEmail.jsp">Send password retrieval Email again?</a>
    </div>
<%
  out.println("</body>");
  out.println("</html>");
}%>
</body>
</html>
