<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/2
  Time: 下午2:38
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
  String userName=request.getParameter("userName");
  String email=request.getParameter("email");
  String password=request.getParameter("password");
  String passwordV=request.getParameter("passwordV");
  if(session.getAttribute("msg")!=null){
    session.removeAttribute("msg");
    //response.setIntHeader('');
  }
  if(userName.equals("")||email.equals("")||password.equals("")||passwordV.equals("")){
      session.setAttribute("msg","incomplete");
      response.sendRedirect("signup.jsp");
      //session.removeAttribute("msg");
    }else{
      Registration registration=new Registration();
      if(!(password.equals(passwordV))){
        session.setAttribute("msg", "wrongPWD");
        response.sendRedirect("signup.jsp");
        // session.removeAttribute("msg");
      }
      else if(!registration.emailCheck(email)){
        session.setAttribute("msg", "wrongEmail");
        response.sendRedirect("signup.jsp");
        // session.removeAttribute("msg");
      }
      else if(!registration.userNameCheck(userName)){
        session.setAttribute("msg", "wrongName");
        response.sendRedirect("signup.jsp");
        // session.removeAttribute("msg");
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
                "     <!-- <form class=\"navbar-form navbar-right\">\n" +
                "        <input type=\"text\" class=\"form-control\" placeholder=\"Search...\">\n" +
                "      </form>-->\n" +
                "    </div>\n" +
                "  </div>\n" +
                "</nav>");
        out.println("<div class='signup'> Congratulations! "+userName+" You have already registered <br>" +
                "Please check your Email "+email+" to activate your account.</div>");
        out.println("</body>");
        out.println("</html>");
        registration.register(userName,email,password);
      }
  }
%>
</body>
</html>
