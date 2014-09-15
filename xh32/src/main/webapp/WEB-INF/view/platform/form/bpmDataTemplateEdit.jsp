<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html" %>
<html>
<head>
<%@include file="/commons/include/form.jsp" %>
<title><spr:message code="bpmDataTemplate.title"/></title>
<f:js pre="js/lang/view/platform/form" ></f:js>
<link href="${ctx}/styles/default/css/jquery.qtip.css" rel="stylesheet" />
<script type="text/javascript" src="${ctx}/js/jquery/plugins/jquery.fix.clone.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/CustomValid.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/formdata.js"></script>
<script type="text/javascript" src="${ctx}/js/util/easyTemplate.js" ></script>
<script type="text/javascript" src="${ctx}/js/codemirror/lib/codemirror.js"></script>
<script type="text/javascript" src="${ctx}/js/codemirror/lib/util/matchbrackets.js"></script>
<script type="text/javascript" src="${ctx}/js/codemirror/mode/groovy/groovy.js"></script>
<script type="text/javascript" src="${ctx}/js/jquery/plugins/jquery.qtip.js" ></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/system/ScriptDialog.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/system/SysDialog.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/system/AddResourceDialog.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/system/BpmDefinitionDialog.js"></script>
<script type="text/javascript">
	var tab = "";
	
	$(function(){
		//Tag Layout
		tab =$("#tab").ligerTab({
			//onBeforeSelectTabItem:onBeforeSelectTabItem
		});	
		
		__DataTemplate__.init();

		var options={};
		if(showResponse){
			options.success=showResponse;
		}	

		$("a.save").click(function() {
			var form=$('#dataTemplateForm');
			if(!form.valid())
				return;	
			if(saveChange(form))
				customFormSubmit(form,options);	
		});
		// 批量授权
		$("select.rightselect").change(setPermision);
	});
	
	function manageFieldValid(){
		var name =new Array();
		$("#manageTbl").find("[var='name']").each(function() {
			name.push( $(this).val());
		});
		return isRepeat(name);		
	}
	//验证排序字段
	function sortFieldValid(){
		var i = 0;
		$("#sortTbl tbody tr").each(function(){
			i++;
		});
		if(i>3)
			return true;
		return false;		
	}
	
	function isRepeat(arr) {
	    var hash = {};
	    for(var i in arr) {
	        if(hash[arr[i]]) {
	            return true;
	        }
	        // 不存在该元素，则赋值为true，可以赋任意值，相应的修改if判断条件即可
	        hash[arr[i]] = true;
	    }
	    return false;
	}
	//导出字段
	function getExportField(){
		var json = [];
		$("#exportFieldTbl tr[var='exportTableTr']").each(function(){
			var me = $(this),table={},tableName=$("[var='tablename']",me).val(),fields = [];
				table.tableName =tableName;
				table.tableDesc =$("[var='tabledesc']",me).val();
				table.isMain =$("[var='ismain']",me).val();
				$("#exportFieldTbl tr[var='exportFieldTr']").each(function(){
					var self = $(this),obj={},
						name  = $("[var='tablename']",self).val();
					if(tableName == name){
					
						obj.name =$("[var='name']",self).html();
						obj.desc =$("[var='desc']",self).val();
						obj.type =$("[var='type']",self).val();
						obj.style =$("[var='style']",self).val();
						obj.tableName =tableName;
						obj.isMain =$("[var='ismain']",self).val();
						obj.right = getRightJson(self,2);
						fields.push(obj)
					}
				});
				table.fields = fields;
				json.push(table);
		
		});
		return json;
	}	
	
	//显示字段
	function getDisplayField(){
		var json = [];
		$("#displayFieldTbl tr[var='displayFieldTr']").each(function(){
			var me = $(this),obj={};
			obj.name =$("[var='name']",me).html();
			obj.desc =$("[var='desc']",me).val();
			obj.type =$("[var='type']",me).val();
			obj.style =$("[var='style']",me).val();

			obj.right = getRightJson(me,1);
			json.push(obj);
		});
		return json;
	}	
	function getRightJson(me,flag){
		var rightJson = [];
		if(flag ==1){
			var fieldRight = $("[var='fieldRight']",me);
			var printRight = $("[var='printRight']",me);
			rightJson.push(getRight(fieldRight,0));
			rightJson.push(getRight(printRight,1));
		}else{
			var exportRight = $("[var='exportRight']",me);
			rightJson.push(getRight(exportRight,2));
		}
		return rightJson;
	}
	
	function getRight(rightTd,s){
		var obj={};
		obj.s= s;
		obj.type =$("[var='right']",rightTd).val();
		obj.id =$("[var='rightId']",rightTd).val();
		obj.name =$("[var='rightName']",rightTd).val();
		obj.script =$("[var='rightScript']",rightTd).val();
		return obj;
	}
	
	
	function getConditionField(){
		var fields=new Array();
	
		$("#conditionTbl tbody tr").each(function(){
			var tr=$(this);
			var field=$.parseJSON(tr.find("input[type='hidden']").val());
			//var jt=tr.find("[name='jt']").val();
			var ct =tr.find("[name='ct']").val();
			var op =tr.find("[name='op']").val();
			var vf =parseInt(tr.find("[name='vf']").val());
			var va =tr.find("[name='va']").val();
			var cm =tr.find("[name='cm']").val();
			var qt =__DataTemplate__.getQueryType(field.ty,op);
			//field.jt=jt;
			field.op=op;
			field.ct=ct;
			field.vf=vf;
			field.va=va;
			field.cm=cm;
			field.qt=qt;
			fields.push(field);
		});
		return fields;
	}
	
	//排序字段
	function getSortField(){
		var fields=new Array();
		$("#sortTbl tbody tr").each(function(){
			var me=$(this),obj={};
			obj.name =$("[var='name']",me).html();
			obj.desc =$("[var='desc']",me).html();
			obj.sort =$("[var='sort']",me).val();
			obj.source =$("[var='source']",me).val();
			fields.push(obj);
		});
		return fields;
	}
	
	//过滤字段
	function getFilterField(){
		var fields=new Array();
		$("#filterTbl tbody tr").each(function(){
			var me=$(this),obj={},rightJson = [];
			obj.name =$("[var='name']",me).html();
			obj.key=$("[var='key']",me).html();
			obj.type=$("[var='type']",me).val();
			obj.condition = $("[var='condition']",me).val();
			rightJson.push(getRight($("[var='filterRight']",me),3));
			obj.right = rightJson;
			fields.push(obj);
		});
		return fields;
	}
	
	//管理字段
	function getManageField(){
		var fields=new Array();
		$("#manageTbl tbody tr").each(function(){
			var me=$(this),obj={},rightJson = [];
			obj.desc =$("[var='desc']",me).val();
			obj.name =$("[var='name']",me).val();
			rightJson.push(getRight($("[var='manageRight']",me),4));
			obj.right = rightJson;
			fields.push(obj);
		});
		return fields;
	}
	
	function saveChange(form){
		//判断排序字段太多报错问题
		if(sortFieldValid()){
			$.ligerDialog.error($lang_form.bpmDataTemplate.save.sortField,$lang.tip.msg);
			tab.selectTabItem("sortSetting");
			return false;
		}
		//判断管理字段
		if(manageFieldValid()){
			$.ligerDialog.error($lang_form.bpmDataTemplate.save.manageField,$lang.tip.msg);
			tab.selectTabItem("manageSetting");
			return ;
		}
		var needPage=$("input[name='needPage']:checked").val();
		
		var templateAlias=$("#templateAlias").val();
		if(templateAlias=="" || needPage ==""){
			tab.selectTabItem("baseSetting");
			form.valid();
			return false;	
		}
		//显示字段
		var displayField= JSON2.stringify(getDisplayField());	
		//条件字段
		var conditionField= JSON2.stringify(getConditionField());
		//排序字段
		var sortField= JSON2.stringify(getSortField());
		//过滤字段字段
		var filterField= JSON2.stringify(getFilterField());
		//管理字段
		var manageField= JSON2.stringify(getManageField());
		//导出字段
		var exportField= JSON2.stringify(getExportField());

		$('#displayField').val(displayField);
		$('#conditionField').val(conditionField);
		$('#sortField').val(sortField);
		$('#filterField').val(filterField);
		$('#manageField').val(manageField);
		$('#exportField').val(exportField);
		return true;
	}
	
	/**
	 * 自定义外部表单并提交
	 * @return void
	 */
	function customFormSubmit(form,options){
		var id=$("#id").val();
		var tableId=$("#tableId").val();
		var formKey=$("#formKey").val();
		var source=$("#source").val();
		var defId=$("#defId").val();
		var isQuery=$("#isQuery").val();
		var isFilter=$("#isFilter").val();

		var needPage=$("input[name='needPage']:checked").val();
		var pageSize=$("#pageSize").val();

		var templateAlias=$("#templateAlias").val();
		//显示字段
		var displayField= $('#displayField').val();
		//条件字段
		var conditionField= $('#conditionField').val();
		//排序字段
		var sortField= $('#sortField').val();
		//过滤字段字段
		var filterField= $('#filterField').val();
		//管理字段
		var manageField= $('#manageField').val();
		var exportField = $('#exportField').val();
		
		var json={
			id:id,
			tableId:tableId,
			formKey:formKey,
			source:source,
			defId:defId,
			isQuery:isQuery,
			isFilter:isFilter,
			needPage:needPage,
			pageSize:pageSize,
			displayField:displayField,
			conditionField:conditionField,
			sortField:sortField,
			filterField:filterField,
			manageField:manageField,
			exportField:exportField,
			templateAlias:templateAlias
		};
		
		var form = $('<form method="post" action="save.ht"></form>');
		var input = $("<input type='hidden' name='json'/>");
		var jsonStr=JSON2.stringify(json);
		
		input.val(jsonStr);
		form.append(input);
		form.ajaxForm(options);
		form.submit();
	}
	
	
	function showResponse(responseText) {
		$.ligerDialog.closeWaitting();
		var obj = new com.hotent.form.ResultMessage(responseText);
		if (obj.isSuccess()) {
			$.ligerDialog.confirm( obj.getMessage()+","+$lang.operateTip.continueOp,$lang.tip.msg, function(rtn) {
				if(rtn){
					window.location.href =  location.href.getNewUrl();
				}else{
					window.close();
				}
			});
			
		} else {
			$.ligerDialog.err(obj.getMessage(),$lang.tip.msg);
		}
	}
	//预览
	function preview(id){
		if($.isEmpty(id)){
			$.ligerDialog.error($lang_form.bpmDataTemplate.preview,$lang.tip.msg);
			return ;
		}
		var url=__ctx+ "/platform/form/bpmDataTemplate/preview.ht?__displayId__="+id;
		var winArgs="dialogWidth=800px;dialogHeight=600px;help=0;status=0;scroll=0;center=1";
		url=url.getNewUrl();
		$.openFullWindow(url);
	}
	//编辑模板
	function editTemplate(id){
		if($.isEmpty(id)){
			$.ligerDialog.error($lang_form.bpmDataTemplate.edit.empty,$lang.tip.msg);
			return ;
		}
		var url=__ctx+ "/platform/form/bpmDataTemplate/editTemplate.ht?id="+id;
		//var winArgs="he=800px;dialogHeight=600px;help=0;status=0;scroll=0;center=1";
		url=url.getNewUrl();
		$.openFullWindow(url);
	}
	//添加菜单
	function addToResource(id){
		var url="/platform/form/bpmDataTemplate/preview.ht?__displayId__="+id;
		AddResourceDialog({addUrl:url});
	}
	
	/**
	* 选择流程
	*/
	function selectFlow(){
		BpmDefinitionDialog({isSingle:true,callback:function(defIds,subjects){
			$("#defId").val(defIds);
			$("#subject").val(subjects);
		}});
	};
	function cancel(){
		$("#defId").val("");
		$("#subject").val("");
	}

	//批量设置权限。
	function setPermision(){
		var me = $(this),
			val= me.val(),
			right = me.attr('right');
			if(val=="") return;
			$("span[name='r_span'],span[name='w_span'],span[name='b_span']",obj).hide();
			$('td[var="'+right+'"]').each(function(){
				var self = $(this),
					rightSelect =$("[var='right']",self);
				rightSelect.next().hide();
				rightSelect.next().next().hide();
				if(val ==0 ){
					rightSelect.val('none');
				}else if(val==1){
					rightSelect.val('everyone');
				}		
			});
			me.val("");
		}
	
