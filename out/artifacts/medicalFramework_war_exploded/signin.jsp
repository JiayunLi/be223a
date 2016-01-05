<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="lib/favicon.ico">

  <title>Sign In</title>

  <!-- Bootstrap core CSS -->
  <link href="lib/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="signin.css" rel="stylesheet">

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
      <div class="navbar-brand" style="color: white">Medical Dashboard</div>
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

  <form class="form-signin" method="post" action="signinAuth.jsp">
    <h2 class="form-signin-heading">Please sign in</h2>
    <label for="inputEmail" class="sr-only">Email address</label>
    <input type="text" id="inputEmail" name="nameOrMail" class="form-control" placeholder="Email address/User Name" required autofocus>
    <label for="inputPassword"  class="sr-only">Password</label>
    <input type="password" id="inputPassword" name="password" class="form-control" placeholder="Password" required>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
    <div class="forgotPWD">
      <a href="sendPWDEmail.jsp">Forgot you password?</a>
    </div>
  </form>
  <div class="message">
    <%
      String msg=(String)session.getAttribute("msg");
      if(msg!=null){
        if(msg.equals("NoActivated")){
          session.removeAttribute("msg");
          out.println("Your account hasn't been activated. Please use the link in the Email to activate. ");%>
    <a href="sendActivateEmail.jsp">Send Activation Email Again?</a>
    <%
        }else if(msg.equals("WrongPWD")){
          session.removeAttribute("msg");
          out.println("Invalid password or user name or Email address, please try again");
        }else if(msg.equals("Noreg")){
          session.removeAttribute("msg");
          out.println("User name or Email address not registered, please ");%>
    <a href="signup.jsp">Sign Up</a>
    <%
        }
      }
    %>
  </div>

</div> <!-- /container -->


<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="lib/ie10-viewport-bug-workaround.js"></script>
</body>
</html>
