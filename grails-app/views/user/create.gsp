<%@ page import="mbds.models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="principal">
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
    <title>
        <g:message code="default.create.label" args="[entityName]" />
    </title>
</head>
<body>
<h1 class="page-header"> Cr&eacute;er utilisateur</h1>
    <div class="row placeholders">
        <div class="col-md-6">
            <g:form url="[resource:userInstance, action:'save']" class="form-horizontal">
                <g:render template="form"/>

            </g:form>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">

            <!-- Modal -->
            <div class="modal fade" id="modalSuccesSave" tabindex="-1" role="dialog" aria-labelledby="modalSuccesSaveLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="modalSuccesSaveLabel">INFORMATION</h4>
                        </div>
                        <div class="modal-body" id="contentMessageModal">
                            Utilisateur ajout&eacute;
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div  class="col-md-3">
            <input name="successCreation"  value="${flash.successSave}" type="hidden" class="form-control" id="successCreation">
        </div>

    </div>

<g:javascript>
    if($("#successCreation").val()=="ok")
    {
        $("#modalSuccesSave").modal("show");
    }else if($("#successCreation").val()=="ko"){
        $("#contentMessageModal").text("Impossible d'ajouter cet utilisateur");
        $("#modalSuccesSave").modal("show");
    }
</g:javascript>

</body>
</html>
