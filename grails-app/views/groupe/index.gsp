
<%@ page import="mbds.models.Groupe" %>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="principal">
	<g:set var="entityName" value="${message(code: 'groupe.label', default: 'Groupe')}" />
	<title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
<h1 class="page-header">Groupe disponible</h1>
<div class="row placeholders">
	<div class="col-md-12">

		<table class="table table-hover table-bordered">
			<thead>
			<tr>
				<th>Nom</th>
				<th>Date cr&eacute;ation</th>
				<th>Op&eacute;ration</th>
			</tr>
			</thead>
			<tbody>
			<g:each in="${groupeInstanceList}" status="i" var="groupeInstance">
				<tr>
					<td>
						${groupeInstance.nom}
					</td>
					<td>
						${groupeInstance.dateCreated}
					</td>

					<td>
						<sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_MODERATOR">

							<g:link action="edit" id="${groupeInstance?.id}" controller="groupe">
								<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
							</g:link>

							&nbsp; &nbsp; &nbsp;
                            <a href="#" id="${groupeInstance?.id}" class="deleteGroupe">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                            </a>

						</sec:ifAnyGranted>
                        &nbsp; &nbsp; &nbsp;
                        <g:link action="localiserPoiGroupe" id="${groupeInstance?.id}" controller="groupe" data-toggle="tooltip" data-placement="right" title="Plus de détail">
                            <span class="glyphicon glyphicon-map-marker" aria-hidden="true"></span>
                        </g:link>

					</td>
				</tr>
			</g:each>

			</tbody>
		</table>
	</div>
</div>

<div class="row" id="rowForPagination">
	<div class="col-md-4">
		<div class="pagination" id="myPagination">
			<g:paginate total="${groupeInstanceCount ?: 0}" />
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

    <div class="col-md-4 hidden">
        <input name="successRemove"  value="${flash.successRemove}" type="text" class="form-control" id="successCreation">
    </div>

</div>

	<g:javascript>
		$(function(){
            //$('#modalSuccesSave').modal('show');
            messageSuccessFulCreation("Groupe supprimé", "Impossible de supprimer ce groupe");
			$(".deleteGroupe").click(function(){
                //console.log("see " + $(this).attr("id"));
                var idElement = $(this).attr("id");
                $("#headerDialogInfoD").addClass("btn-danger");
                $("#contentMessageModalD").html('<input value="'+idElement+'"class="hidden" name="valueToRemove"/> Voulez vous supprimer ce groupe');
                $('#modalSuccesSaveD').modal('show');
			});

		});
	</g:javascript>
</body>
</html>
