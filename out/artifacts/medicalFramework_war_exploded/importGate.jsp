<%@ page import="java.io.InputStream" %>
<%@ page import="connection.Database" %>
<%@ page import="javax.servlet.annotation.MultipartConfig" %>
<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/30
  Time: 上午1:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<%

    String userName = request.getParameter("userName");
    String pipelineName = request.getParameter("pipelineName");
    String description = request.getParameter("description");
    InputStream inputStream = null;
    Part filePart = request.getPart("fileUpload");
    if (filePart != null) {
      inputStream = filePart.getInputStream();
      Database database = new Database();
      database.importGate(userName, pipelineName,description,inputStream);
      response.sendRedirect("gate.jsp");
    //session.setAttribute("status","suc");
   // session.setAttribute("pipelineName",pipelineName);
   // session.setAttribute("description",description);
  }
%>

</body>
</html>
