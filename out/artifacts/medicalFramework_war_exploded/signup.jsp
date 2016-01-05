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

  <title>Sign Up</title>

  <!-- Bootstrap core CSS -->
  <link href="lib/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="signup.css" rel="stylesheet">

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

  <form class="form-signin" action="signupAuth.jsp" method="post">
    <h2 class="form-signin-heading">Sign up Today!</h2>
    <label for="username" class="sr-only">User Name</label>
    <input type="text" id="username" class="form-control" name="userName" placeholder="User Name" required autofocus>
    <label for="inputEmail" class="sr-only">Email address</label>
    <input type="email" id="inputEmail" class="form-control" name="email" placeholder="Email address" required >
    <label for="password" class="sr-only">Password</label>
    <input type="password" id="password" class="form-control" name="password" placeholder="Password" required>
    <label for="confirmPassword" class="sr-only">Confirm Password</label>
    <input type="password" id="confirmPassword"  class="form-control" name="passwordV" placeholder="Confirm Password" required>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Sign Up</button>
  </form>
  <div class="message">
    <%
      String msg=(String)session.getAttribute("msg");
      if(msg!=null){
        if(msg.equals("incomplete")){
            session.removeAttribute("msg");
          out.print("Please complete all required fields!");
        }else if(msg.equals("wrongPWD")){
            session.removeAttribute("msg");
          out.println("Passwords don't match, please try again");
        }else if(msg.equals("wrongEmail")){
            session.removeAttribute("msg");
          out.print("Email address has been registered! Please ");%>
     <!--<button type="button" class="btn btn-lg btn-primary"><a href="signin.jsp" style="text-decoration: none; color: white">Sign in</a></button>-->
    <a href="signin.jsp">Sign in</a>
    <%
        }else if(msg.equals("wrongName")){
            session.removeAttribute("msg");
          out.println("User Name has been registered, please ");%>
          <a href="signin.jsp">Sign in</a>
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
