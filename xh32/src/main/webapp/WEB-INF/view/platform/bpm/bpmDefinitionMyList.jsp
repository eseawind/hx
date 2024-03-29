<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.hotent.platform.model.bpm.BpmDefRights"%>
<%@include file="/commons/include/html_doctype.html" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="/commons/include/get.jsp" %>
<title><spr:message code="processCenter.newProcess"/></title>
<script type="text/javascript" src="${ctx}/js/hotent/platform/bpm/FlowUtil.js" ></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/system/SysDialog.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/bpm/SelectUtil.js" ></script>
<style type="text/css">
html,body {
	padding: 0px;
	margin: 0;
	width: 100%;
	height: 100%;
}
</style>
</head>
<body>      
	<div class="panel">
	<div class="hide-panel">
		<div class="panel-top">
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="group"><a class="link search" id="btnSearch"><span></span><spr:message code="menu.button.search"/></a></div>
					<div class="l-bar-separator"></div>
					<div class="group"><a href="#" class="link reset" onclick="$.clearQueryForm();"><span></span><spr:message code="menu.button.reset"/></a></div>
				</div>	
			</div>
			<div class="panel-search">
				<form id="searchForm" method="post" action="myList.ht">
					<ul class="row">
						<input type="hidden" name="typeId" value="${param['typeId']}" title="流程分类ID"></input>
						<li>					
						<span class="label"><spr:message code="processCenter.processName"/>:</span><input  type="text" name="Q_subject_SL"  class="inputText"  value="${param['Q_subject_SL']}"/>
						</li>
					</ul>
				</form>
			</div>
		</div>
		</div>
		<div class="panel-body">
			    <display:table name="bpmDefinitionList" id="bpmDefinitionItem" requestURI="myList.ht" sort="external" cellpadding="1" cellspacing="1" export="false"  class="table-grid">
					<display:column titleKey="list.orderNo" media="html" style="width:20px;" >
						  	${bpmDefinitionItem_rowNum}
					</display:column>
					<display:column titleKey="processCenter.processName" sortable="true" sortName="subject" >
						<a href="#${bpmDefinitionItem.defId}" onclick="FlowUtil.startFlow(${bpmDefinitionItem.defId},'${bpmDefinitionItem.actDefId}')" title="${bpmDefinitionItem.subject}" >${f:subString(bpmDefinitionItem.subject)}</a>	
					</display:column>
					<display:column titleKey="processCenter.type" sortable="true" sortName="typeId">
							${bpmDefinitionItem.typeName}
					</display:column>
					<display:column property="versionNo" titleKey="processCenter.version" sortable="true" sortName="versionNo" style="width:30px；"></display:column>
				</display:table>
				<hotent:paging tableId="bpmDefinitionItem"></hotent:paging>
		</div><!-- end of panel-body -->				
	</div> <!-- end of panel -->
</body>
</html>


