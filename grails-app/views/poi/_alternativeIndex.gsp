<nav class="navbar navbar-inverse navbar-fixed-top" id="myNavBar">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">GPOI</a>
        </div>

        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right" id="mySecondNavBar">
                <li>
                    <a href="#" id="dLabel" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                        Bienvenue ${applicationContext.springSecurityService.currentUser.username}
                        <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu pull-right" aria-labelledby="dLabel">
                        <li>
                            <g:link action="edit" id="${applicationContext.springSecurityService.currentUser.id}" controller="user">
                                <span class="glyphicon glyphicon-user" aria-hidden="true"></span>&nbsp;&nbsp;  Profil
                            </g:link>
                        </li>
                        <li>
                            <g:link controller="logout">
                                <span class="glyphicon glyphicon-log-out" aria-hidden="true"></span>&nbsp; &nbsp; D&eacute;connexion
                            </g:link>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
