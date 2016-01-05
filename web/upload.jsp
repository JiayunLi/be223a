<%--
  Created by IntelliJ IDEA.
  User: jiayunli
  Date: 15/11/11
  Time: 下午4:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<html>
<head>
    <title></title>
</head>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
<style>
  .fileupload input {
    position: absolute;
    top: 0;
    right: 0; /* not left, because only the right part of the input seems to
                 be clickable in some browser I can't remember */
    cursor: pointer;
    opacity: 0.0;
    filter: alpha(opacity=0); /* and all the other old opacity stuff you
                                 want to support */
    font-size: 300px; /* wtf, but apparently the most reliable way to make
                         a large part of the input clickable in most browsers */
    height: 200px;
  }
</style>
<div class="fileupload">
  <input type="file" action="hello.jsp"/>
  Upload
</div>

</body>
</html>
