/**
 * Created by jiayunli on 15/12/8.
 */
/**
 * Created by jiayunli on 15/12/8.
 */
$(document).ready(function() {
    var ddialog;

    ddialog = $("#delete-gate").dialog({
        autoOpen: false,
        height: 350,
        width: 300,
        modal: true
    });
    $( "#delete" ).button().on( "click", function() {
        ddialog.dialog( "open" );
    });
    $("#ddialogClose").button().on("click",function(){
        // clearForm();
        ddialog.dialog("close");
    });
    $("#ddialogSubmit").button().on("click",function(){
        var userName = $('#loginUser').val();
        var gatepipeline= $("#gatepipeline option:selected").text();
        $.post('servlet/DeleteGate',{userName:userName, gatepipeline: gatepipeline},function(responseText){
            location.reload();
         //   $('#gatemsg').text(responseText);

        });
        ddialog.dialog("close");
    });
});