</script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/form/DataTemplateEdit.js"></script>
</head>
<body>
<div class="panel">
<div class="hide-panel">
	<div class="panel-top">
		<div class="panel-top">
			<div class="tbar-title">
				<span class="tbar-label"><spr:message code="bpmDataTemplate.title"/></span>
			</div>
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="group"><a class="link save" id="dataFormSave" href="#"><span></span><spr:message code="menu.button.save"/></a></div>
					<c:if test="${!empty bpmDataTemplate.id}">
					<div class="l-bar-separator"></div>
					<div class="group"><a class="link preview" href="#" onclick="preview(${bpmDataTemplate.id})"><span></span><spr:message code="menu.button.preview"/></a></div>
					<div class="l-bar-separator"></div>
					<div class="group"><a class="link edit" href="#" onclick="editTemplate(${bpmDataTemplate.id})"><span></span><spr:message code="menu.button.eidtTemplate"/></a></div>	
					<div class="l-bar-separator"></div>
					<div class="group"><a class="link collapse" href="#" onclick="addToResource(${bpmDataTemplate.id})"><span></span><spr:message code="menu.button.addMenu"/></a></div>	
					</c:if>
					<div class="l-bar-separator"></div>
					<div class="group"><a class="link close" href="#" onclick="window.close();"><span></span><spr:message code="menu.button.close"/></a></div>
				</div>
			</div>
		</div>
	</div>
	</div>
	<div class="panel-body">
		<form id="dataTemplateForm" method="post" action="save.ht" >
		
				<div id="tab">
				<!-- 基本信息  start-->
				<div tabid="baseSetting" id="table" title="<spr:message code='bpmDataTemplate.basicInformation'/>">
					<div >
							<div class="tbar-title">
								<span class="tbar-label"><spr:message code="bpmDataTemplate.basicInformation"/></span>
							</div>
							<table class="table-detail" cellpadding="0" cellspacing="0" border="0" type="main" style="border-width: 0!important;">
								<tr>
									<th  width="10%"><spr:message code="bpmDataTemplate.bindingFlow"/>: </th>
									<td>
										<input type="hidden" id="defId" name="defId" value="${bpmDataTemplate.defId}"  class="inputText" />
										<input type="text" id="subject" name="subject" readonly="readonly" value="${bpmDataTemplate.subject}"  class="inputText"  style="width:210px;margin-right:2px;" />
										<a style="margin-right:5px;" onclick="selectFlow()" class="button" href="#"><span class="icon ok"></span><span><spr:message code="bpmDataTemplate.bindingFlow.choose"/></span></a>
										<a  onclick="cancel()" class="button" href="#"><span class="icon cancel"></span><span><spr:message code="bpmDataTemplate.bindingFlow.reset"/></span></a>
									</td>
								</tr>
								<tr>
									<th ><spr:message code="bpmDataTemplate.isPaging"/>: </th>
									<td>
										<input type="radio" name="needPage" value="0"  onclick="__DataTemplate__.switchNeedPage(this);" <c:if test="${bpmDataTemplate.needPage==0}">checked="checked"</c:if> ><spr:message code="bpmDataTemplate.isPaging.no"/>
										<input type="radio" name="needPage" value="1" onclick="__DataTemplate__.switchNeedPage(this);" <c:if test="${bpmDataTemplate.needPage==1}">checked="checked"</c:if>><spr:message code="bpmDataTemplate.isPaging.yes"/>
										<span style="color:red;<c:if test="${bpmDataTemplate.needPage==0}">display:none;</c:if>" id="spanPageSize" name="spanPageSize">
											<spr:message code="bpmDataTemplate.isPaging.size"/>：
											  <select id="pageSize" name="pageSize" >
											  		<option value="5" <c:if test="${bpmDataTemplate.pageSize==5}">selected="selected"</c:if> >5</option>
													<option value="10" <c:if test="${bpmDataTemplate.pageSize==10}">selected="selected"</c:if>>10</option>
													<option value="15" <c:if test="${bpmDataTemplate.pageSize==15}">selected="selected"</c:if> >15</option>
													<option value="20" <c:if test="${bpmDataTemplate.pageSize==20}">selected="selected"</c:if>>20</option>
													<option value="50" <c:if test="${bpmDataTemplate.pageSize==50}">selected="selected"</c:if>>50</option>						  
											  </select>
										 </span>
									</td>
								</tr>
								<tr>
									<th><spr:message code="bpmDataTemplate.isInitialQuery"/>: </th>
									<td>
										<select name="isQuery" id="isQuery"  validate="{required:true}">
											 	<option value="0" <c:if test="${bpmDataTemplate.isQuery==0}">selected="selected"</c:if> ><spr:message code="bpmDataTemplate.yes"/></option>
												<option value="1" <c:if test="${bpmDataTemplate.isQuery==1}">selected="selected"</c:if>><spr:message code="bpmDataTemplate.no"/></option>
										</select>
									</td>
								</tr>
								<tr>
									<th><spr:message code="bpmDataTemplate.isFilterCondition"/>: </th>
									<td>
										<select name="isFilter" id=isFilter  validate="{required:true}">
											 	<option value="0" <c:if test="${bpmDataTemplate.isFilter==0}">selected="selected"</c:if> ><spr:message code="bpmDataTemplate.yes"/></option>
												<option value="1" <c:if test="${bpmDataTemplate.isFilter==1}">selected="selected"</c:if>><spr:message code="bpmDataTemplate.no"/></option>
										</select>
									</td>
								</tr>
								<tr>
									<th><spr:message code="bpmDataTemplate.dataTemplate"/>: </th>
									<td>
										<select name="templateAlias" id="templateAlias"  validate="{required:true}">
											<option value=""><spr:message code="bpmDataTemplate.dataTemplate.title"/></option>
												<c:forEach items="${templates}" var="template">
												<option  value="${template.alias}" <c:if test="${bpmDataTemplate.templateAlias==template.alias}">selected="selected"</c:if>>${template.templateName}</option>
											</c:forEach>
										</select>
									<div class="tipbox"><a href="#" class="tipinfo"><span><spr:message code="bpmDataTemplate.dataTemplate.message"/></span></a></div>
									<input type="hidden" id="id" name="id" value="${bpmDataTemplate.id}">
								<input type="hidden" id="tableId" name="tableId" value="${bpmDataTemplate.tableId}">
								<input type="hidden" id="formKey" name="formKey" value="${bpmDataTemplate.formKey}">
								<input type="hidden" name="source" id="source" value="${bpmDataTemplate.source}">
								<textarea style="display: none;" id="displayField" name="displayField" >${fn:escapeXml(bpmDataTemplate.displayField)}</textarea>
								<textarea style="display: none;" id="conditionField" name="conditionField" >${fn:escapeXml(bpmDataTemplate.conditionField)}</textarea>
								<textarea style="display: none;" id="sortField" name="sortField" >${fn:escapeXml(bpmDataTemplate.sortField)}</textarea>
								<textarea style="display: none;" id="manageField" name="manageField" >${fn:escapeXml(bpmDataTemplate.manageField)}</textarea>
								<textarea style="display: none;" id="filterField" name="filterField" >${fn:escapeXml(bpmDataTemplate.filterField)}</textarea>
								<textarea style="display: none;" id="exportField" name="exportField" >${fn:escapeXml(bpmDataTemplate.exportField)}</textarea>
						
									</td>
								</tr>
													
							</table>
					</div>
				</div>
			
		</form>
					<!-- 基本信息  end-->
					<!-- 显示字段  start-->		
					<div tabid="displaySetting" id="table" title="<spr:message code='bpmDataTemplate.displayField'/>">
						<div>
							<table id="displayFieldTbl"  class="table-grid">
								<thead>
									<tr>
										<th width="5%"><spr:message code="bpmDataTemplate.NO"/></th>
										<th width="15%"><spr:message code="bpmDataTemplate.fieldName"/></th>
										<th width="20%"><spr:message code="bpmDataTemplate.fieldDesc"/></th>
										<th width="20%"><spr:message code="bpmDataTemplate.displayField.show"/><select  class="rightselect" right="fieldRight" ><option selected="selected" value=""></option><option  value="0"><spr:message code="bpmDataTemplate.none"/></option><option value="1"><spr:message code="bpmDataTemplate.allSelect"/></option></select></th>
										<th width="20%"><spr:message code="bpmDataTemplate.displayField.print"/><select  class="rightselect" right="printRight" ><option selected="selected" value=""></option><option  value="0"><spr:message code="bpmDataTemplate.none"/></option><option value="1"><spr:message code="bpmDataTemplate.allSelect"/></option></select></th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<!-- 显示字段  end-->
					<!-- 查询字段  start-->		
					<div tabid="conditionSetting" id="table" title="<spr:message code='bpmDataTemplate.queryField'/>">
							<div  class="condition-cols">
							<div >
									<div class="condition-cols-div">
										<table id="condition-columnsTbl" cellpadding="0" cellspacing="0" border="0" class="table-detail">
											<thead>
												<tr class="leftHeader">
													<th><spr:message code="bpmDataTemplate.select"/></th>
													<th><spr:message code="bpmDataTemplate.fieldName"/></th>
													<th><spr:message code="bpmDataTemplate.fieldDesc"/></th>
													<th><spr:message code="bpmDataTemplate.fieldType"/></th>
												</tr>
											</thead>
											<tbody>
												<c:if test="${!empty bpmFormTable}">
													<c:forEach items="${bpmFormTable.fieldList}" var="field" varStatus="status">	
														<tr  <c:if test="${status.index%2==0}">class="odd"</c:if> <c:if test="${status.index%2!=0}">class="even"</c:if>>
															<td>
																<input class="pk" type="checkbox" name="select" fieldname="${field.fieldName}" fieldtype="${field.fieldType}" fielddesc="${field.fieldDesc}"  controltype="${field.controlType}">
															</td>
															<td>${field.fieldName}</td>
															<td>${field.fieldDesc}</td>
															<td>${field.fieldType}</td>
														</tr>
													</c:forEach>
												</c:if>
											</tbody>
										</table>
									</div>
								</div>
								</div>
								<div class="condition-conds">
									<div class="condition-conds-div condition-conds-build" id="condition-build-div">
										<div class="condition-conds-div-left">
											<div class="condition-conds-div-left-div">
												<a style="margin-top: 180px;" id="selectCondition" href="#" class="button">
													<span></span>==>
												</a>
											</div>
										</div>
										<div class="condition-conds-div-right">
											<div class="condition-conds-div-right-div">
												<table id="conditionTbl" cellpadding="0" cellspacing="0" border="0" class="table-detail">
													<thead>
														<tr class="leftHeader">
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.fieldName"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.dispalyName"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.controlType"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.condition"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.valueSource"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.val"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.manager"/></th>
														</tr>
													</thead>
													<tbody>
													</tbody>
												</table>
											</div>
										</div>
								</div>
							</div>
					</div>
					<!-- 查询字段  end-->	
					<!-- 排序字段 start-->		
					<div tabid="sortSetting" id="table" title="<spr:message code='bpmDataTemplate.sortField'/>">
							<div class="sort-cols">
									<div class="sort-cols-div">
										<table id="sort-columnsTbl" cellpadding="0" cellspacing="0" border="0" class="table-detail">
											<thead>
												<tr class="leftHeader">
													<th><spr:message code="bpmDataTemplate.select"/></th>
													<th><spr:message code="bpmDataTemplate.fieldName"/></th>
													<th><spr:message code="bpmDataTemplate.fieldDesc"/></th>
												</tr>
											</thead>
											<tbody>
												<c:if test="${!empty bpmFormTable}">
													<c:forEach items="${bpmFormTable.fieldList}" var="field" varStatus="status">	
														<tr  <c:if test="${status.index%2==0}">class="odd"</c:if> <c:if test="${status.index%2!=0}">class="odd"</c:if>>
															<td>
																<input class="pk" type="checkbox" name="select" fieldname="${field.fieldName}" fieldtype="${field.fieldType}" fielddesc="${field.fieldDesc}">
															</td>
															<td>${field.fieldName}</td>
															<td>${field.fieldDesc}</td>
														</tr>
													</c:forEach>
												</c:if>
											</tbody>
										</table>
									</div>
								</div>
								<div class="sort-conds">
									<div class="sort-conds-div sort-conds-build" id="sort-build-div">
										<div class="sort-conds-div-left">
											<div class="sort-conds-div-left-div">
												<a style="margin-top: 180px;" id="selectSort" href="#" class="button">
													<span></span>==>
												</a>
											</div>
										</div>
										<div class="sort-conds-div-right">
											<div class="sort-conds-div-right-div">
												<table id="sortTbl" cellpadding="0" cellspacing="0" border="0" class="table-detail">
													<thead>
														<tr class="leftHeader">
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.fieldName"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.fieldDesc"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.sort"/></th>
															<th  nowrap="nowrap"><spr:message code="bpmDataTemplate.manager"/></th>
														</tr>
													</thead>
													<tbody>
													</tbody>
												</table>
											</div>
										</div>
								</div>
							</div>
					</div>
					<!-- 排序字段 end-->
					<!-- 过滤条件 start	-->
					<div tabid="filterSetting" id="table" title="<spr:message code='bpmDataTemplate.filterCondition'/>">
						<div class="table-top-left">				
							<div class="toolBar" style="margin:0;">
								<div class="group"><a class="link add" id="btnSearch" onclick="__DataTemplate__.addFilter()"><span></span><spr:message code="menu.button.add"/></a></div>
							<!--	<div class="l-bar-separator"></div>
								<div class="group"><a class="link edit  " onclick="filterDialog()"><span></span><spr:message code="menu.button.alter"/></a></div>
							-->	<div class="l-bar-separator"></div>
								<div class="group"><a class="link del " id="btnSearch" onclick="__DataTemplate__.delFilter();"><span></span><spr:message code="menu.button.del"/></a></div>
							</div>								
					    </div>
						<table id="filterTbl"  class="table-grid">
								<thead>
									<tr>
										<th width="5%"><spr:message code="bpmDataTemplate.select"/></th>
										<th width="10%"><spr:message code="bpmDataTemplate.name"/></th>
										<th width="10%"><spr:message code="bpmDataTemplate.key"/></th>
										<th width="10%"><spr:message code="bpmDataTemplate.fieldType"/></th>
										<th><spr:message code="bpmDataTemplate.power"/><select  class="rightselect" right="filterRight" ><option selected="selected" value=""></option><option  value="0"><spr:message code="bpmDataTemplate.none"/></option><option value="1"><spr:message code="bpmDataTemplate.allSelect"/></option></select></th>
										<th width="10%"><spr:message code="bpmDataTemplate.manager"/></th>
									</tr>
								</thead>
								<tbody>
								</tbody>
						</table>
					</div>
					<!-- 过滤条件 end-->
					<!-- 导出字段  start-->		
					<div tabid="exportSetting" id="table" title="<spr:message code='bpmDataTemplate.exportField'/>">
						<div>
							<table id="exportFieldTbl"  class="table-grid">
								<thead>
									<tr>
										<th width="5%"><spr:message code="bpmDataTemplate.NO"/></th>
										<th width="15%"><spr:message code="bpmDataTemplate.fieldName"/></th>
										<th width="20%"><spr:message code="bpmDataTemplate.fieldDesc"/></th>
										<th width="20%"><spr:message code="bpmDataTemplate.exportPower"/><select  class="rightselect" right="exportRight" ><option selected="selected" value=""></option><option  value="0"><spr:message code="bpmDataTemplate.none"/></option><option value="1"><spr:message code="bpmDataTemplate.allSelect"/></option></select></th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<!-- 导出字段  end-->			
					<!-- 功能按钮设置 start-->		
					<div tabid="manageSetting" id="table" title="<spr:message code='bpmDataTemplate.functionButton'/>">
						<div class="table-top-left">				
							<div class="toolBar" style="margin:0;">
								<div class="group"><a class="link add" id="btnSearch" onclick="__DataTemplate__.addManage()"><span></span><spr:message code="menu.button.add"/></a></div>
							<!--	<div class="l-bar-separator"></div>
								<div class="group"><a class="link edit  " onclick="filterDialog()"><span></span><spr:message code="menu.button.alter"/></a></div>
							-->	<div class="l-bar-separator"></div>
								<div class="group"><a class="link del " id="btnSearch" onclick="__DataTemplate__.delManage();"><span></span><spr:message code="menu.button.del"/></a></div>
							</div>								
					    </div>
						<table id="manageTbl"  class="table-grid">
								<thead>
									<tr>
										<th width="5%"><spr:message code="bpmDataTemplate.select"/></th>
										<th width="15%"><spr:message code="bpmDataTemplate.name"/></th>
										<th width="10%"><spr:message code="bpmDataTemplate.fieldType"/></th>
										<th><spr:message code="bpmDataTemplate.power"/><select  class="rightselect" right="manageRight" ><option selected="selected" value=""></option><option  value="0"><spr:message code="bpmDataTemplate.none"/></option><option value="1"><spr:message code="bpmDataTemplate.allSelect"/></option></select></th>
										<th width="10%"><spr:message code="bpmDataTemplate.manager"/></th>
									</tr>
								</thead>
								<tbody>
								</tbody>
						</table>
					</div>
					<!-- 管理列设置 end-->	
					
				</div>
	</div><!-- end of panel-body -->	
