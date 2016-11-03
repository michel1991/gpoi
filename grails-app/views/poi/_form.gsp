<%@ page import="mbds.models.Poi" %>

                <div class="form-group">
                    <label class="control-label col-md-3" for="nom">Nom*</label>
                    <div class="col-md-6">
                        <input name="nom" required="" maxlength="200" value="${poiInstance?.nom}" type="text" class="form-control" id="nom" placeholder="NOM POI">
                    </div>

                    <g:hasErrors bean="${poiInstance}" field="nom">
                        <div class="errors col-md-2">
                            <g:renderErrors bean="${poiInstance}" field="nom" as="list" />
                        </div>
                    </g:hasErrors>
                </div>

                <div class="form-group">
                    <label class="control-label col-md-3" for="adresse">Adresse*</label>
                    <div class="col-md-6">
                        <input name="adresse" required="" maxlength="200" value="${poiInstance?.adresse}" type="text" class="form-control" id="adresse" placeholder="Adresse">
                    </div>

                    <g:hasErrors bean="${poiInstance}" field="adresse">
                        <div class="errors col-md-2">
                            <g:renderErrors bean="${poiInstance}" field="adresse" as="list" />
                        </div>
                    </g:hasErrors>
                </div>

                <div class="form-group">
                    <label class="control-label col-md-3" for="tel">Tel*</label>
                    <div class="col-md-6">
                        <input name="tel" required=""  value="${poiInstance?.tel}" type="tel" class="form-control" id="tel" placeholder="Tel">
                    </div>

                    <g:hasErrors bean="${poiInstance}" field="tel">
                        <div class="errors col-md-2">
                            <g:renderErrors bean="${poiInstance}" field="tel" as="list" />
                        </div>
                    </g:hasErrors>
                </div>

                <div class="form-group">
                    <label class="control-label col-md-3" for="latitude"><g:message code="poi.latitude.label" default="Latitude" />*</label>
                    <div class="col-md-6">
                        <input disabled name="latitude" required=""  value="${poiInstance?.latitude}" type="text" class="form-control" id="latitude" placeholder="Latitude">
                    </div>

                    <g:hasErrors bean="${poiInstance}" field="latitude">
                        <div class="errors col-md-2">
                            <g:renderErrors bean="${poiInstance}" field="latitude" as="list" />
                        </div>
                    </g:hasErrors>
                </div>

                <div class="form-group">
                    <label class="control-label col-md-3" for="longitude"><g:message code="poi.longitude.label" default="Longitude" />*</label>
                    <div class="col-md-6">
                        <input disabled name="longitude" required="required"  value="${poiInstance?.longitude}" type="text" class="form-control" id="longitude" placeholder="Longitude">
                    </div>

                    <g:hasErrors bean="${poiInstance}" field="longitude">
                        <div class="errors col-md-2">
                            <g:renderErrors bean="${poiInstance}" field="longitude" as="list" />
                        </div>
                    </g:hasErrors>
                </div>

                <div class="form-group">
                    <label class="control-label col-md-3" for="groupe_id"><g:message code="poi.groupe.label" default="Groupe" />*</label>
                    <div class="col-md-6">
                        <select id="groupe_id" name="groupe_id" multiple="multiple" class="form-control">
                            <g:each in="${mbds.models.Groupe.list()}" var="groupe">
                                <option value="${groupe.getId()}">${groupe.nom}</option>
                            </g:each>
                        </select>

                    </div>

                    <g:hasErrors bean="${poiInstance}" field="groupe">
                        <div class="errors col-md-2">
                            <g:renderErrors bean="${poiInstance}" field="groupe" as="list" />
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
                    <div class="col-md-offset-3 col-md-6">
                        <g:if test="${!poiInstance?.image}"><%-- null --%>
                            <img id="imageShow" src="" alt="" class="img-rounded img-responsive"/>
                        </g:if>
                        <g:elseif test="${poiInstance?.image}"><%-- non null --%>
                            <img id="imageShow" src="${grailsApplication.config.grails.projet.gpoi.server.localisation.images}${poiInstance?.image?.nom}" alt="" class="img-rounded img-responsive"/>
                        </g:elseif>
                        <%--<img id="imageShow" src="" alt="" class="img-rounded img-responsive"/>--%>
                    </div>
                </div>

                <div class="form-group hidden" id="divImageRemove">
                    <div class="col-md-offset-3 col-md-6">
                        <button type="button" class="btn" id="deleteImage">Supprimer l'image</button>
                    </div>
                </div>

                <div class="form-group " id="divImageUpdateExist">
                    <div class="col-md-offset-3 col-md-3">
                        <g:if test="${!poiInstance?.image}"><%-- null --%>
                            <input id="imageVefifUpadte" type="hidden" name="imageVefifUpadte" value=""/>
                        </g:if>
                        <g:elseif test="${poiInstance?.image}"><%-- non null --%>
                            <input id="imageVefifUpadte" type="hidden" name="imageVefifUpadte" value="${grailsApplication.config.grails.projet.gpoi.server.folder.image}${poiInstance?.image?.nom}"/>
                        </g:elseif>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-md-offset-3 col-md-2">
                        <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" id="actionGroupForm"/>
                    </div>
                </div>

                <div class="col-md-offset-3 col-md-2 hidden">
                    <input name="locationPoi"  value="" type="hidden" class="form-control" id="locationPoi">
                </div>




