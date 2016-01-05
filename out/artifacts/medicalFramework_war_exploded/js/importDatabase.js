/**
 * Created by jiayunli on 15/11/9.
 */
$(document).ready(function() {
    var dialog;

    dialog = $( "#dialog-form" ).dialog({
        autoOpen: false,
        height: 300,
        width: 350,
        modal: true
    });
    function clearForm(){
        document.getElementById("databaseName").value="";
        //document.getElementById("user").value="";
        document.getElementById("dbUserName").value="";
        document.getElementById("tableName").value="";
        document.getElementById("password").value="";
    }
    $( "#import-database" ).button().on( "click", function() {
        dialog.dialog( "open" );
    });
    $("#dialogClose").button().on("click",function(){
        clearForm();
        dialog.dialog("close");
    });
    $("#dialogSubmit").button().on("click",function(){
        var userName=$('#userName').val();
        var databaseName=$('#databaseName').val();
        var dbUserName=$('#dbUserName').val();
        var password=$('#password').val();
        var tableName=$('#tableName').val();
        $.getJSON('servlet/ImportDatabase',{userName: userName,databaseName:databaseName, dbUserName:dbUserName,password:password,tableName:tableName},function(responseText){
            var status = responseText.type;
            var msg = responseText.message;
            if(status=="suc"){
                $( "#currentDatabase tbody" ).append(
                    msg);
            }else{
                //$("div #messages").text(msg);
                $('#gatemsg').text(
                    msg);
            }

        });

        //  $.get('ActionServlet',{user:username},function(responseText) {
        //   $('#welcometext').text(responseText);
        //  });
        clearForm();
        dialog.dialog("close");});})
