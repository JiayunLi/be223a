/**
 * Created by jiayunli on 15/12/8.
 */
$(document).ready(function() {
    var ddialog;

    ddialog = $("#dialog-delete").dialog({
        autoOpen: false,
        height: 350,
        width: 300,
        modal: true
    });
    $( "#delete-database" ).button().on( "click", function() {
        ddialog.dialog( "open" );
    });
    $("#ddialogClose").button().on("click",function(){
       // clearForm();
        ddialog.dialog("close");
    });
    $("#ddialogSubmit").button().on("click",function(){
        var userName = $('#loginUser').val();
        var docDB = $("#docDB option:selected").text();
        $.post('servlet/DeleteDatabase',{userName:userName, docDB: docDB},function(responseText){
            $("div #messages").text(responseText);

        });
        location.reload();
        ddialog.dialog("close");
    });
});