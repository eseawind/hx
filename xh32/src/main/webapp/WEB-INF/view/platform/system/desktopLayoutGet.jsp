<%@page language="java" pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html"%>
<html>
<head>
	<title><spr:message code="desktopLayout.get.title" /></title>
	<%@include file="/commons/include/getById.jsp" %>
</head>
<body>
	<div class="panel">
			<div class="panel-top">
				<div class="tbar-title">
					<span class="tbar-label"><spr:message code="desktopLayout.get.span" /></span>
				</div>
				<c:if test="${canReturn==0}">
				<div class="panel-toolbar">
					<div class="toolBar">
						<div class="group"><a class="link back" href="list.ht"><span></span><spr:message code="menu.button.back" /></a></div>
					</div>
				</div>
				</c:if>
			</div>
			<div class="panel-body">
						<div class="panel-detail">
							<table class="table-detail" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<th width="20%"><spr:message code="desktopLayout.name" />:</th>
									<td>${desktopLayout.name}</td>
								</tr>
								<tr>
									<th width="20%"><spr:message code="desktopLayout.cols" />:</th>
									<td>${desktopLayout.cols}</td>
								</tr>
								<tr>
									<th width="20%"><spr:message code="desktopLayout.width" />:</th>
									<td>${desktopLayout.width}</td>
								</tr>
								<tr>
									<th width="20%"><spr:message code="desktopLayout.memo" />:</th>
									<td>${desktopLayout.memo}</td>
								</tr>
								<tr>
									<th width="20%"><spr:message code="desktopLayout.isDefault" />:</th>
									<td>${desktopLayout.isDefault}</td>
								</tr>
							</table>
						</div>
			</div>
	</div>
</body>
</html>
