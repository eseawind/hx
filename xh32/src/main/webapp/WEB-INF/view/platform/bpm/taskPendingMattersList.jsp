<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html" %>
<html>
<head>
<%@include file="/commons/include/get.jsp" %>
<title><spr:message code="processCenter.pendingMatters"/></title>
<script type="text/javascript" src="${ctx}/js/hotent/platform/system/SysDialog.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/bpm/BpmTaskExeAssignDialog.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/bpm/SelectUtil.js" ></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/system/UserInfo.js"></script>
<script type="text/javascript">
$(function(){
	$("[name='subject']").click(function(){
		$("#treeFresh",window.parent.document).trigger("click");
	});
});

function executeTask(taskId){
	 var url="${ctx}/platform/bpm/task/toStart.ht?taskId="+taskId;
	var rtn = jQuery.openFullWindow(url);
	
}

//重启任务
function restartTask(taskId){
	var url="${ctx}/platform/bpm/task/restartTask.ht?taskId="+taskId;
	var rtn = jQuery.openFullWindow(url);
}


function reload(){
	location.href=location.href.getNewUrl();
	parent.globalType.loadGlobalTree();
}



function batOperator(operator){
	if(operator=="approve"){
		if ($("#btnApprove").attr('class').indexOf('disabled')>0){return false;}	
	}
	else{
		if ($("#btnBatDelegate").attr('class').indexOf('disabled')>0){return false;}
	}
	
	var aryId = $("input[type='checkbox'][disabled!='disabled'][class='pk']:checked");
	var len=aryId.length;
	if(len==0){
		$.ligerDialog.warn($lang.operateTip.selectRecord,$lang.tip.msg);
		return;
	}
	
	var taskIds=new Array();
	$("input[name='id']:checked").each(function(){
		taskIds.push($(this).val());
	});
	var ids=taskIds.join(",");
	
	
	var url=__ctx + "/platform/bpm/task/pendingMattersListBatchApprovalCfm.ht?taskIds="+ids;
	if(operator=="delegate"){
		url=__ctx + "/platform/bpm/task/delegateDialog.ht?taskIds="+ids;
	}
	
	var winArgs="dialogWidth=500px;dialogHeight=250px;help=0;status=0;scroll=0;center=1";
	url=url.getNewUrl();
	var rtn=window.showModalDialog(url,"",winArgs);
	if (rtn=='ok'){
		location.href=location.href.getNewUrl();
	}
}

