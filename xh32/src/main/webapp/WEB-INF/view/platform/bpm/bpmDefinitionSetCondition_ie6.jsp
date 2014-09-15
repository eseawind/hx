<%--
	time:2011-11-28 22:02:01
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html"%>
<html>
<head>
<%@include file="/commons/include/form.jsp"%>
<title><spr:message code="bpmDefinition.condition.title"/></title>
<script type="text/javascript"src="${ctx}/js/hotent/platform/bpm/FlowVarWindow.js"></script>
<script type="text/javascript"src="${ctx}/js/hotent/platform/system/ScriptDialog.js"></script>
<script type="text/javascript" src="${ctx}/js/javacode/codemirror.js"></script>

<style type="text/css">
body{
	overflow-x:hidden;
	overflow-y:auto;
}
</style>
<script type="text/javascript">
	var nodeId = "${nodeId}";
	var deployId = "${deployId}";
	var defId = "${defId}";
	var currentTextArea=null;
	$(function() {
		$("a[name='btnVars']").click(selectVar);
		$("#btnScript").click(selectScript);
		$("a[name='signResult']").click(function() {
			addToTextarea($(this).attr("result"));
		});
		$("a.save").click(saveCondition);
		$('textarea').click(function(){
			currentTextArea=this;
		});
	});
	var flowVarWindow;
	//选择变量
	function selectVar() {
		FlowVarWindow({
			deployId : deployId,
			nodeId : nodeId,
			callback : function(vars) {
				addToTextarea(vars);
			}
		});
	};
	//将条件表达式追加到脚本输入框内
	function addToTextarea(str){
		$(currentTextArea).text(str);
	};
	
	function selectScript() {
		ScriptDialog({
			callback : function(script) {
				addToTextarea(script);
			}
		});
	};
	function handFlowVars(obj) {
		addToTextarea($(obj).val());
	};
	function saveCondition() {
		
		var tasks = [];
		var conditions = [];		
		$("tr.taskTr > td").each(function(){
			var condition=$("[name='condition']", $(this)).val();
			var task=$("[name='task']", $(this)).val(); 
			tasks.push(task);
			conditions.push(condition);
		});
		
		var url = __ctx + "/platform/bpm/bpmDefinition/saveCondition.ht";
		var paras = {
			"defId" : defId,
			"nodeId" : nodeId,
			"tasks" : tasks.join('#split#'),
			"conditions" : conditions.join('#split#')
		};

		$.post(url, paras, function(data) {
			var resultObj = new com.hotent.form.ResultMessage(data);
			if (resultObj.isSuccess()) {
				$.ligerDialog.success('<spr:message code="bpmDefinition.condition.saveSuccess"/>',$lang.tip.msg, function() {
					window.close();
				});
			} else {
				$.ligerDialog.warn('<spr:message code="bpmDefinition.condition.saveError"/>',$lang.tip.msg);
			}
		});
	};
</script>
</head>
<body>
	<div class="panel" >
		<div class="panel-top">
			<div class="tbar-title">
				<span class="tbar-label"><spr:message code="bpmDefinition.condition.title"/></span>
			</div>
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="group">
						<a class="link save" id="btnSearch"><span></span><spr:message code="menu.button.save"/></a>
					</div>
					<div class="l-bar-separator"></div>
					<div class="group">
						<a class="link del" onclick="javasrcipt:window.close()"><span></span><spr:message code="menu.button.close"/></a>
					</div>

				</div>
			</div>
		</div>
		<div class="panel-body">
			<form id="bpmNodeRuleForm" method="post" action="save.ht">
				
					<table class="table-detail" cellpadding="0" cellspacing="0" border="0"  >
						<tr>
							<th><spr:message code="bpmDefinition.condition.expression"/></th>
							<td>
								<div style="margin: 8px 0; ">
									<a href="#" id="btnScript" class="link var" title="<spr:message code='script.common'/>"><spr:message code="script.common"/></a>
									&nbsp;&nbsp;<spr:message code="script.flowVar"/>:
									<f:flowVar defId="${defId}" change="handFlowVars(this)"></f:flowVar>
								</div> 
								<c:forEach items="${incomeNodes}" var="inNode">
									<div style="padding: 4px;">
										<c:choose>
											<c:when test="${inNode.isMultiple==true}">
												<a href="#" name="signResult"
													result='signResult_${inNode.nodeId}=="pass"'>[${inNode.nodeName}]<spr:message code="bpmDefinition.condition.votePass"/></a>
															&nbsp;
															<a href="#" name="signResult"
													result='signResult_${inNode.nodeId}=="refuse"'>[${inNode.nodeName}]<spr:message code="bpmDefinition.condition.voteNotPass"/></a>
											</c:when>
											<c:otherwise>
												<a href="#" name="signResult"
													result="approvalStatus_${inNode.nodeId}==1">[${inNode.nodeName}]-<spr:message code="bpmDefinition.condition.pass"/></a>
															&nbsp;
															<a href="#" name="signResult"
													result="approvalStatus_${inNode.nodeId}==2">[${inNode.nodeName}]-<spr:message code="bpmDefinition.condition.against"/></a>
											</c:otherwise>
										</c:choose>
										<ul>
											<spr:message code="bpmDefinition.condition.help" arguments="<li>,</li>"/>
										</ul>
																	
									</div>
								</c:forEach>							
							</td>
						</tr>
						<c:forEach items="${outcomeNodes}" var="outNode">
							<tr class="taskTr">
								<th width="20%">
									 ${outNode.nodeName }
								</th>
								<td>
									<input type="hidden" name="task" value="${outNode.nodeId}" />
									<textarea id="${outNode.nodeId}"  name="condition" rows="3" cols="50" class="inputText">${outNode.condition}</textarea>
								</td>
							</tr>
						</c:forEach>
					</table>
				
			</form>
		</div>
	</div>
</body>
</html>
