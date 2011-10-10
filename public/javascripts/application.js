// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function sync_now( url, to_path ){
  $("#sync_auto_loader").show();
  $.ajax({
     type: "GET",
     cache: false,
     url: url,
     success: function(result){
       $("#sync_auto_loader").hide();
       if (result == "OK"){
         location.href = to_path;
       }
       setTimeout("sync_now()",1000 * 30);
     }
  });
}
