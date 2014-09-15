<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html" %>
<html>
<head>
	<title></title>
	<%@include file="/commons/include/form.jsp" %>
	<f:js pre="js/lang/view/platform/system" ></f:js>
    <f:link href="tree/zTreeStyle.css"></f:link>
	<script type="text/javascript" src="${ctx}/servlet/ValidJs?form=outMail"></script>
	<script type="text/javascript" src="${ctx}/js/ckeditor/ckeditor.js"></script>
    <script type="text/javascript" src="${ctx}/js/hotent/platform/mail/MailDef.js"></script>
    <script type="text/javascript" src="${ctx}/js/lg/plugins/ligerLayout.js"></script>
	<script type="text/javascript" src="${ctx}/js/tree/jquery.ztree.js"></script>
	<link href="${ctx}/js/jquery/plugins/attach.css" rel="stylesheet" />
	<script type="text/javascript" src="${ctx}/js/jquery/plugins/jquery.attach.js" ></script>
	<style type="text/css">
	html,body{ padding:0px; margin:0; width:100%;height:100%;overflow: hidden;} 

	.tree-title{overflow:hidden;width:8000px;}
	.ztree{overflow: auto;}
	.link-btn {
	cursor: pointer;
	display: inline-block;
	padding: 0 4px 1px 20px;
	}
	.link-remove {
		background: url(${ctx}/styles/default/images/button/remove.png) 0px 3px no-repeat !important;
		text-decoration: none;
	}
	</style>
	<script type="text/javascript">
		$(function() {
			loadTree();
			layout();
			function showRequest(formData, jqForm, options){return true;} 
			OutMailDef.getEditor();
			var editor=CKEDITOR.instances.content;
			
			valid(showRequest,showResponse);
			$("a.run").click(function() {
				var rtn=$("#outMailForm").valid();
				if(!rtn) return;
				$.ligerDialog.waitting($lang_system.outMail.wail_send);
				var content=editor.getData();
				$('#types').val(2);
				$('#isReply').val(0);
				$("#content").attr('value', content);
				$('#outMailForm').submit();
			});
			$('#dataFormDraft').click(function() {
				var rtn=$("#outMailForm").valid();
				if(!rtn) return;
				var content=editor.getData();
				$("#content").attr('value',content);
				$('#types').val(3);
				$('#isReply').val(0);
				$('#outMailForm').submit(); 
			});
			$("input[address='true']").click(changeClass);
		});
		
		function showResponse(responseText){
			var type=$('#types').val();
			var obj=new com.hotent.form.ResultMessage(responseText);
			$.ligerDialog.closeWaitting();
			var setId=$("select option:selected").attr('address');
			if(obj.isSuccess()){//成功
				$.ligerDialog.success(obj.getMessage(),$lang_system.outMail.email_success,function(){
					window.location.href="${ctx}/platform/mail/outMail/list.ht?id="+setId+"&&types="+type; 		
				});
		    }else{//失败
		    	$.ligerDialog.error(obj.getMessage());
		    }
		};
		
        //重 置
        function reset(obj) {
        	$('#receiverAddresses').val('');
			$('#ccAddresses').val('');
			$('#bcCAddresses').val('');
			$('#title').val('');
        	$('#fileIds').val('{"attachs":[]}');
        	$('#fileIdsShow').html('');
		}
        
		//布局
		function layout(){
			$("#layout").ligerLayout( {
				leftWidth : 230,
				onHeightChanged: heightChanged
			});
			//取得layout的高度
	        var height = $(".l-layout-center").height();
	        $("#linkmanTree").height(height-60);
		};
		
		//布局大小改变的时候通知tab，面板改变大小
	    function heightChanged(options){
	     	$("#linkmanTree").height(options.middleHeight - 60);
	    };
	    
		//树
		var linkmanTree;
		
		//加载树
		function loadTree(){
			var setting = {
				data: {
					key : {
						name: "linkAddress"
					},
					simpleData: {
						enable: true,
						idKey: "linkId"
					}
				},
				view:{
					showIcon:false
				},
				callback:{
					onClick: zTreeOnLeftClick
				}
			};
			$.post("${ctx}/platform/mail/outMailLinkman/getOutMailLinkmanData.ht",function(result){
					linkmanTree= $.fn.zTree.init($("#linkmanTree"), setting, result);}
			);
		};
		
		//左击
		function zTreeOnLeftClick(event, treeId, treeNode){
			var txtAddress=$("input.focus[address='true']");
			if(txtAddress.length==0){
				 $.ligerDialog.warn($lang_system.outMail.please_input_address,$lang_tip.msg);
				 return;
			}
			var address=treeNode.linkAddress;
			address=address.substring(address.indexOf('(')+1,address.indexOf(')'));
			var thistemp=txtAddress.val();
			if(thistemp==''){
				txtAddress.val(address);
			}else{
				var arrtemp=thistemp.split(',');
				for(var i=0;i<arrtemp.length;i++){
					if(arrtemp[i]==address){
						txtAddress.val(thistemp); break;
					}else{
						txtAddress.val(thistemp+","+address);
					}
				}
			}
		};
		
		//改变样式
		function changeClass() {
			var obj=$(this);
			var aryAddress=$("input[address='true']");
			aryAddress.attr('class', 'inputText');
			obj.attr('class', "focus");
		};
		
	</script>
