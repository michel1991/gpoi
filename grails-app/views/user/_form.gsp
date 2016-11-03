<%@ page import="mbds.models.User" %>

			<div class="form-group">
				<label class="control-label col-md-3" for="username">Login*</label>
				<div class="col-md-6">
					<input name="username" required="" value="${userInstance?.username}" type="text" class="form-control" id="username" placeholder="Login">
				</div>

                <g:hasErrors bean="${userInstance}" field="username">
                    <div class="errors col-md-3">
                        <g:renderErrors bean="${userInstance}" field="username" as="list" />
                    </div>
                </g:hasErrors>
			</div>

			<div class="form-group">
				<label class="control-label col-md-3" for="password">Mot de passe*</label>
				<div class="col-md-6">
					<input name="password" minlength="4" required="" value="" type="password" class="form-control" id="password" placeholder="Mot de passe">

                </div>
                <g:hasErrors bean="${userInstance}" field="password">
                    <div class="errors col-md-3">
                        <g:renderErrors bean="${userInstance}" field="password" as="list" />
                    </div>
                </g:hasErrors>
			</div>

            <div class="form-group">
                <label class="control-label col-md-3" for="confirmPassword">Confirmation*</label>
                <div class="col-md-6">
                    <input name="confirmPassword" minlength="4" required="" value="" type="password" class="form-control" id="confirmPassword" placeholder="Confirmation">
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-md-3" for="tel">Tel*</label>
                <div class="col-md-6">
                    <input name="tel" required="" value="${userInstance?.tel}" type="tel" class="form-control" id="tel" placeholder="Téléphone">
                </div>

                <g:hasErrors bean="${userInstance}" field="tel">
                    <g:renderErrors bean="${userInstance}" field="tel" as="list" />

                </g:hasErrors>
            </div>

        <div class="form-group">
            <label class="control-label col-md-3" for="email">Email*</label>
            <div class="col-md-6">
                <input name="emailUser" required="" value="${userInstance?.emailUser}" type="email" class="form-control" id="email" placeholder="email">
            </div>
        </div>


        <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_MODERATOR">
            <div class="form-group">
                <label class="control-label col-md-3" for="email">Activ&eacute;</label>
                <div class="col-md-1">

                    <input type="checkbox" name="enabled" value="${userInstance?.enabled}" id="etatUser">
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-md-3" for="role_id">Role*</label>
                <div class="col-md-6">
                    <g:include action="listeAuthoritiesUtilisateur" controller="role"/>
                </div>
            </div>

            <div class="form-group">
                <div class="col-md-offset-3 col-md-4">
                    <input name="roleIdHide"  value="${rolesCoches}" type="hidden" class="form-control" id="roleIdHide">
                </div>
            </div>

        </sec:ifAnyGranted>

    <div class="form-group">
        <div class="col-md-offset-3 col-md-2">
            <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" id="actionUserForm"/>
        </div>
    </div>


<g:javascript>

    $("#etatUser").val()=="true"?$("#etatUser").prop("checked", true):$("#etatUser").prop("checked", false);
    if(typeof $("#roleIdHide").val() !== "undefined" && $("#roleIdHide").val().length>0)
    {
        var tableauId = $("#roleIdHide").val().split(",");
        var tableau = [];
        for (var i =0; i<tableauId.length; i++)
        {
            tableau.push((tableauId[i]).replace(" ", ""));
        }
        $("#role_id").val(tableau);
    }
</g:javascript>











