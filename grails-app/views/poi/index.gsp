
<%@ page import="mbds.models.Poi" %>
<!DOCTYPE html>
<html>
	<head>
        <meta name="layout" content="principal">
		<g:set var="entityName" value="${message(code: 'poi.label', default: 'Poi')}" />

		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
         <h1 class="page-header">POI disponible</h1>
    <div class="row placeholders">
        <div class="col-md-12">

            <table class="table table-hover table-bordered">
                <thead>
                <tr>
                    <th>Nom</th>
                    <th>Date cr&eacute;ation</th>
                    <th>Op&eacute;ration</th>

                <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_MODERATOR">
                    <th>Par</th>
                </sec:ifAnyGranted>
                </tr>
                </thead>
                <tbody>
                <g:each in="${poiInstanceList}" status="i" var="poiInstance">
                    <tr>
                        <td>
                            ${poiInstance.nom}
                        </td>
                        <td>
                            ${poiInstance.dateCreated}
                        </td>

                        <td>
                            <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_MODERATOR">

                                <g:link action="edit" id="${poiInstance.id}" controller="poi">
                                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                </g:link>

                                &nbsp; &nbsp; &nbsp;
                                <a href="#" id="${poiInstance.id}" class="deletePoi">
                                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                </a>

                            </sec:ifAnyGranted>
                            &nbsp; &nbsp; &nbsp;
                            <g:link action="localiserPoi" id="${poiInstance.id}" controller="poi" data-toggle="tooltip" data-placement="right" title="Localiser">
                                <span class="glyphicon glyphicon-map-marker" aria-hidden="true"></span>
                            </g:link>
                        </td>

                        <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_MODERATOR">
                            <td>
                                ${poiInstance?.user?.username}
                            </td>

                        </sec:ifAnyGranted>


                    </tr>
                </g:each>

                </tbody>
            </table>
        </div>
    </div><!-- fin de la ligne-->
    <div class="row" id="rowForPagination">
        <div class="col-md-4">
            <div class="pagination" id="myPagination">
                <g:paginate total="${poiInstanceCount ?: 0}" />
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4">
            <g:render template="/templateUtile/bootstrapDialogDelete"/>
        </div>

        <div class="col-md-4">
            <g:render template="/templateUtile/bootstrapDialog"/>
        </div>

        <div class="col-md-4">
            <input name="successRemove"  value="${flash.successRemove}" type="hidden" class="form-control" id="successCreation">
        </div>

    </div>

    <g:javascript>
        messageSuccessFulCreation("POI supprimé", "Impossible de supprimer ce POI");
        $(".deletePoi").click(function(){
            console.log("see " + $(this).attr("id"));
            var idElement = $(this).attr("id");
            //messageSuccessFulCreation("Voulez vous supprimer ce groupe", "");
            $("#headerDialogInfoD").addClass("btn-danger");
            $("#contentMessageModalD").html('<input value="'+idElement+'"class="hidden" name="valueToRemove"/> Voulez vous supprimer ce POI');
            $('#modalSuccesSaveD').modal('show');
        });
	</g:javascript>
	</body>
</html>
