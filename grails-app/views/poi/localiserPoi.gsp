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
            <h1 class="page-header">POI</h1>
            <div class="row">
                <div class="col-sm-4 col-md-4">
                    <div class="panel-group sidebar-body" id="accordion-left">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a data-toggle="collapse" href="#layers">
                                        <i class="fa fa-list-alt"></i>
                                        INFORMATION
                                    </a>
                                    <span class="pull-right slide-submenu">
                                        <i class="fa fa-chevron-left"></i>
                                    </span>
                                </h4>
                            </div>
                            <div id="layers" class="panel-collapse collapse in">
                                <div class="panel-body">
                                    <div class="thumbnail" id="thumbnailImage">
                                        <img src="" alt="" id="thumbnailImageSrc">
                                        <div class="caption">
                                            <h4 id="nomPoi"></h4>
                                        </div>
                                    </div>
                                    <div class="list-group">
                                        <a href="#" class="list-group-item">
                                            <i class="fa fa-globe"></i> Open Street Map
                                        </a>
                                        <a href="#" class="list-group-item">
                                            <i class="fa fa-globe"></i> Bing
                                        </a>
                                        <a href="#" class="list-group-item">
                                            <i class="fa fa-globe"></i> WMS
                                        </a>
                                    </div>


                                </div>
                            </div>
                        </div><%-- fin du premier pannel --%>
                    </div>
                </div>
                <div class="col-md-8">
                    <div id="cartePoi" style="width:100%; height:70%"></div>
                </div>
            </div>
        </div>
    </div>




</div>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false&key=AIzaSyCPSCdEkcM-vnYlRiN3LsMPV-Onx9kFcck"></script>
<g:javascript>
    var idPoi = "${poiId}", uriL = "${request.getRequestURL()}", dataObjSon=null, folder="${grailsApplication.config.grails.projet.gpoi.server.localisation.images}";
    var position = uriL.lastIndexOf("/");
    var urlForCall = (uriL.substring(0, position+1)+"poiByFormatJson").replace("/grails", "");
    var mapPoi;
    //console.log("test " +idPoi + " url " + urlForCall + " folder " +folder);
    var marker, latlng;
    var latitude =43.701642 , longitude=7.281073;
    $(function(){

    });
    function initializeMapPositionPoi()
    {
        latlng = new google.maps.LatLng(latitude, longitude);
        var options = {
        center: latlng,
        zoom: 19,
        mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        mapPoi = new google.maps.Map(document.getElementById("cartePoi"), options);
        positionPoi();
    }
    // when page is ready, initialize the map!
    google.maps.event.addDomListener(window, 'load', initializeMapPositionPoi);

    var positionPoi = function placementPoi()
    {
        var infowindow =  new google.maps.InfoWindow({
		    content: ''
		});

         $.ajax({
                url : urlForCall,
                type: "POST",
                data : {
                    poi_id:idPoi
                },
                success: function(data, textStatus, jqXHR)
                {
                    if(typeof data !== "undefined" && data!==null)
                    {
                        dataObjSon = JSON.parse(data);
                        var nouvellePosition = new google.maps.LatLng(parseFloat(dataObjSon.latitude), dataObjSon.longitude);
                        var resultat ="", tel="";
                        if((dataObjSon.image).length>0)
                        {
                            resultat =folder+dataObjSon.image;
                            $("#thumbnailImageSrc").attr("src", resultat);

                        }

                        console.log("resultat serveur " + dataObjSon.nom + " resultat " + resultat);
                        var marker = new google.maps.Marker({
						    map: mapPoi,
						    position: nouvellePosition,
						    title : dataObjSon.nom
						   // icon :resultat
						});

                        if(dataObjSon.tel!=null)
                        {
                            tel = dataObjSon.tel;
                        }
                         mapPoi.setCenter(marker.getPosition())
						bindInfoWindow(marker, mapPoi, infowindow, '<b>'+dataObjSon.nom+"</b>" +
						 "<br>"+dataObjSon.addresse+"<br/>"+tel+"<br/>");
						 $("#nomPoi").html(dataObjSon.nom);

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
</g:javascript>
</body>
</html>
