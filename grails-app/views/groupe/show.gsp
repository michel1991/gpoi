
<%@ page import="mbds.models.Groupe" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'groupe.label', default: 'Groupe')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-groupe" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-groupe" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list groupe">
			
				<g:if test="${groupeInstance?.nom}">
				<li class="fieldcontain">
					<span id="nom-label" class="property-label"><g:message code="groupe.nom.label" default="Nom" /></span>
					
						<span class="property-value" aria-labelledby="nom-label"><g:fieldValue bean="${groupeInstance}" field="nom"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${groupeInstance?.image}">
				<li class="fieldcontain">
					<span id="image-label" class="property-label"><g:message code="groupe.image.label" default="Image" /></span>
					
						<span class="property-value" aria-labelledby="image-label"><g:link controller="illustration" action="show" id="${groupeInstance?.image?.id}">${groupeInstance?.image?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${groupeInstance?.user}">
				<li class="fieldcontain">
					<span id="user-label" class="property-label"><g:message code="groupe.user.label" default="User" /></span>
					
						<span class="property-value" aria-labelledby="user-label"><g:link controller="user" action="show" id="${groupeInstance?.user?.id}">${groupeInstance?.user?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${groupeInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="groupe.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${groupeInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${groupeInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="groupe.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${groupeInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${groupeInstance?.pois}">
				<li class="fieldcontain">
					<span id="pois-label" class="property-label"><g:message code="groupe.pois.label" default="Pois" /></span>
					
						<g:each in="${groupeInstance.pois}" var="p">
						<span class="property-value" aria-labelledby="pois-label"><g:link controller="poi" action="show" id="${p.id}">${p?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:groupeInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${groupeInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
