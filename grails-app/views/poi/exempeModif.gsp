<%--
  Created by IntelliJ IDEA.
  User: michel
  Date: 02/11/2016
  Time: 16:26
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <asset:stylesheet src="application.css"/>
    <asset:javascript src="application.js"/>
    <r:require modules="bootstrap"/>
    <r:require modules="font-awesome"/>
    <link rel="stylesheet" href="http://jumpinjackie.github.io/bootstrap-viewer-template/assets/css/ol.css" />
    <style type="text/css">

    body { overflow: hidden; }

    .navbar-offset { margin-top: 50px; }
    #map { position: absolute; top: 50px; bottom: 0px; left: 0px; right: 0px; }
    #map .ol-zoom { font-size: 1.2em; }

    .zoom-top-opened-sidebar { margin-top: 5px; }
    .zoom-top-collapsed { margin-top: 45px; }

    .mini-submenu{
        display:none;
        background-color: rgba(255, 255, 255, 0.46);
        border: 1px solid rgba(0, 0, 0, 0.9);
        border-radius: 4px;
        padding: 9px;
        /*position: relative;*/
        width: 42px;
        text-align: center;
    }

    .mini-submenu-left {
        position: absolute;
        top: 60px;
        left: .5em;
        z-index: 40;
    }

    #map { z-index: 35; }

    .sidebar { z-index: 45; }

    .main-row { position: relative; top: 0; }

    .mini-submenu:hover{
        cursor: pointer;
    }

    .slide-submenu{
        background: rgba(0, 0, 0, 0.45);
        display: inline-block;
        padding: 0 8px;
        border-radius: 4px;
        cursor: pointer;
    }

    </style>


    <script type="text/javascript" src="http://jumpinjackie.github.io/bootstrap-viewer-template/assets/js/ol.js"></script>
    <script type="text/javascript">

        function applyMargins() {
            var leftToggler = $(".mini-submenu-left");
            if (leftToggler.is(":visible")) {
                $("#map .ol-zoom")
                        .css("margin-left", 0)
                        .removeClass("zoom-top-opened-sidebar")
                        .addClass("zoom-top-collapsed");
            } else {
                $("#map .ol-zoom")
                        .css("margin-left", $(".sidebar-left").width())
                        .removeClass("zoom-top-opened-sidebar")
                        .removeClass("zoom-top-collapsed");
            }
        }

        function isConstrained() {
            return $(".sidebar").width() == $(window).width();
        }

        function applyInitialUIState() {
            if (isConstrained()) {
                $(".sidebar-left .sidebar-body").fadeOut('slide');
                $('.mini-submenu-left').fadeIn();
            }
        }

        $(function(){
            $('.sidebar-left .slide-submenu').on('click',function() {
                var thisEl = $(this);
                thisEl.closest('.sidebar-body').fadeOut('slide',function(){
                    $('.mini-submenu-left').fadeIn();
                    applyMargins();
                });
            });

            $('.mini-submenu-left').on('click',function() {
                var thisEl = $(this);
                $('.sidebar-left .sidebar-body').toggle('slide');
                thisEl.hide();
                applyMargins();
            });

            $(window).on("resize", applyMargins);

            var map = new ol.Map({
                target: "map",
                layers: [
                    new ol.layer.Tile({
                        source: new ol.source.OSM()
                    })
                ],
                view: new ol.View({
                    center: [0, 0],
                    zoom: 2
                })
            });
            applyInitialUIState();
            applyMargins();
        });
    </script>
</head>

<body>
<div class="container">
    <nav class="navbar navbar-fixed-top navbar-default" role="navigation">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Map Viewer (2-column layout)</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">Link</a></li>
                    <li><a href="#">Link</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Another action</a></li>
                            <li><a href="#">Something else here</a></li>
                            <li class="divider"></li>
                            <li><a href="#">Separated link</a></li>
                            <li class="divider"></li>
                            <li><a href="#">One more separated link</a></li>
                        </ul>
                    </li>
                </ul>
                <form class="navbar-form navbar-left" role="search">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="Search">
                    </div>
                    <button type="submit" class="btn btn-default">Submit</button>
                </form>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#">Link</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Another action</a></li>
                            <li><a href="#">Something else here</a></li>
                            <li class="divider"></li>
                            <li><a href="#">Separated link</a></li>
                        </ul>
                    </li>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
</nav>
<div class="navbar-offset"></div>
<div id="map">
</div>
<div class="row main-row">
    <div class="col-sm-4 col-md-3 sidebar sidebar-left pull-left">
        <div class="panel-group sidebar-body" id="accordion-left">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" href="#layers">
                            <i class="fa fa-list-alt"></i>
                            Layers
                        </a>
                        <span class="pull-right slide-submenu">
                            <i class="fa fa-chevron-left"></i>
                        </span>
                    </h4>
                </div>
                <div id="layers" class="panel-collapse collapse in">
                    <div class="panel-body list-group">
                        <a href="#" class="list-group-item">
                            <i class="fa fa-globe"></i> Open Street Map
                        </a>
                        <a href="#" class="list-group-item">
                            <i class="fa fa-globe"></i> Bing
                        </a>
                        <a href="#" class="list-group-item">
                            <i class="fa fa-globe"></i> WMS
                        </a>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" href="#properties">
                            <i class="fa fa-list-alt"></i>
                            Properties
                        </a>
                    </h4>
                </div>
                <div id="properties" class="panel-collapse collapse in">
                    <div class="panel-body">
                        <p>
                            Lorem ipsum dolor sit amet, vel an wisi propriae. Sea ut graece gloriatur. Per ei quando dicant vivendum. An insolens appellantur eos, doctus convenire vis et, at solet aeterno intellegebat qui.
                        </p>
                        <p>
                            Elitr minimum inciderint qui no. Ne mea quaerendum scriptorem consequuntur. Mel ea nobis discere dignissim, aperiam patrioque ei ius. Stet laboramus eos te, his recteque mnesarchum an, quo id adipisci salutatus. Quas solet inimicus eu per. Sonet conclusionemque id vis.
                        </p>
                        <p>
                            Eam vivendo repudiandae in, ei pri sint probatus. Pri et lorem praesent periculis, dicam singulis ut sed. Omnis patrioque sit ei, vis illud impetus molestiae id. Ex viderer assentior mel, inani liber officiis pro et. Qui ut perfecto repudiandae, per no hinc tation labores.
                        </p>
                        <p>
                            Pro cu scaevola antiopam, cum id inermis salutatus. No duo liber gloriatur. Duo id vitae decore, justo consequat vix et. Sea id tale quot vitae.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="mini-submenu mini-submenu-left pull-left">
    <i class="fa fa-list-alt"></i>
</div>
</body>
</html>