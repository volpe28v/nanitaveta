// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function sync_now( url, to_path ){
  $("#sync_auto_loader").fadeIn();
  $.ajax({
     type: "GET",
     cache: false,
     url: url,
     success: function(result){
       $("#sync_auto_loader").fadeOut();
       if (result == "OK"){
         location.href = to_path;
       }
       setTimeout('sync_now("' + url + '","' + to_path + '")',1000 * 60);
     }
  });
}
