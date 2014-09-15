<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" import="com.hotent.platform.model.system.GlobalType"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="f" uri="http://www.jee-soft.cn/functions" %>
<%@ taglib prefix="spr" uri="http://www.springframework.org/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%@include file="/commons/include/html_doctype.html" %>
<html>
<head>
	<title><spr:message code="dictionary"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<f:link href="Aqua/css/ligerui-all.css"></f:link>
	<f:link href="tree/zTreeStyle.css"></f:link>
	<f:link href="web.css" ></f:link>
	<f:js pre="js/lang/common" ></f:js>
	<f:js pre="js/lang/js" ></f:js>
	<f:js pre="js/lang/view/platform/system" ></f:js>
	<script type="text/javascript" src="${ctx}/js/dynamic.jsp"></script>
	<script type="text/javascript" src="${ctx}/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${ctx}/js/lg/ligerui.min.js"></script>
	<script type="text/javascript" src="${ctx}/js/util/util.js"></script>
	<script type="text/javascript" src="${ctx}/js/util/form.js"></script>
	<script type="text/javascript" src="${ctx}/js/tree/jquery.ztree.js"></script>
	<script type="text/javascript" src="${ctx}/js/hotent/platform/form/GlobalType.js"></script>
	<script type="text/javascript" src="${ctx}/js/hotent/platform/system/GlobalMenu.js"></script>
	<script type="text/javascript">
		var catKey="<%=GlobalType.CAT_DIC%>";
		var menuMenu;
		var dictTree;
		var dicMenu=new DicMenu();
		var curMenu;
		var selectDictionaryId=0;
			
		var globalType=new GlobalType(catKey,"glTypeTree",
			{
				onClick:zTreeOnLeftClick,
				onRightClick:catRightClick,
				expandByDepth:0
			}
		);
		
		$(function(){
			layout();
			globalType.loadGlobalTree();
		});
	
		//布局
		function layout(){
			$("#layout").ligerLayout( {leftWidth : 210,height: '100%', onHeightChanged: heightChanged});
			//取得layout的高度
	        var height = $(".l-layout-center").height();
			
	        $("#glTypeTree").height(height-60);
		};
		//布局大小改变的时候通知tab，面板改变大小
	    function heightChanged(options){
	     	//$("#glTypeTree").height(options.middleHeight - 60);
	    };
	    
	    function hiddenMenu(){
			if(curMenu){
				curMenu.hide();
			}
			if(menuMenu){
				menuMenu.hide();
			}
		}
	    
	    function loadTree(){
	    	globalType.loadGlobalTree();
	    }
	    
	    function handler(item){
           	hiddenMenu();
           	var txt=item.text;
           	switch(txt){
           		case $lang_system.globalType.tree.dicMenu.text_menu_add:
           			globalType.openGlobalTypeDlg(true);
           			break;
           		case $lang_system.globalType.tree.dicMenu.text_menu_edit:
           			globalType.openGlobalTypeDlg(false);
           			break;
           		case $lang_system.globalType.tree.dicMenu.text_menu_sort:
           			globalType.sortNode();
           			break;
           		case $lang_system.globalType.tree.dicMenu.text_menu_del:
           			globalType.delNode();
           			break;
           	}
        }
		
	
		/**
    	 * 树右击事件
    	 */
    	function catRightClick(event, treeId, treeNode) {
    		hiddenMenu();
    		if (treeNode) {
    			globalType.currentNode=treeNode;
    			globalType.glTypeTree.selectNode(treeNode);
    			curMenu=dicMenu.getMenu(treeNode, handler);
    			if(curMenu){
    				curMenu.show({ top: event.pageY, left: event.pageX });	
    			}
    		}
    	};
		
		
		//左击
		function zTreeOnLeftClick(treeNode){
			if(treeNode.isRoot==undefined){
				loadDictByTypeId();
			}
				
		};
		//展开收起
		function treeExpandAll(type){
			globalType.treeExpandAll(type);
		};

		
		/**
		*获取选择的节点。
		*/
		function getSelectNode(){
			dictTree = $.fn.zTree.getZTreeObj("dictTree");
			var nodes = dictTree.getSelectedNodes();
			if(nodes){
				selectDictionaryId=nodes[0].dicId;
				return nodes[0];
			}
			return null;
		}

		//加载数据字典
		function loadDictByTypeId(){
			
			var selectNode=globalType.currentNode;
			if(!selectNode){
				$.ligerDialog.warn($lang_system.dictionary.tree.warn_msg_load_noNode);
				return;
			}
			var dropInner=selectNode.type==1;
			
			var typeId=selectNode.typeId;
			var setting = {
					edit: {
						drag: {
							prev: true,
							inner: dropInner,
							next: true,
							isMove:true
						},
						enable: true,
						showRemoveBtn: false,
						showRenameBtn: false
					},
					data: {
						key : {name: "itemName"},
						simpleData: {enable: true,idKey: "dicId",pIdKey: "parentId"}
					},
					view: {selectedMulti: false},
					callback:{onRightClick: dictRightClick,
						onDrop: onDrop,beforeDrop:onBeforeDrop }
				};
			var url="${ctx}/platform/system/dictionary/getByTypeId.ht";
			var params={typeId:typeId};
			
			$.post(url,params,function(result){
				updDicRootNode(result);
				dictTree=$.fn.zTree.init($("#dictTree"), setting,result);

				var expandDepth = 0;
				if(expandDepth!=0)
				{
					dictTree.expandAll(false);
					var nodes = dictTree.getNodesByFilter(function(node){
						return (node.level < expandDepth);
					});
					if(nodes.length>0){
						for(var i=0;i<nodes.length;i++){
							dictTree.expandNode(nodes[i],true,false);
						}
					}
				}
				
				if(selectDictionaryId>0){
					var node = dictTree.getNodeByParam("dicId", selectDictionaryId, null);
					dictTree.selectNode(node);
				}
			});
		}
		
		function onBeforeDrop(treeId, treeNodes, targetNode, moveType){
			if(targetNode.isRoot==1 && moveType!="inner"){
				return false;
			}
			return true;
		}
		
		function onDrop(event, treeId, treeNodes, targetNode, moveType) {
			if(targetNode==null || targetNode==undefined) return false;
			var targetId=targetNode.dicId;
			var dragId=treeNodes[0].dicId;
			var url=__ctx + "/platform/system/dictionary/move.ht";
			var params={targetId:targetId,dragId:dragId,moveType:moveType};

			$.post(url,params,function(result){});
		}
		
		//标记根节点。
		function updDicRootNode(result){
			for(var i=0;i<result.length;i++){
				var node=result[i];
				if(node.parentId==0){
					node.isRoot=1;
					node.parentId==0;
					node.icon=__ctx + "/styles/default/images/icon/root.png";
					break;
				}
			}
		}
		
		//编辑字典数据
		function editDict(){
			var selectNode=getSelectNode();
			var dicId=selectNode.dicId;
			
			if(selectNode.isRoot==1){
				return ;
			}
			var url="${ctx}/platform/system/dictionary/edit.ht?dicId=" + dicId +"&isAdd=0";
			var winArgs="dialogWidth=450px;dialogHeight=200px;help=no;status=no;scroll=no;center=yes";
			var conf={callBack:function(){
				loadDictByTypeId();
			}};
			hiddenMenu();
			url=url.getNewUrl();
			var rtn=window.showModalDialog(url,conf,winArgs);
			
		}
		
		function dictRightClick(e, treeId, treeNode){
			if (treeNode) {
				dictTree.selectNode(treeNode);
				var menuMenu=getDictMenu(treeNode);
				menuMenu.show({ top: e.pageY, left: e.pageX });
			}
		}
		
		function getDictMenu(treeNode){
			var items=new Array();
			if(treeNode.isRoot==1){
				items.push({ text: $lang_system.dictionary.tree.text_menu_add, click:addDict  });
				items.push({ text: $lang_system.dictionary.tree.text_menu_sort, click:sortDict });
			}
			else{
				if(treeNode.type==1){
					items.push({ text: $lang_system.dictionary.tree.text_menu_add, click:addDict  });
				}
				items.push({ text: $lang_system.dictionary.tree.text_menu_edit, click:editDict  });
				items.push({ text: $lang_system.dictionary.tree.text_menu_sort, click:sortDict });
				items.push({ text: $lang_system.dictionary.tree.text_menu_del, click:delDict });
			}
			menuMenu=$.ligerMenu({ top: 100, left: 100, width: 120, items:items});
			return menuMenu;
		}
		
		//增加字典
		function addDict(){
			var selectNode=getSelectNode();
			var dicId=selectNode.dicId;
			var url="${ctx}/platform/system/dictionary/edit.ht?dicId=" + dicId +"&isAdd=1";
			if(selectNode.isRoot){
				url+="&isRoot=1";
			}
			var winArgs="dialogWidth=450px;dialogHeight=200px;help=no;status=no;scroll=no;center=yes";
			var conf={callBack:function(){
				loadDictByTypeId();
			}};
			hiddenMenu();
			url=url.getNewUrl();
			var rtn=window.showModalDialog(url,conf,winArgs);
			
		}
		//数字字典排序
		function sortDict(){
			var selectNode=getSelectNode();
			var dicId=selectNode.dicId;
			var url="${ctx}/platform/system/dictionary/sortList.ht?parentId=" + dicId;
			var winArgs="dialogWidth=450px;dialogHeight=300px;help=no;status=no;scroll=no;center=yes";
			var conf={callBack:function(){
				loadDictByTypeId();
			}};
			hiddenMenu();
			url=url.getNewUrl();
			var rtn=window.showModalDialog(url,conf,winArgs);
			loadDictByTypeId();
		}
		//删除字典
		function delDict(){
			var callback=function(rtn){
				if(!rtn) return;
				var selectNode=getSelectNode();
				var dicId=selectNode.dicId;
				selectDictionaryId=selectNode.getParentNode().dicId;
			
				var url="${ctx}/platform/system/dictionary/del.ht";
				var params={dicId:dicId };
				$.post(url,params,function(responseText){
					
					var obj=new  com.hotent.form.ResultMessage(responseText);
					if(obj.isSuccess()){
						$.ligerDialog.success($lang_system.dictionary.tree.success_msg_del,$lang.tip.msg,function(){
							loadDictByTypeId();
						});
					}
					else{
						$.ligerDialog.error($lang_system.dictionary.tree.error_msg_del,$lang.tip.error);
					}
				});
			};
			$.ligerDialog.confirm($lang_system.dictionary.tree.confirm_msg_del,$lang.tip.confirm,callback);
		}
		
	</script>
	
	<style type="text/css">
		.ztree{overflow: auto;clear: both;}
		html,body{ padding:0px; margin:0; width:100%;height:100%;overflow: hidden;}
	</style>
</head>
<body>
<div id="layout">
	<div position="left"  title='<spr:message code="dictionary"/><spr:message code="title.category"/>'>
		<div class="tree-toolbar">
			<span class="toolBar">
				<div class="group"><a class="link reload" id="treeFresh" href="javascript:loadTree();" ></a></div>
				<div class="l-bar-separator"></div>
				<div class="group"><a class="link expand" id="treeExpandAll" href="javascript:treeExpandAll(true)" ></a></div>
				<div class="l-bar-separator"></div>
				<div class="group"><a class="link collapse" id="treeCollapseAll" href="javascript:treeExpandAll(false)" ></a></div>
			</span>
		</div>
		<div id="glTypeTree" class="ztree"></div>
	</div>
	<div position="center" title='<spr:message code="dictionary.tree.center.title"/>'>
		<div id="dictTree" class="ztree"></div>
	</div>
	
</div>
</body>
</html>

