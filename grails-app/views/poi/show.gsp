
<%@ page import="mbds.models.Poi" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'poi.label', default: 'Poi')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-poi" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-poi" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list poi">
			
				<g:if test="${poiInstance?.nom}">
				<li class="fieldcontain">
					<span id="nom-label" class="property-label"><g:message code="poi.nom.label" default="Nom" /></span>
					
						<span class="property-value" aria-labelledby="nom-label"><g:fieldValue bean="${poiInstance}" field="nom"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.adresse}">
				<li class="fieldcontain">
					<span id="adresse-label" class="property-label"><g:message code="poi.adresse.label" default="Adresse" /></span>
					
						<span class="property-value" aria-labelledby="adresse-label"><g:fieldValue bean="${poiInstance}" field="adresse"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.description}">
				<li class="fieldcontain">
					<span id="description-label" class="property-label"><g:message code="poi.description.label" default="Description" /></span>
					
						<span class="property-value" aria-labelledby="description-label"><g:fieldValue bean="${poiInstance}" field="description"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.image}">
				<li class="fieldcontain">
					<span id="image-label" class="property-label"><g:message code="poi.image.label" default="Image" /></span>
					
						<span class="property-value" aria-labelledby="image-label"><g:link controller="illustration" action="show" id="${poiInstance?.image?.id}">${poiInstance?.image?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.tel}">
				<li class="fieldcontain">
					<span id="tel-label" class="property-label"><g:message code="poi.tel.label" default="Tel" /></span>
					
						<span class="property-value" aria-labelledby="tel-label"><g:fieldValue bean="${poiInstance}" field="tel"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.user}">
				<li class="fieldcontain">
					<span id="user-label" class="property-label"><g:message code="poi.user.label" default="User" /></span>
					
						<span class="property-value" aria-labelledby="user-label"><g:link controller="user" action="show" id="${poiInstance?.user?.id}">${poiInstance?.user?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="poi.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${poiInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.groupes}">
				<li class="fieldcontain">
					<span id="groupes-label" class="property-label"><g:message code="poi.groupes.label" default="Groupes" /></span>
					
						<g:each in="${poiInstance.groupes}" var="g">
						<span class="property-value" aria-labelledby="groupes-label"><g:link controller="groupe" action="show" id="${g.id}">${g?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="poi.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${poiInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.latitude}">
				<li class="fieldcontain">
					<span id="latitude-label" class="property-label"><g:message code="poi.latitude.label" default="Latitude" /></span>
					
						<span class="property-value" aria-labelledby="latitude-label"><g:fieldValue bean="${poiInstance}" field="latitude"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${poiInstance?.longitude}">
				<li class="fieldcontain">
					<span id="longitude-label" class="property-label"><g:message code="poi.longitude.label" default="Longitude" /></span>
					
						<span class="property-value" aria-labelledby="longitude-label"><g:fieldValue bean="${poiInstance}" field="longitude"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:poiInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${poiInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
