
<%@ page import="mbds.models.User" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="principal">
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
	<h1 class="page-header">Utilisateur disponible</h1>
	<div class="row placeholders">
		<div class="col-md-12">

			<table class="table table-hover table-bordered">
				<thead>
				<tr>
					<th>Login</th>
					<th>Email</th>
					<th>Tel</th>
					<th>Op&eacute;ration</th>
				</tr>
				</thead>
				<tbody>
                    <g:each in="${userInstanceList}" status="i" var="userInstance">
                        <tr>
                            <td>
                                ${userInstance.username}
                            </td>
                            <td>
                                ${userInstance.emailUser}
                            </td>
                            <td>
                                ${userInstance.tel}
                            </td>
                            <td>
                                <g:link action="edit" id="${userInstance.id}" controller="user">
                                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                </g:link>

                                &nbsp; &nbsp; &nbsp;
                                <sec:ifAnyGranted roles="ROLE_ADMIN">
                                    <a href="#" id="${userInstance?.id}" class="deleteUser">
                                        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                    </a>
                                </sec:ifAnyGranted>

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
        <div class="col-md-3">
            <g:render template="/templateUtile/bootstrapDialog"/>
        </div>

        <div  class="col-md-6">
            <input name="successInfo"  value="${flash.infoOperation}" type="hidden" class="form-control" id="successInfo">
            <input name="natureInfo"  value="${flash.natureInfo}" type="hidden" class="form-control" id="natureInfo">
        </div>

        <div class="col-md-3">
            <g:render template="/templateUtile/bootstrapDialogDelete"/>
        </div>

    </div>

    <g:javascript>

        //messageSuccessFulCreation("Utilisateur supprimé", "Impossible de supprimer cet utilisateur");
        $("#headerDialogInfo").addClass("btn-success");
        if($("#natureInfo").val()=="update")
        {
            $("#actionUserForm").val("Modifier");
            $("#contentMessageModal").text("Utilisateur modifé");

            if($("#successInfo").val()=="ok")
            {

                $("#modalSuccesSave").modal("show");
            }else if($("#successInfo").val()=="ko"){
                $("#contentMessageModal").text("Impossible de modifier cet utilisateur");
                $("#modalSuccesSave").modal("show");
            }
        }else if($("#natureInfo").val()=="delete")
        {
            $("#contentMessageModal").text("Utilisateur supprimé");
            if($("#successInfo").val()=="ok")
            {
                $("#modalSuccesSave").modal("show");
            }else if($("#successInfo").val()=="ko"){
                $("#contentMessageModal").text("Impossible de supprimer cet utilisateur");
                $("#modalSuccesSave").modal("show");
            }
        }

        $(".deleteUser").click(function(){
            //console.log("see " + $(this).attr("id"));
            var idElement = $(this).attr("id");
            //messageSuccessFulCreation("Voulez vous supprimer ce groupe", "");
            $("#headerDialogInfoD").addClass("btn-danger");
            $("#contentMessageModalD").html('<input value="'+idElement+'"class="hidden" name="valueToRemove"/> Voulez vous supprimer cet utilisateur');
            $('#modalSuccesSaveD').modal('show');
        });

    </g:javascript>
	</body>
</html>
