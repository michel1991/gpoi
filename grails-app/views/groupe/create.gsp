<%@ page import="mbds.models.Groupe" %>
<!DOCTYPE html>
<html>
	<head>
        <meta name="layout" content="principal">
		<g:set var="entityName" value="${message(code: 'groupe.label', default: 'Groupe')}" />
		<title><g:message code="default.create.label" args="[entityName]" /></title>
	</head>
	<body>
            <h1 class="page-header"> Cr&eacute;er Groupe</h1>

            <div class="row placeholders">
                <div class="col-md-6">
                    <g:form url="[resource:groupeInstance, action:'save']" class="form-horizontal" enctype="multipart/form-data">
                        <g:render template="form"/>

                    </g:form>
                </div>
            </div>

        <div class="row">
            <div class="col-md-6">
                <g:render template="/templateUtile/bootstrapDialog"/>
            </div>

            <div  class="col-md-3">
                <input name="successCreation"  value="${flash.successCreation}" type="hidden" class="form-control" id="successCreation">
            </div>
        </div>

    <g:javascript>

        if($("#successCreation").val()=="ok")
        {
            $("#headerDialogInfo").addClass("btn-success");
            $("#contentMessageModal").text("Groupe ajouté");
            $("#modalSuccesSave").modal("show");
        }else if($("#successCreation").val()=="ko"){
            $("#headerDialogInfo").addClass("btn-info");
            $("#contentMessageModal").text("Impossible d'ajouter ce groupe");
            $("#modalSuccesSave").modal("show");
        }
    </g:javascript>
	</body>
</html>
