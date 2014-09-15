<%--
	time:2011-11-23 11:07:27
--%>
<%@page language="java" pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html"%>
<html>
<head>
	<%@include file="/commons/include/form.jsp" %>
	<title><spr:message code="title.add"/> <spr:message code="globalType"/></title>
	<f:link href="tree/zTreeStyle.css"></f:link>
	<script type="text/javascript" src="${ctx}/js/lg/plugins/ligerComboBox.js"></script>
	<script type="text/javascript" src="${ctx}/js/tree/jquery.ztree.js"></script>
	<script type="text/javascript" src="${ctx}/servlet/ValidJs?form=globalType"></script>
	<script src="${ctx}/js/jquery/plugins/jquery.selectInput.js" type="text/javascript"></script>
	<script src="${ctx}/js/jquery/plugins/jquery.bgiframe.js" type="text/javascript"></script>
	<script type="text/javascript" src="${ctx}/js/hotent/platform/system/Share.js"></script>
	<script type="text/javascript">
		$(function() {
			function showRequest(formData, jqForm, options) {
				return true;
			}; 
			valid(showRequest,showResponse);
			$("a.save").click(function() {
				$('#globalTypeForm').submit(); 
			});
			
			function showResponse(responseText){
				alert("ok");
			}
			
			function getFullSpell(typeName){
				Share.getPingyin({
					input:typeName,
					postCallback:function(data){
						$("#nodeKey").val(data.output);
					}
				});
			}
			
			 $("#typeName").change(function(){   
				 getFullSpell($(this).val());  				   
	         });   
			
		});
	</script>
</head>
<body>
<div class="panel">
		<div class="panel-top">
			<div class="tbar-title">
				<span class="tbar-label"><spr:message code="title.add"/> <spr:message code="globalType"/></span>
			</div>
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="group"><a class="link save" id="dataFormSave" href="#"><span></span><spr:message code="menu.button.save"/></a></div>
					<div class="l-bar-separator"></div>
					<div class="group"><a class="link back" href="#" ><span></span><spr:message code="menu.button.back"/></a></div>
				</div>
			</div>
		</div>
		<div class="panel-body">
			<div class="panel-detail">
				<form id="globalTypeForm" method="post" action="add2.ht">
					<table border="0" cellspacing="0" cellpadding="0" class="table-detail">
						<tr>
							<th  width="20%"><spr:message code="globalType.typeName"/>: <span class="required">*</span></th>
							<td ><input type="text" id="typeName" name="typeName" value=""  class="inputText"/></td>
						</tr>
						<tr>
							<th width="20%"><spr:message code="globalType.nodeKey"/>: <span class="required">*</span></th>
							<td ><input type="text" id="nodeKey" name="nodeKey" value=""  class="inputText"/></td>
						</tr>
					</table>
					<input type="hidden" id="parentId" name="parentId" value="${parentId }"  />
					<input type="hidden" id="isRoot" name="isRoot" value="${isRoot}" />
				</form>
			</div>
		</div>
</div>
</body>
</html>
