<%@ page import="mbds.models.Groupe" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr">
<head>

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
<body  id="bodyMain">
<g:render template="/poi/alternativeIndex"/>
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <g:include action="plusGrandRoleUtilisateur" controller="role"/>
        </div>


        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <h1 class="page-header">POI GROUPE</h1>
            <div class="row">
                <div class="col-md-12">
                    <div id="carteGroupe" style="width:100%; height:70%"></div>
                </div>
            </div>
        </div>
    </div>




</div>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false&key=AIzaSyCPSCdEkcM-vnYlRiN3LsMPV-Onx9kFcck"></script>
<g:javascript>
    var marker, carte, latlng, coords="";
    var latitude = null, longitude=null; //43.701642, 7.281073
    //latitude = document.getElementById("latitude").value!==""?parseFloat(document.getElementById("latitude").value):43.701642
    //longitude = document.getElementById("longitude").value!==""?parseFloat(document.getElementById("longitude").value):7.281073
    latitude = 43.701642;
    longitude =  7.281073;

    var idGroupe = "${groupeId}", uriL = "${request.getRequestURL()}", dataObjSon=null, uriL = "${request.getRequestURL()}", dataObjSon=null, folder="${grailsApplication.config.grails.projet.gpoi.server.localisation.images}";
    var position = uriL.lastIndexOf("/"), mapGroupe, markers = [];;
    var urlForCall = (uriL.substring(0, position+1)+"listePoisGroupeJson").replace("/grails", "");
    //console.log("test " +idGroupe + " url " + urlForCall);
    var latitude =43.701642 , longitude=7.281073;
    $(function(){

    });

    function initializeMapPositionPoiGroupe()
    {
        latlng = new google.maps.LatLng(latitude, longitude);
        var options = {
        center: latlng,
        zoom: 19,
        mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        mapGroupe = new google.maps.Map(document.getElementById("carteGroupe"), options);
        positionGroupePoi();
    }
    google.maps.event.addDomListener(window, 'load', initializeMapPositionPoiGroupe);
   var positionGroupePoi =  function placementPoiGroupe()
    {
        var infowindow =  new google.maps.InfoWindow({
		    content: ''
		});

         $.ajax(
         {
            url : urlForCall,
            type: "POST",
            data : {
                groupe_id:idGroupe
            },
            success: function(data, textStatus, jqXHR)
            {
                if(typeof data !== "undefined" && data!==null)
                {
                    dataObjSon = JSON.parse(data);
                    for(jsonPoi in dataObjSon )
                    {
                        var addition =  parseInt(jsonPoi) + 1
                            //console.log("addition " + addition);
                          if(addition <dataObjSon.length)
                          {

                            coords+=dataObjSon[jsonPoi].latitude+","+dataObjSon[jsonPoi].longitude+"|";
                          }else if(jsonPoi+1>=dataObjSon.length){
                            coords+=dataObjSon[jsonPoi].latitude+","+dataObjSon[jsonPoi].longitude;
                          }
                        //console.log("resultat serveur " + (dataObjSon[jsonPoi].nom));
                        var position = new google.maps.LatLng(parseFloat(dataObjSon[jsonPoi].latitude), dataObjSon[jsonPoi].longitude);
                        var tel="";

                         var marker = new google.maps.Marker({
                            map: mapGroupe,
                            position: position,
                            title : dataObjSon[jsonPoi].nom
                        });
                        markers.push(marker);
                        if(dataObjSon[jsonPoi].tel!=null)
                        {
                            tel = dataObjSon[jsonPoi].tel;
                        }

                    bindInfoWindow(marker, mapGroupe, infowindow, '<b>'+dataObjSon[jsonPoi].nom+"</b>" +
                     "<br>"+dataObjSon[jsonPoi].addresse+"<br/>"+tel+"<br/>");

                    }// fin du for

                    var dataForCenterMap = centerMap(coords);
                    mapGroupe.setCenter(new google.maps.LatLng(dataForCenterMap.lat, dataForCenterMap.long));
                    mapGroupe.setZoom(15);
                    console.log("cord " + dataForCenterMap.lat);
                }

            },
            error: function (jqXHR, textStatus, errorThrown)
            {

            }
        });
    }
    // binds a map marker and infoWindow together on click
	var bindInfoWindow = function(marker, map, infowindow, html) {
	    google.maps.event.addListener(marker, 'click', function() {
	        infowindow.setContent(html);
	        //map.panTo(marker.getPosition())
	        infowindow.open(map, marker);
	    });
	}

	function centerMap(coordonneesLatitudeLong)
	{
	    var filteredtextCoordinatesArray = coordonneesLatitudeLong.split('|');
        centerLatArray = [];
        centerLngArray = [];

        for (i=0 ; i < filteredtextCoordinatesArray.length ; i++)
        {

          var centerCoords = filteredtextCoordinatesArray[i];
          var centerCoordsArray = centerCoords.split(',');

          if (isNaN(Number(centerCoordsArray[0]))) {
          } else {
            centerLatArray.push(Number(centerCoordsArray[0]));
          }

          if (isNaN(Number(centerCoordsArray[1]))) {
          } else {
            centerLngArray.push(Number(centerCoordsArray[1]));
          }

        }

        var centerLatSum = centerLatArray.reduce(function(a, b) { return a + b; });
        var centerLngSum = centerLngArray.reduce(function(a, b) { return a + b; });

        var centerLat = centerLatSum / filteredtextCoordinatesArray.length ;
        var centerLng = centerLngSum / filteredtextCoordinatesArray.length ;


        console.log(centerLat);
        console.log(centerLng);
        return {
                lat:centerLat,
                long:centerLng
               }
	}


</g:javascript>
</body>
</html>
