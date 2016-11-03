<%@ page import="mbds.models.User" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="principal">

		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title><g:message code="default.edit.label" args="[entityName]" /></title>
	</head>

	<body>
		<h1 class="page-header"> Modifier utilisateur</h1>
    	<div class="row placeholders">
        	<div class="col-md-6">
				<g:form url="[resource:userInstance, action:'update']" class="form-horizontal" method="PUT">
					<g:render template="form"/>
				</g:form>
			</div>
		</div>

        <div class="row">
            <div class="col-md-6">
                <g:render template="/templateUtile/bootstrapDialog"/>
            </div>

            <div  class="col-md-3">
                <input name="successUpdate"  value="${flash.successUpdate}" type="hidden" class="form-control" id="successUpdate">
            </div>
        </div>

    <g:javascript>
        $("#actionUserForm").val("Modifier");
        $("#contentMessageModal").text("Utilisateur modifé");

        if($("#successUpdate").val()=="ok")
        {
            $("#modalSuccesSave").modal("show");
        }else if($("#successUpdate").val()=="ko"){
            $("#contentMessageModal").text("Impossible de modifier cet utilisateur");
            $("#modalSuccesSave").modal("show");
        }
    </g:javascript>
     </body>
</html>

