<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html" %>
<html>
<head>
	<%@include file="/commons/include/get.jsp" %>
	<title><spr:message code="personScript"/><spr:message code="operator.selector"/></title>
</head>
<body>
	<div position="center" id="framecenter"> 
        <div class="panel">
		<div class="panel-top">
			<div class="tbar-title">
				<span class="tbar-label"><spr:message code="personScript"/><spr:message code="operator.selector"/></span>
			</div>
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="group"><a class="link search" id="btnSearch"><spr:message code="menu.button.search"/></a></div>
					<div class="l-bar-separator"></div>
				</div>	
			</div>
			<div class="panel-search">
				<form id="searchForm" method="post" action="selector.ht">
					<div class="row">
						<span class="label"><spr:message code="personScript.className"/>:</span><input type="text" name="Q_className_SL"  class="inputText" value="${param['Q_className_SL']}"/>
						<span class="label"><spr:message code="personScript.methodName"/>:</span><input type="text" name="Q_methodName_SL"  class="inputText" value="${param['Q_methodName_SL']}"/>
						<span class="label"><spr:message code="personScript.methodDesc"/>:</span><input type="text" name="Q_methodDesc_SL"  class="inputText" value="${param['Q_methodDesc_SL']}"/>
						<span class="label"><spr:message code="personScript.enable"/>:</span>
						<select name="Q_enable_L" class="select" style="width:60px;" value="${param['Q_enable_L']}">
							<option value=""><spr:message code="search.select.all"/></option>
							<option value="0" <c:if test="${param['Q_enable_L'] == 0}">selected</c:if>><spr:message code="yes"/></option>
							<option value="1" <c:if test="${param['Q_enable_L'] == 1}">selected</c:if>><spr:message code="no"/></option>
						</select>
					</div>
				</form>
			</div>
		</div>
		<div class="panel-body">
	    	<c:set var="checkAll">
				<input type="checkbox" id="chkall"/>
			</c:set>
		    <display:table name="personScriptList" id="personScriptItem" requestURI="selector.ht" sort="external" cellpadding="1" cellspacing="1" class="table-grid">
				<display:column title="${checkAll}" media="html" style="width:30px;">
			  		<input type="radio"" class="pk" name="id" value="${personScriptItem.id}" methodDesc="${personScriptItem.methodDesc}"/>
				</display:column>
				<display:column property="methodName" titleKey="personScript.methodName" sortable="true"  sortName="METHOD_NAME"></display:column>
				<display:column property="methodDesc" titleKey="personScript.methodDesc" maxLength="80"></display:column>
				<display:column property="className" titleKey="personScript.className" sortable="true" sortName="CLASS_NAME" maxLength="80"></display:column>
				<display:column property="classInsName" titleKey="personScript.classInsName" sortable="true" sortName="CLASS_INS_NAME"></display:column>
				<display:column titleKey="personScript.enable" sortable="true" sortName="enable">
					<c:choose>
						<c:when test="${personScriptItem.enable eq 0}"><span class="green"><spr:message code="yes"/></span></c:when>
						<c:when test="${personScriptItem.enable eq 1}"><span class="red"><spr:message code="no"/></span></c:when>
					</c:choose>
				</display:column>
			</display:table>
			<sf:paging tableId="personScriptItem"/>
		</div>
	</div>
</body>
</html>