</script>
</head>
<body>
	<div class="panel" >
	<div class="hide-panel">
		<div class="panel-top">
			<div class="tbar-title">
				<span class="tbar-label"><spr:message code="processCenter.pendingMatters"/></span>
			</div>
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="group"><a class="link search" id="btnSearch"><span></span><spr:message code="menu.button.search"/></a></div>
					<div class="l-bar-separator"></div>
					<div class="group"><a class="link reset" onclick="$.clearQueryForm()"><span></span><spr:message code="menu.button.reset"/></a></div>
					<div class="l-bar-separator"></div>
					<div class="group"><f:a alias="batchApproval" css="link save" id="btnApprove" href="#"   onclick="batOperator('approve');"><span></span><spr:message code="menu.button.batchApproval"/></f:a></div>
				</div>	
			</div>
			<div class="panel-search" >
				<form id="searchForm" method="post" action="pendingMattersList.ht?porIndex=${porIndex}&tabIndex=${tabIndex}">
					<ul class="row">
						<input type="hidden" name="nodePath" value="${param['nodePath']}" title="流程分类节点路径"></input>
						<li>
							<span class="label"><spr:message code="processCenter.subjectName"/>:</span>
							<input type="text" name="Q_subject_SUPL"  class="inputText" value="${param['Q_subject_SUPL']}"/>
						</li>
						<li>
							<span class="label"><spr:message code="processCenter.processName"/>:</span>
							<input type="text" name="Q_processName_SUPL"  class="inputText"  value="${param['Q_processName_SUPL']}"/>
						</li>
						<li>
							<span class="label"><spr:message code="processCenter.creator"/>:</span>
							<input type="hidden" id="creatorId"  class="inputText"  name="Q_creatorId_L"  value="${param['Q_creatorId_L']}" />
							<input type="text"  id="creator" name="Q_creator_SL" class="inputText" style="width: 110px;"  value="${param['Q_creator_SL']}" onclick="selectUser('creatorId','creator');" readonly="readonly"  />
							<input type="button" value="..."  class="buttonSearch"  onclick="selectUser('creatorId','creator');">
						</li>
					
					<div class="row_date">
						<li>
							<span class="label"><spr:message code="processCenter.createtime"/> &nbsp;<spr:message code="search.from"/>:</span>
							<input type="text" name="Q_beginCreateTime_DL"  class="datePicker inputText"  datetype="1" value="${param['Q_beginCreateTime_DL']}"/>
						</li>
						<li>
							<span class="label"><spr:message code="search.to"/>: </span>
							<input type="text" name="Q_endCreateTime_DG"  class="datePicker inputText"  value="${param['Q_endCreateTime_DG']}" datetype="2"/>
						</li>
					</div>
					
					
						<li>
							<span class="label"><spr:message code="processCenter.readStatus"/>:</span>
							<select name="Q_hasRead_S" class="selectSearch">
								<option value=""><spr:message code="search.select.allSelect"/></option>
								<option value="0" <c:if test="${param['Q_hasRead_S'] == '0'}">selected</c:if>><spr:message code="processCenter.readStatus.notRead"/></option>
								<option value="1" <c:if test="${param['Q_hasRead_S'] == '1'}">selected</c:if>><spr:message code="processCenter.readStatus.read"/></option>
							</select>
						</li>
						<li>
							<span class="label"><spr:message code="processCenter.pendingType"/>:</span>
							<select name="Q_type_S" class="selectSearch">
								<option value=""><spr:message code="search.select.allSelect"/></option>
								<option value="-1" <c:if test="${param['Q_type_S'] == '-1'}">selected</c:if>><spr:message code="processCenter.pendingType.pending"/></option>
								<option value="21" <c:if test="${param['Q_type_S'] == '21'}">selected</c:if>><spr:message code="processCenter.pendingType.delegate"/></option>
								<option value="15" <c:if test="${param['Q_type_S'] == '15'}">selected</c:if>><spr:message code="processCenter.pendingType.commu"/></option>
								<option value="26" <c:if test="${param['Q_type_S'] == '26'}">selected</c:if>><spr:message code="processCenter.pendingType.agent"/></option>
								<option value="38" <c:if test="${param['Q_type_S'] == '38'}">selected</c:if>><spr:message code="processCenter.pendingType.trans"/></option>
							</select>
						</li>
						<li>
						<span class="label"><spr:message code="processCenter.status"/>:</span>
						<select name="Q_status_N"   class="selectSearch">
							<option value=""><spr:message code="search.select.allSelect"/></option>
							<option value="1" <c:if test="${param['Q_status_N'] == '1'}">selected</c:if>><spr:message code="processRun.status.approval"/></option>
							<option value="5" <c:if test="${param['Q_status_N'] == '5'}">selected</c:if>><spr:message code="processRun.status.recover"/></option>
							<option value="6" <c:if test="${param['Q_status_N'] == '6'}">selected</c:if>><spr:message code="processRun.status.reject"/></option>
							<option value="7" <c:if test="${param['Q_status_N'] == '7'}">selected</c:if>><spr:message code="processRun.status.retrieved"/></option>
						</select>
						</li>
					</ul>
					
				</form>
			</div>
		</div>
		</div>
		<div class="panel-body">
		    	<c:set var="checkAll">
					<input type="checkbox" id="chkall"/>
				</c:set>
			    <display:table name="taskList" id="taskItem" requestURI="pendingMattersList.ht" sort="external" cellpadding="1" cellspacing="1"  class="table-grid">
					<display:column title="${checkAll}" media="html" style="width:20px;">
							<%-- 15 为沟通意见 , 38为流转意见--%>
						  	<c:choose>
							<c:when test="${taskItem.description eq '15' || taskItem.description eq '38'}">
								<input type="checkbox" class="pk" name="id"  disabled="disabled" value="${taskItem.id}">
							</c:when>
							<c:otherwise >
								<input type="checkbox" class="pk" name="id"  value="${taskItem.id}">
							</c:otherwise>
						</c:choose>
					</display:column>
					<display:column titleKey="processCenter.subjectName"  sortable="true" sortName="subject"  style="text-align:left;" >
							<c:choose>
									<c:when test="${taskItem.description eq '36'}">
										<a name="subject"  href="#${taskItem.id}" onclick="javascript:restartTask(${taskItem.id})" title='${taskItem.subject}'  <c:if test="${taskItem.hasRead == 0}"> class='message close-message'</c:if><c:if test="${taskItem.hasRead != 0}"> class='message open-message'</c:if> >${f:subString(taskItem.subject)}</a>
									</c:when>
								<c:otherwise>
										<a name="subject"  href="#${taskItem.id}" onclick="javascript:executeTask(${taskItem.id})" title='${taskItem.subject}' <c:if test="${taskItem.hasRead == 0}"> class='message close-message'</c:if><c:if test="${taskItem.hasRead != 0}"> class='message open-message'</c:if> >${f:subString(taskItem.subject)}</a>
								</c:otherwise>
							</c:choose>
							
					</display:column>
					<display:column property="processName" titleKey="processCenter.processName"  sortable="true" sortName="processName"  style="text-align:left"></display:column>
					<display:column  titleKey="processCenter.creator" sortable="true" sortName="creator" style="text-align:left">
						<a href="javascript:userDetail('${taskItem.creatorId}');">${taskItem.creator}</a>
					</display:column>
					<display:column titleKey="processCenter.createtime" sortable="true" sortName="create_time_">
						<fmt:formatDate value="${taskItem.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</display:column>
					<display:column titleKey="processCenter.status" style="width:30px;" >
						<c:choose>
							<c:when test="${taskItem.taskStatus==1}"><spr:message code="processRun.status.approval"/></c:when>
							<c:when test="${taskItem.taskStatus==5}"><spr:message code="processRun.status.recover"/></c:when>
							<c:when test="${taskItem.taskStatus==6}"><spr:message code="processRun.status.reject"/></c:when>
							<c:when test="${taskItem.taskStatus==7}"><spr:message code="processRun.status.retrieved"/></c:when>
						</c:choose>
					</display:column>
					<display:column titleKey="processCenter.pendingType"  style="width:30px;">
					
						<c:choose>
							<c:when test="${taskItem.description=='-1'}">
								<span class="green"><spr:message code="processCenter.pendingType.pending"/></span>
							</c:when>
							<c:when test="${taskItem.description eq '21' }" >
								<span class="brown"><spr:message code="processCenter.pendingType.delegate"/></span>
							</c:when>
							<c:when test="${taskItem.description eq '15' }" >
								<span class="orange"><spr:message code="processCenter.pendingType.commu"/></span>
							</c:when>
							<c:when test="${taskItem.description eq '26' }" >
								<span class="brown"><spr:message code="processCenter.pendingType.agent"/></span>
							</c:when>
							<c:when test="${taskItem.description eq '38' }" >
								<span class="red"><spr:message code="processCenter.pendingType.trans"/></span>
							</c:when>
						</c:choose>
					</display:column>
				</display:table>
				<hotent:paging tableId="taskItem" />
		</div>
	</div>
</body>
</html>