</div>
<div class="hidden">
		<!-- 显示字段模板 -->
		<div  id="displayFieldTemplate" >
			<table cellpadding="1" cellspacing="1"  class="table-detail">
				<tr var="displayFieldTr">
					<input type="hidden"  var="type"  value=""  />
					<input type="hidden"  var="style"  value=""  />
					<td var="index">&nbsp;</td>
					<td var="name">&nbsp;</td>
					<td ><input type="text"  var="desc"  value=""  /></td>
					<td var="fieldRight">
					</td>
					<td var="printRight">
					</td>
				</tr>
			</table>
		</div>
			<!-- 导出字段模板 -->
		<div  id="exportFieldTemplate" >
			<table cellpadding="1" cellspacing="1"  class="table-detail">
				<tr var="exportFieldTr">
					<input type="hidden"  var="type"  value=""  />
					<input type="hidden"  var="style"  value=""  />
					<input type="hidden"  var=tablename  value=""  />
					<input type="hidden"  var=ismain  value=""  />
					<td var="index">&nbsp;</td>
					<td var="name">&nbsp;</td>
					<td ><input type="text"  var="desc"  value=""  /></td>
					<td var="exportRight">
					</td>
				</tr>
			</table>
			<table cellpadding="1" cellspacing="1"  class="table-list">
				<tr var="exportTableTr">
					<input type="hidden"  var="tablename"  value=""  />
					<input type="hidden"  var="tabledesc"  value=""  />
					<input type="hidden"  var="ismain"  value=""  />
					<td var="table" colspan="6"></td>
				</tr>
			</table>
		</div>
		
		<!-- 排序模板 -->
		<div  id="sortTemplate"  style="display: none;">
			<table cellpadding="1" cellspacing="1"  class="table-detail">
				<tr var="sortTr">
					<input type="hidden"  var="source"  value="${bpmDataTemplate.source}"  />
					<td var="name">&nbsp;</td>
					<td var="desc">&nbsp;</td>
					<td ><select var="sort" >
							<option value="ASC"><spr:message code="bpmDataTemplate.sortField.asc"/></option>
							<option value="DESC"><spr:message code="bpmDataTemplate.sortField.desc"/></option> 
						</select></td>
					<td>
						<a class="link moveup" href="#" title='<spr:message code="menu.button.moveUp" />' onclick="__DataTemplate__.moveTr(this,true)"></a>
						<a class="link movedown" href="#"  title='<spr:message code="menu.button.moveDown" />' onclick="__DataTemplate__.moveTr(this,false)"></a>
						<a class="link del" href="#" title='<spr:message code="menu.button.del" />' onclick="__DataTemplate__.delTr(this)"></a>
					</td>
				</tr>
			</table>
		</div>
		<!-- 过滤条件模板 -->
		<div  id="filterTemplate"  style="display: none;">
			<table cellpadding="1" cellspacing="1"  class="table-detail">
				<tr var="filterTr">
					<td var="index"><input class="pk" type="checkbox" name="select"/>
					<input  type="hidden" var="type">
					<textarea style="display: none;" var="condition" ></textarea></td>
					<td var="name"></td>
					<td var="key"></td>
					<td var="typeshow"></td>
					<td var="filterRight">
					</td>
					<td>
						<a class="link moveup" href="#" title='<spr:message code="menu.button.moveUp" />' onclick="__DataTemplate__.moveTr(this,true)">
						<a class="link movedown" href="#" title='<spr:message code="menu.button.moveDown" />' onclick="__DataTemplate__.moveTr(this,false)"></a>
						<a class="link edit" href="#"  title='<spr:message code="menu.button.edit" />'  onclick="__DataTemplate__.editFilter(this)"></a>
						<a class="link del" href="#"  title='<spr:message code="menu.button.del" />' onclick="__DataTemplate__.delTr(this)"></a>
					</td>
				</tr>
			</table>
		</div>
		
		
		<!-- 功能按钮模板 -->
		<div  id="manageTemplate"  style="display: none;">
			<table cellpadding="1" cellspacing="1"  class="table-detail">
				<tr var="manageTr">
					<td var="index"><input class="pk" type="checkbox" name="select"></td>
					<td ><input type="text"  var="desc"  value="<spr:message code='bpmDataTemplate.functionButton.add'/>"  ></td>
					<td>&nbsp;
						<select var="name" >
							<option value="add"><spr:message code="bpmDataTemplate.functionButton.add"/></option>
							<option value="edit"><spr:message code="bpmDataTemplate.functionButton.edit"/></option>
							<option value="del"><spr:message code="bpmDataTemplate.functionButton.del"/></option>
							<option value="detail"><spr:message code="bpmDataTemplate.functionButton.detail"/></option>
							<option value="export"><spr:message code="bpmDataTemplate.functionButton.export"/></option>
							<option value="import"><spr:message code="bpmDataTemplate.functionButton.import"/></option>
							<option value="print"><spr:message code="bpmDataTemplate.functionButton.print"/></option>
							<option value="start"><spr:message code="bpmDataTemplate.functionButton.startprocess"/></option>
						</select>
					</td>
					<td var="manageRight">
					</td>
					<td>
						<a class="link moveup" href="#" onclick="__DataTemplate__.moveTr(this,true)"></a>
						<a class="link movedown" href="#" onclick="__DataTemplate__.moveTr(this,false)"></a>
						<a class="link del" href="#" onclick="__DataTemplate__.delTr(this)"></a>
					</td>
				</tr>
			</table>
		</div>
