src = "lib/jquery-ui-gate.js";
$(document).ready(function() {

    $("#saveGateConfig").button().click(function(){
        //alert("button");
        var userName = $("#useName").val();
        var gatePlugins = $("#gate-plugins").val();
        var gateSite = $("#gate-site").val();
        var gateHome = $("#gate-home").val();
        if(userName==null||gatePlugins==null||gateSite==null||gateHome==null){
            //alert("Please complete all required parts!!");
            // document.getElementById("message").innerHTML("Please complete all required parts!!");
            $("div #message ").text("Please complete all required parts!!");
        }else{
            $.post('servlet/GateConfigServlet',{userName: userName,gatePlugins: gatePlugins,gateSite: gateSite,gateHome: gateHome},function(responseText){
                $("div #message ").text(responseText);
            })
        }
    });
});