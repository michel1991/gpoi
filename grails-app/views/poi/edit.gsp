<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr">
<head>

	<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCPSCdEkcM-vnYlRiN3LsMPV-Onx9kFcck" async defer></script>
	<script type="text/javascript">

	</script>
	<asset:stylesheet src="application.css"/>
	<asset:javascript src="application.js"/>
	<ckeditor:resources/>

	<style>
	#barInfoPOI{
		border-right: 1px solid #eee;
		overflow-y: auto; /* Scrollable contents if viewport is shorter than content. */
		padding-left: 10px;

	}
	</style>
</head>
<body  id="bodyMain" onload="initialiser()">
<g:render template="/poi/alternativeIndex"/>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-3 col-md-2 sidebar">
			<g:include action="plusGrandRoleUtilisateur" controller="role"/>
		</div>


		<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<h1 class="page-header"> Cr&eacute;er POI</h1>
			<div class="row">
				<div class="col-md-6" id="barInfoPOI">

					<g:form url="[resource:poiInstance, action:'update']" class="form-horizontal" enctype="multipart/form-data" onsubmit="return validateLatng();">
						<g:render template="form"/>

					</g:form>
				</div>

				<div class="col-md-6">
					<div id="carte" style="width:100%; height:70%"></div>
				</div>
			</div>

			<div class="row">
				<div class="col-md-6">
					<g:render template="/templateUtile/bootstrapDialog"/>
				</div>

				<div  class="col-md-2 hidden">
					<input name="successUpdate"  value="${flash.successUpdate}" type="hidden" class="form-control" id="successCreation">
				</div>


				<div class="col-md-2 hidden">
					<input name="groupeIdHide"  value="${groupeCoches}" type="hidden" class="form-control" id="groupeIdHide">
				</div>

			</div>

		</div>
	</div>




</div>
<g:javascript>
	var marker, carte, latlng;
	var latitude = null, longitude=null; //43.701642, 7.281073
	latitude = document.getElementById("latitude").value!==""?parseFloat(document.getElementById("latitude").value):43.701642
	longitude = document.getElementById("longitude").value!==""?parseFloat(document.getElementById("longitude").value):7.281073

	$(function(){
		if(typeof $("#groupeIdHide").val() !== "undefined" && $("#groupeIdHide").val().length>0)
		{
			var tableauId = $("#groupeIdHide").val().split(",");
			var tableau = [];
			for (var i =0; i<tableauId.length; i++)
			{
				tableau.push((tableauId[i]).replace(" ", ""));
			}
			$("#groupe_id").val(tableau);
		}

		messageSuccessFulCreation("POI modifié", "Impossible de modifier ce POI");
	});



</g:javascript>
</body>
</html>
