// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require ckeditor/init
//= require jquery_ujs
//= require foundation
//= require highcharts
//= require_tree .
$(function() {
  $(document).foundation();
    $('#global').DataTable({
        "language": {
            "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
        }
    });
	
	$(".nav li.submenu a.item").click(function(e){
		e.preventDefault();
		console.log($(this));
		$(this).parent().children(".subitem").slideToggle();
	});
	
	
	// remove alerts
	setTimeout(function(){
	  $('.alert-box').remove();
	}, 5000);
	
	
	// select students courses
	$( ".grados" ).on( "click", "a", function(e) {
		e.preventDefault();
		var course = $(this).data("course"), link = $(this);;

		if (course != 0){
			var elem = $(this).parent().parent().children("label.course-"+course)
			console.log(elem);
			$.each(elem, function( index, value ) {
				var incheck = $(this).children("input:checkbox");
				if (incheck.is(':checked')) {
					incheck.prop( "checked", false );
					link.removeClass("success");
				}else{
					incheck.prop( "checked", true );
					link.addClass("success");
				}
			});
		}else{
			var eleme = $(this).parent().parent().children("label")
			console.log(eleme);
			$.each(eleme, function( index, value ) {
				var incheck = $(this).children("input:checkbox");
				incheck.prop( "checked", true );
				link.addClass("success");
			});
		}
		
	});
	
	// search student
    $(".student_search").keyup(function(event) {
      var str = $(this).val().toLowerCase();
	  var labels = $(this).parent().parent().children("label");
	  if (str.length > 0){
        labels.hide();
	  }else{
	  	labels.show();
	  }
      labels.find(".student_name").each(function( index ) {
        var txt = $(this).text().toLowerCase();
        if (txt.indexOf(str) >= 0){
          $(this).parent().parent().show();
        }
      });
    });
		$("#alt").click(function(){
			if($(".alerts").css("position") === "absolute"){
				$(".alerts").css({"position":"relative"});
				$(".alerts-info").show();
			}else{
				$(".alerts").css({"position":"absolute"});	
				$(".alerts-info").hide();
			}
		});	
});
