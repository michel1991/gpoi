<%@ page import="mbds.models.Groupe" %>

		<div class="form-group">
			<label class="control-label col-md-3" for="nom">Nom*</label>
			<div class="col-md-6">
				<input name="nom" required="" value="${groupeInstance?.nom}" type="text" class="form-control" id="nom" placeholder="Nom du groupe">
            </div>

			<g:hasErrors bean="${groupeInstance}" field="nom">
				<div class="errors col-md-3">
					<g:renderErrors bean="${groupeInstance}" field="nom" as="list" />
				</div>
			</g:hasErrors>
		</div>

        <div class="form-group">
            <label class="control-label col-md-3" for="imageUpload">PHOTO*</label>
            <div class="col-md-6">
                <input id="imageUpload" type="file" name="imageUpload" class="upload" style="" onchange="readImagesAndPreview(this.files);"/>
            </div>
        </div>

        <div class="form-group hidden" id="divShowImage">
            <div class="col-md-offset-3 col-md-5">
                <g:if test="${!groupeInstance?.image}"><%-- null --%>
                    <img id="imageShow" src="" alt="" class="img-rounded img-responsive"/>
                </g:if>
                <g:elseif test="${groupeInstance?.image}"><%-- non null --%>
                    <img id="imageShow" src="${grailsApplication.config.grails.projet.gpoi.server.localisation.images}${groupeInstance?.image?.nom}" alt="" class="img-rounded img-responsive"/>
                </g:elseif>
            </div>
        </div>

        <div class="form-group hidden" id="divImageRemove">
            <div class="col-md-offset-3 col-md-3">
                <button type="button" class="btn" id="deleteImage">Supprimer l'image</button>
            </div>
        </div>

        <div class="form-group " id="divImageUpdateExist">
            <div class="col-md-offset-3 col-md-3">
                <g:if test="${!groupeInstance?.image}"><%-- null --%>
                    <input id="imageVefifUpadte" type="hidden" name="imageVefifUpadte" value=""/>
                </g:if>
                <g:elseif test="${groupeInstance?.image}"><%-- non null --%>
                    <input id="imageVefifUpadte" type="hidden" name="imageVefifUpadte" value="${grailsApplication.config.grails.projet.gpoi.server.folder.image}${groupeInstance?.image?.nom}"/>
                </g:elseif>
            </div>
        </div>


        <div class="form-group">
                <div class="col-md-offset-3 col-md-2">
                    <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" id="actionGroupForm"/>
                </div>
        </div>