</div>

</body>
<style type="text/css">
		.tab-top{
			margin:0 0 0 0;
		}
		#bpmDataTemplate td{
			padding:2px 3px;
		}
		#bpmDataTemplate th{
			padding:2px 6px;
		}
		.even {
			height: 28px;
		}
		.odd {
			height: 28px;
		}
		.over{
			background: #FCF1CA;
		}
		.hide{
			display: none;
		}
		.moveSelect{
			margin:4px auto;
		}
		.leftHeader th{
			font-weight: bold;
            text-align: center;
		}
		
		.condition-cols{
			border: 1px solid  #A8CFEB;
			overflow: auto;
			height:400px;
			float:left;
			width: 29%;
		}
		.condition-conds{
			border-top: 1px solid  #A8CFEB;
			border-bottom: 1px solid  #A8CFEB;
			border-right: 1px solid  #A8CFEB;
			height:400px;
			float:left;
			width:70%;
		}
		.condition-cols-div{
			padding: 2px;
			height:394px;
		}
		.condition-conds-div{
			padding: 2px;
			height:400px;
		}
		.condition-conds-div-left{
			float:left;
			width:15%;
		}
		.condition-conds-div-left-div{
			border-right: 1px solid  #A8CFEB;
			text-align:center;
			vertical-align:middle;
			height:394px;
			padding-top: 180px;
		}
		.condition-conds-div-right{
			height:400px;
			overflow: auto;
			float:left;
			width:85%;
		}
		.condition-conds-div-right-div{
		
			height:390px;
			padding: 2px;
			margin: 1px;
		}
		
		.condition-script-div{
			border:  1px solid #A8CFEB;
			padding: 2px;
			height:394px;
			
		}
		.condition-script-div-script-editor{
			width:100%;
			height:348px;
		}
		
		.condition-script-div-parameters{
			height: 40px;
		}
		
		.condition-script-div-parameters-list{
			height: 36px;
			overflow: auto;
		}
		
		.condition-script-div-script{
			height:346px;
		}
		
		.condition-script-div-script-operate{
/* 			position: absolute; */
			margin-top: 5px;
		}
		
		
		/**排序*/
		.sort-cols{
			border: 1px solid  #A8CFEB;
			overflow: auto;
			height:400px;
			float:left;
			width: 29%;
		}
		.sort-conds{
			border-top: 1px solid  #A8CFEB;
			border-bottom: 1px solid  #A8CFEB;
			border-right: 1px solid  #A8CFEB;
			height:400px;
			float:left;
			width:70%;
		}
		.sort-cols-div{
			padding: 2px;
			height:394px;
		}
		.sort-conds-div{
			padding: 2px;
			height:400px;
		}
		.sort-conds-div-left{
			float:left;
			width:15%;
		}
		.sort-conds-div-left-div{
			border-right: 1px solid  #A8CFEB;
			text-align:center;
			vertical-align:middle;
			height:394px;
			padding-top: 180px;
		}
		.sort-conds-div-right{
			height:400px;
			overflow: auto;
			float:left;
			width:85%;
		}
		.sort-conds-div-right-div{
			height:390px;
			padding: 2px;
			margin: 1px;
		}
		
		.sort-script-div{
			border:  1px solid #A8CFEB;
			padding: 2px;
			height:394px;
			
		}
		.sort-script-div-script-editor{
			width:100%;
			height:348px;
		}
		
		.sort-script-div-parameters{
			height: 40px;
		}
		
		.sort-script-div-parameters-list{
			height: 36px;
			overflow: auto;
		}
		
		.sort-script-div-script{
			height:346px;
		}
		
		.sort-script-div-script-operate{
/* 			position: absolute; */
			margin-top: 5px;
		}
		
		.info{
			padding-right: 5px;
		}
		
		.info ul li{
			list-style: disc;
			margin-left: 30px;
		}
		.info font{
			color: red;
		}
		
	</style>
</html>