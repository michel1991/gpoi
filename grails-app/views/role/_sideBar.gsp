
<ul class="nav nav-sidebar">
    <li class="active">
        <g:link controller="bienvenue" action="index">
            <span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;&nbsp;Accueil
        </g:link>

    </li>

</ul><%-- ACCUEIL --%>

    <ul class="nav nav-sidebar">
        <li class="active">
            <a href="#"><i class="fa fa-users" aria-hidden="true"></i>&nbsp;&nbsp; Utilisateur <span class="sr-only">(current)</span></a>
        </li>

        <g:if test="${plusGrand == 'ROLE_ADMIN'}">
            <li>
                <g:link controller="user" action="create">
                    <span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>&nbsp; Cr&eacute;er
                </g:link>

            </li>
        </g:if>

        <li>
            <g:link controller="user" action="index">
                <span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>&nbsp; Visualisation
            </g:link>

        </li>

    </ul>

    <ul class="nav nav-sidebar">
        <li class="active">
            <a href="#"><i class="fa fa-map-marker" aria-hidden="true"></i>&nbsp; &nbsp; Groupe <span class="sr-only">(current)</span></a>
        </li>

        <g:if test="${plusGrand == 'ROLE_ADMIN' || plusGrand == 'ROLE_MODERATOR'}">
            <li>
                <g:link controller="groupe" action="create">
                    <span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>&nbsp; Cr&eacute;er
                </g:link>

            </li>
        </g:if>

        <li>
            <g:link controller="groupe" action="index">
                <span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>&nbsp; Visualisation
            </g:link>

        </li>

    </ul>

    <ul class="nav nav-sidebar">
        <li class="active">
            <a href="#"><i class="fa fa-map-marker" aria-hidden="true"></i> &nbsp; &nbsp; POI<span class="sr-only">(current)</span></a>
        </li>

        <g:if test="${plusGrand == 'ROLE_ADMIN' || plusGrand == 'ROLE_MODERATOR'}">
            <li>
                <g:link controller="poi" action="create">
                    <span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>&nbsp; Cr&eacute;er
                </g:link>

            </li>
        </g:if>

        <li>
            <g:link controller="poi" action="index">
                <span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>&nbsp; Visualisation
            </g:link>

        </li>

    </ul>
