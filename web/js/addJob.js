/**
 * Created by jiayunli on 15/11/18.
 */
$(document).ready(function() {
    var dialog =[];
    var dialog2 =[];
    var annotationType =new Array();
    var count = 0;
    dialog = $("#gate-config").dialog({
        autoOpen: false,
        height: 300,
        width: 350,
        modal: true
    });
    dialog2 = $("#dialog-gateConfig").dialog({
        autoOpen: false,
        height: 250,
        width: 150,
        modal: true
    });

    function clearForm(){
        //  document.getElementById("databaseName").value="";
        document.getElementById("userName").value="";
        //   document.getElementById("dbUserName").value="";
        //   document.getElementById("tableName").value="";
        //   document.getElementById("password").value="";
    }
    $( "#run-gate" ).button().on( "click", function() {
        dialog.dialog( "open" );
    });
    $("#dialogClose").button().on("click",function(){
        clearForm();
        dialog.dialog("close");
    });

    $("#dialogSubmit").button().on("click",function(){

        var pipelineName = $("#pipelineName option:selected").text();
        var docDB = $("#docDB option:selected").text();
        var annotationDB = $("#annotationDB").val();
        var annotationDBUser = $("#annotationDBUser").val();
        var annotationDBPassword = $("#annotationDBPassword").val();
        var userName = $("#userName").val();
        var docDBPassword = $("#docDBPassword").val();
        var annotationTable = $("#annotationTable").val();
        var docUser = $("#docUser").val();
        if(userName!=""){
            document.cookie = userName;
        }else{
            userName = document.cookie.replace("=",'');
        }


        $('#annotationType :checked').each(function() {
           annotationType.push($(this).val());
           // return $(this).val();
        });
        var enter = false;
        //var i=0;
        $.getJSON('servlet/GateServlet',{userName: userName,docUser: docUser,annotationTable: annotationTable,docDBPassword: docDBPassword,pipelineName: pipelineName,annotationType: annotationType.toString(), annotationDB: annotationDB,docDB: docDB,annotationDBUser:  annotationDBUser,annotationDBPassword: annotationDBPassword}, function checkProgress(responsetext) {

              var totalNum = parseInt(responsetext.total);
              var docDBName = docDB.split(".")[0];
              var docDBTable = docDB.split(".")[1];
              var threadId = parseInt (responsetext.threadId);
              var currentId = 0;
           // i++;
            //$("div #systemStatus tbody").text(i);
            if(!enter){
                enter = true;
                $('#systemStatus tbody ').append('<tr> <td>' + threadId + '</td>' + '<td>' + docDBName + '</td>' + '<td>' + docDBTable + '</td>' + '<td>' + "<div id ='" + threadId + "'" + ">" + "</div>" + "</td>");
              //  var tr =  document.createElement('tr');

              //  tr.innerHTML = "";
              //  document.getElementById('#systemStatus tbody').appendChild(td);
             //  var div = document.createElement("div");
               // div.id = String.valueOf(threadId);
              //  document.getElementById("#systemStatus tbody").appendChild(div);

            }
            //$("#systemStatus tbody").append(totalNum);
                //$("#systemStatus tbody").text("100%");
                // $("#systemStatus tbody #" +count).text("100%");
                       $.post('servlet/GateProcessListener', {threadId:threadId},function (progress) {
                           // $("div #currentStatus ").text(i);
                            currentId = parseInt(progress);
                        //    var result = (currentId/totalNum).
                            var percentage = (currentId/totalNum)*100;

                          $("div #"+ threadId).text(percentage.toPrecision(4) + "%");
                       //    $("div #"+ threadId).text(progress);
                        //   document.getElementById('<%= DivControl.ClientID %>')
                          // i++;
                           // $("div #currentStatus ").text(i);
                           //$("#gate-table tbody").text("processsing " + "doc " + progress);
                       });
                  if(currentId <= totalNum){

                       setTimeout(function(){checkProgress(responsetext)},1000);

                   }
           // setTimeout(function () {checkProgress(responsetext)}, 1000);
           // setTimeout(function() {checkProgress(responsetext)},1000);
            // $("progress .bar").width(progress);
        });
       // count++;
        clearForm();
        dialog.dialog("close");});

});