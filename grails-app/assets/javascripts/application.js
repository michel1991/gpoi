// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.
//
//= require jquery
//= require_tree .
//= require_self
//= require bootstrap
//= require mapLoad

var imageConserve = "";
var marker;
$(function(){
	if(typeof $("#imageShow").attr("src") !=="undefined")
	{
		//console.log("enter " + ($("#imageShow").attr("src")).length);
		if(($("#imageShow").attr("src")).length>0)
		{
			$("#divShowImage").removeClass("hidden");
			$("#deleteImage").show();
			$("#divImageRemove").removeClass("hidden");
		}else{
			$("#deleteImage").hide();
		}
	}

	imageConserve = typeof $("#imageVefifUpadte").val()!=="undefined"?$("#imageVefifUpadte").val():"";

	$("#deleteImage").click(function ()
	{
		initialise();
	});
	//console.log("length " + document.getElementById("myPagination").childElementCount);

	if(typeof $("#myPagination") !="undefined" && $("#myPagination").children().length==0)
	{
		$("#rowForPagination").remove();
	}


});
function initialise()
{
	$("#imageShow").attr("src", "");
	$("#imageUpload").val("");


	if(imageConserve.length>0)
	{
		var oldVariable = imageConserve+"rmi";
		$("#imageVefifUpadte").val(oldVariable);
	}


	$("#divShowImage").removeClass("hidden").addClass("hidden");
	$("#divImageRemove").removeClass("hidden").addClass("hidden");
}

function readImagesAndPreview(files)
{
	var reader = new FileReader();
	var fichier = files[0];
	var formats =["image/jpeg", "image/jpg", "image/gif", "image/png"];
	//console.log("fichier type " + typeof fichier.type +" size " + typeof fichier.size + " size " + fichier.size +" type " +fichier.type);

	if($.inArray(fichier.type.toLowerCase(),formats)!==-1)
	{
		reader.onload = function(e)
		{
			//console.log("image " + e.target.result);
			$("#imageShow").attr("src", e.target.result);
			$("#deleteImage").show();
			$("#divShowImage").removeClass("hidden");
			$("#divImageRemove").removeClass("hidden");
		};
		reader.readAsDataURL(files[0]);

		//console.log("file " + $("#imageUpload").val());

	}else{
		$("#headerDialogInfo").addClass("btn-danger");
		$("#contentMessageModal").text("format non supporter");
		$('#modalSuccesSave').modal('show');
		initialise();
	}
}

function messageSuccessFulCreation(messageSuccess, messageErreur)
{
	if($("#successCreation").val()=="ok")
	{
		$("#headerDialogInfo").addClass("btn-success");
		$("#contentMessageModal").text(messageSuccess);
		$("#modalSuccesSave").modal("show");
	}else if($("#successCreation").val()=="ko"){
		$("#headerDialogInfo").addClass("btn-info");
		$("#contentMessageModal").text(messageErreur);
		$("#modalSuccesSave").modal("show");
	}
}


function validateLatng()
{
	//$("#latitude").val()=="" || $("#longitude").val()
	//console.log("lat " + document.getElementById("latitude").value + " long " + document.getElementById("longitude").value);
	if( document.getElementById("latitude").value=="" ||  document.getElementById("longitude").value=="")
	{
		$("#headerDialogInfo").addClass("btn-danger");
		$("#contentMessageModal").text("Veuillez renseigner les coordonnées du poi");
		$('#modalSuccesSave').modal('show');
		return false;
	}
	$("#locationPoi").val($("#latitude").val()+";"+$("#longitude").val());
	console.log("information localisation " + $("#locationPoi").val());
	return true;
}


function toggleBounce(event) {
	if (marker.getAnimation() !== null) {
		marker.setAnimation(null);
	} else {
		marker.setAnimation(google.maps.Animation.BOUNCE);
	}

}

function initialiser() {
	latlng = new google.maps.LatLng(latitude, longitude);
	/*if ("geolocation" in navigator)
	 {
	 navigator.geolocation.getCurrentPosition(function(location) {
	 //console.log(location.coords.latitude);
	 //console.log(location.coords.longitude);
	 //console.log(location.coords.accuracy);
	 //latlng = new google.maps.LatLng(46.779231, 6.659431)
	 });
	 }*/
	var options = {
		center: latlng,
		zoom: 19,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};

	carte = new google.maps.Map(document.getElementById("carte"), options);
	marker = new google.maps
		.Marker({
		map: carte,
		draggable: true,
		animation: google.maps.Animation.DROP,
		position: latlng
	});
	marker.addListener('click', toggleBounce(event));
	google.maps.event.addListener(marker, 'dragend', function(event) {
		document.getElementById("latitude").value = event.latLng.lat();
		document.getElementById("longitude").value = event.latLng.lng();
	});

}





