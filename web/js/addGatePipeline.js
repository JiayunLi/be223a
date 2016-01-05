/**
 * Created by jiayunli on 15/11/29.
 */
$(document).ready(function() {
    var dialog =[];

    dialog = $("#dialog-gate").dialog({
        autoOpen: false,
        height: 300,
        width: 350,
        modal: true
    });
    function clearForm(){

        //  document.getElementById("databaseName").value="";
       // document.getElementById("userName").value="";
        //   document.getElementById("dbUserName").value="";
        //   document.getElementById("tableName").value="";
        //   document.getElementById("password").value="";
    }
    $( "#gateImport" ).button().on( "click", function() {
        dialog.dialog( "open" );
    });
    $("#dialogSubmit").button().on("click",function(){
        var userName = $("#userName").val();
        var pipelineName = $("#pipelineName").val();
        var pipeline= document.getElementById("fileUpload");
       // var pipelinePath = pipeline.getAsBinary();
        //var pipeline = file.value;
        var pipelineDescription = $("#description").val();
        $("#gate-table tbody").append("<tr> <td>" + pipelineName + "</td>" + "<td>" + pipelineDescription + "</td>" + "<td>" + pipelinePath + "</td>" + " </tr>");
        $.post('servlet/ImportGate',{userName: userName, pipelineName: pipelineName, pipelinePath: pipelinePath, pipelineDescription: pipelineDescription}, function(responseText){

            $('#gatemsg').text(responseText);
        });
        clearForm();
       dialog.dialog("close");

    });
    $("#dialogClose").button().on("click",function(){
        clearForm();
        dialog.dialog("close");
    });
});