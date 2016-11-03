<g:each in="${groupes}" var="groupeInstance" status="counter">
    <g:if test="${!groupeInstance?.image}"><%-- null --%>
        <div class="col-xs-6 col-md-3 thumb">
            <a class="thumbnail" href="#">
                <img class="img-responsive" src="http://placehold.it/300x200" alt="">
            </a>
            <div class="caption">
                <h3>${groupeInstance?.nom}</h3>
                <p>
                    <g:link class="btn btn-primary" action="localiserPoiGroupe" id="${groupeInstance?.id}" controller="groupe" data-toggle="tooltip" data-placement="right" title="Plus de détail">
                        Localiser
                    </g:link>
                </p>
            </div>
        </div>
    </g:if>
    <g:elseif test="${groupeInstance?.image}"><%-- non null --%>
        <div class="col-xs-6 col-md-3 thumb">
            <a class="thumbnail" href="#">
                <img id="imageShow" src="${grailsApplication.config.grails.projet.gpoi.server.localisation.images}${groupeInstance?.image?.nom}" alt=""/>
            </a>
            <div class="caption">
                <h3>${groupeInstance?.nom}</h3>
                <p>
                    <g:link class="btn btn-primary" action="localiserPoiGroupe" id="${groupeInstance?.id}" controller="groupe" data-toggle="tooltip" data-placement="right" title="Plus de détail">
                        Localiser
                    </g:link>
                </p>
            </div>
        </div>
    </g:elseif>
</g:each>

