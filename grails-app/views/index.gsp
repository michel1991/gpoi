<%@ page import="mbds.models.Groupe" %>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="principal"/>
	<title>Bienvenue GPOI</title>
</head>
<body>
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Groupes disponibles</h1>
		</div>
        <g:include action="groupeIndex" controller="groupe"/>
	</div>



</body>
</html>
