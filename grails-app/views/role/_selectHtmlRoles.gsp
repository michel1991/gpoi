<%@ page import="mbds.models.Role" %>
<select id="role_id" name="role_id" multiple="multiple" class="form-control" required="required">
    <g:each in="${roles}" var="role">
        <option value="${role.getId()}">${role.authority}</option>
    </g:each>
</select>