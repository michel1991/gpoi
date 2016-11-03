<%@ page import="mbds.models.Groupe" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="principal">
    <g:set var="entityName" value="${message(code: 'groupe.label', default: 'Groupe')}" />
    <title><g:message code="default.edit.label" args="[entityName]" /></title>

</head>
<body>
<h1 class="page-header"> Modifier Groupe (Glissez D&eacute;posez les Pois)</h1>
<div class="row placeholders">
    <div class="col-md-5">
        <g:form url="[resource:groupeInstance, action:'update']" class="form-horizontal" enctype="multipart/form-data">
            <g:render template="form"/>

        </g:form>
    </div>
    <div class="col-md-4"><%--fixed--%>
        <div>POIS DISPONIBLES </div>
        <div class="containerPois dropper" id="supprimePois">
            <g:each in="${poisNotGroupe}" var="poi" status="counter">
                <div id="${poi.id}" class="myDivDrap draggable">
                    ${poi.nom}
                </div>
            </g:each>

        </div>
    </div>

    <div class="col-md-3"><%--scrollit--%>
        <div>POIS DU GROUPE</div>
        <div class="containerPois dropper" id="addPois">
            <g:each in="${poisGroupe}" var="poi" status="counter">
                <div id="${poi.id}" class="myDivDrap draggable">
                    ${poi.nom}
                </div>
            </g:each>
        </div>
    </div>
</div><!-- fin d'une ligne separation des colonnes-->


<div class="row">
    <div class="col-md-4">
        <g:render template="/templateUtile/bootstrapDialog"/>
    </div>

    <div  class="col-md-8">
        <div class="row">
            <div class="col-md-4">
                <input name="successUpdate"  value="${flash.successUpdate}" type="hidden" class="form-control" id="successCreation">
            </div>

            <div class="col-md-2">
                <input id="imageDrapDrop" type="hidden" value="${grailsApplication.config.grails.projet.gpoi.server.localisation.images}${grailsApplication.config.grails.image.drap.drop}"/>
            </div>

            <div class="col-md-2">
                <input type="hidden" value="${request.getRequestURL()}" id="myUri"/>
            </div>
        </div>

    </div>
</div>

<g:javascript>
         var keyInfrastructure = "${groupeInstance.id}";
         //console.log("infrastr " + keyInfrastructure)
        var actionGo = "ajouterOuSupprimerUnPoi"
        var dragImg = new Image(); // téléchargement de l'image
        dragImg.src = document.getElementById("imageDrapDrop").value;
        var chaineLocalisation ="", position=0, urlForCall="", glisser="", deposer="";

        (function() {

            var dndHandler =
            {

                draggedElement: null, // Propriété pointant vers l'élément en cours de déplacement
                applyDragEvents: function(element)
                {
                    element.draggable = true;
                    var dndHandler = this; // Cette variable est nécessaire pour que l'événement « dragstart » ci-dessous accède facilement au namespace « dndHandler »
                    element.addEventListener('dragstart', function(e) {
                        dndHandler.draggedElement = e.target; // On sauvegarde l'élément en cours de déplacement
                        //comment console.log("envoyer " + e.target.id);
                        glisser =e.target.parentNode.id;
                        //comment console.log("depart " + glisser);
                        e.dataTransfer.setData('text/plain', e.target.id); // Nécessaire pour Firefox
                    });
                },

                applyDropEvents: function(dropper) {
                    dropper.addEventListener('dragover', function(e) {
                        e.preventDefault(); // On autorise le drop d'éléments
                        //code this.className = 'dropper drop_hover'; // Et on applique le style adéquat à notre zone de drop quand un élément la survole
                    });

                    dropper.addEventListener('dragleave', function() {
                       //code this.className = 'dropper'; // On revient au style de base lorsque l'élément quitte la zone de drop
                    });
                    var dndHandler = this; // Cette variable est nécessaire pour que l'événement « drop » ci-dessous accède facilement au namespace « dndHandler »

                    dropper.addEventListener('drop', function(e) {

                        // comment console.log("reçu " + e.dataTransfer.getData('text/plain') + " parent " +  e.target.id);
                        var target = e.target, draggedElement = dndHandler.draggedElement, // Récupération de l'élément concerné
                        clonedElement = draggedElement.cloneNode(true); // On créé immédiatement le clone de cet élément

                        while (target.className.indexOf('dropper') == -1) { // Cette boucle permet de remonter jusqu'à la zone de drop parente
                            target = target.parentNode;

                        }

                        //code target.className = 'dropper'; // Application du style par défaut
                        //comment console.log(target.nodeValue +" id " + target.id +" verif " + draggedElement.id);
                        var actionGoAjax = target.id, idPoi = draggedElement.id
                        clonedElement = target.appendChild(clonedElement); // Ajout de l'élément cloné à la zone de drop actuelle
                        dndHandler.applyDragEvents(clonedElement); // Nouvelle application des événements qui ont été perdus lors du cloneNode()
                        draggedElement.parentNode.removeChild(draggedElement); // Suppression de l'élément d'origine
                        ajaxAjouterOuSupprimer(glisser,  actionGoAjax,  actionGoAjax, idPoi, keyInfrastructure);

                    });

                }

            };

            var elements = document.querySelectorAll('.draggable'),
                    elementsLen = elements.length;

            for (var i = 0; i < elementsLen; i++) {
                dndHandler.applyDragEvents(elements[i]); // Application des paramètres nécessaires aux éléments déplaçables
            }

            var droppers = document.querySelectorAll('.dropper'),
                    droppersLen = droppers.length;

            for (var i = 0; i < droppersLen; i++) {
                dndHandler.applyDropEvents(droppers[i]); // Application des événements nécessaires aux zones de drop
            }

        })();


        $(function(){

            chaineLocalisation = $("#myUri").val();
            position = chaineLocalisation.lastIndexOf("/");
            urlForCall = chaineLocalisation.substring(0, position+1)+actionGo;

            $("#actionGroupForm").val("Modifier");
            messageSuccessFulCreation("Groupe modifié", "Impossible de modifier ce groupe");

          var dataObjSon = [];
          if( typeof $("#pois").val() !=="undefined" && ($("#pois").val()).length>0)
          {
              //dataObjSon = JSON.parse($("#pois").val());
              var dataObjSon = eval('(' + $("#pois").val() + ')');
              //console.log("taille de la liste " + dataObjSon.length);

              /*for (i in myObject)
              {
                  alert(myObject[i]["name"]);
              }*/
          }
          //var tableauPois = $("#pois").val().split(";");

      });

        function ajaxAjouterOuSupprimer(containerDepart, containerDepartArrive, action, idPoi, idGroupe)
        {
            if(containerDepart!=containerDepartArrive)
            {
                var opertionToExecute =""
                if(action=="supprimePois")
                {
                    opertionToExecute ="ko"
                }else if(action=="addPois")
                {
                    opertionToExecute ="ok"
                }

                if(opertionToExecute.length>0)
                {
                    $.ajax({
                        url : urlForCall.replace("/grails", ""),
                        type: "POST",
                        data : {
                            poi_id:idPoi,
                            groupe_id:idGroupe,
                            op:opertionToExecute
                        },
                        success: function(data, textStatus, jqXHR)
                        {
                            console.log("resultat serveur " + data);
                           //var resultatServeur =  extraireResultat(data.toString());
                           //console.log("resultat serveur **" + resultatServeur);
                        },
                        error: function (jqXHR, textStatus, errorThrown)
                        {

                        }
                    });
                }

            }

        }
</g:javascript>
</body>
</html>