</head>
<body>  
	<div id="layout">
		<div position="right" title="<spr:message code='outMail.recentContacts'/>">
			<div id="linkmanTree" class="ztree"></div>
		</div>
		<div id="editor" position="center"  style="overflow: auto;">
			<div position="center">
				<div class="panel">
					<div class="panel-top">
						<div class="tbar-title">
							<span class="tbar-label"><spr:message code="outMail.newEmail"/></span>
						</div>
						<div class="panel-toolbar">
							<div class="toolBar">
							    <div class="group"><a class="link run" id="dataFormSave"><span></span><spr:message code="outMail.sendEmail"/></a></div>
								<div class="l-bar-separator"></div>
							    <div class="group"><a class="link save" id="dataFormDraft"><span></span><spr:message code="outMail.saveDrafts"/></a></div>
								<div class="l-bar-separator"></div>
							    <div class="group"><a class="link undo" id="dataFormRest" onclick="reset(this)"><span></span><spr:message code="menu.button.reset"/></a></div>
							</div>
						</div>
					</div>
					<div class="panel-body">
						<form id="outMailForm" method="post" action="send.ht" >
							<table class="table-detail" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<th width="15%"><spr:message code="outMail.sender"/>:<span class="required">*</span></th>
									<td>
								    <select id="senderAddresses"  name="senderAddresses" style="width: 35%;">
										<c:forEach items="${outMailUserSetingList}" var="mail">
										    <option value="${mail.mailAddress}" address="${mail.id}" <c:if test="${mail.isDefault==1}">selected='selected'</c:if>>${mail.mailAddress}</option>
									    </c:forEach>
									</select>
								</tr>
								<tr>
									<th width="15%"><spr:message code="outMail.receiver"/>:<span class="required">*</span></th>
									<td height="45" ><input type="text" address="true"  id="receiverAddresses" name="receiverAddresses" value="${outMail.receiverAddresses}"  class="inputText" style="width: 80%;"/><br>(注：可以直接单击最近联系人列表，也可手动输入，多个收件人以","号分割如两个收件人：aaa@163.com,bbb@163.com)</td>
								</tr>
								<tr>
									<th width="15%"><spr:message code="outMail.ccer"/>: </th>
									<td><input type="text" address="true"  id="ccAddresses" name="ccAddresses" value="${outMail.ccAddresses}"  class="inputText"  style="width: 80%;"/></td>
								</tr>
								<tr>
									<th width="15%"><spr:message code="outMail.bcCer"/>: </th>
									<td><input type="text" address="true"  id="bcCAddresses" name="bcCAddresses" value="${outMail.bcCAddresses}"  class="inputText"  style="width: 80%;"/></td>
								</tr>
								<tr>
									<th width="15%"><spr:message code="outMail.title"/>: </th>
									<td><input type="text" id="title" name="title" value="${outMail.title}"  class="inputText"  style="width: 80%;"/></td>
								</tr>
								<tr>
									<th width="15%"><spr:message code="outMail.file"/>: </th>
									<td>
										<input type="text" name="fileIds" id="fileIds" class="attach" attachType="2" value="${outMail.fileIds}" />
									</td>
								</tr>
								<tr>
									<td colspan="2">
									<textarea  name="content" id="content" >${outMail.content}</textarea>
									</td>
								</tr>
							</table>
						
							<input type="hidden" name="mailId" value="${outMail.mailId}" />
							<input name="types" id="types" type="hidden" value="${mail.mailAddress}"/> 
							<input type="hidden" id="isReply" name="isReply" value="${mail.isReply}"/>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
