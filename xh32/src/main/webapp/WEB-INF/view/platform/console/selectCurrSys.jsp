<%@page pageEncoding="UTF-8" autoFlush="true" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="f" uri="http://www.jee-soft.cn/functions" %> 
<%@taglib prefix="spr" uri="http://www.springframework.org/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><spr:message code="homePage.selectSys.title" /></title>
	<f:link href="choose_sys.css"></f:link>
	<link rel="stylesheet" type="text/css" href="${ctx}/styles/login/login.css"></link>
    <script type="text/javascript" src="${ctx }/js/jquery/jquery.js" ></script>
    <script type="text/javascript" src="${ctx }/js/util/util.js"  ></script>
    <script type="text/javascript" src="${ctx}/js/util/form.js"></script>
    <script language="JavaScript"> 
	
	function showSubSystemList(){
		if($(".show_sys").css("display")=="none"){
			$(".show_sys").css("display","block");
		}else{
			$(".show_sys").css("display","none");
		}	
	}
	
	$(function(){
		$('#selectUl > li').click(function(){
			//alert($(this).attr('id'));
			$(".show_sys").css("display","none");
			$('#select_sys').html(this.innerHTML);
			
			var id=$(this).attr('id');
			if(id){
				saveCurrentSys(id);
			}
		});
	});

	function saveCurrentSys(systemId){
		var form=new com.hotent.form.Form();
		form.creatForm("form", "${ctx}/platform/console/saveCurrSys.ht");
		form.addFormEl("systemId", systemId);
		form.submit();
	};
	
</script>
</head>
<body>
						<div class="top_login">
							<span class="htlogo_login l"></span>
							<span class="r"><spr:message code="homePage.selectSys.topLogin" />&nbsp;&nbsp;&nbsp;</span>
						</div>
						<center>
                        <div class="main_login2">
                        		  <span class="bpmlogo_login logo2"></span>
                  				  <div class="content_login">  
                  				  <div class="column">  
                  				 			 <span><spr:message code="homePage.selectSys.select" />:</span><br>              				  
                                			<div class="select_sys"><span id="select_sys"></span><img src="${ctx}/styles/default/images/jiantou.jpg" class="show_sys_choose" onclick="showSubSystemList()"/></div>
                               	  
                               				<c:choose> 				
													<c:when test="${fn:length(subSystemList) > 0}">  
														<div class="show_sys">
															<ul id="selectUl">
																<c:forEach var="subSystemItem" items="${subSystemList}"> 
																	<li id="${subSystemItem.systemId}"><a href="#" onclick="saveCurrentSys(${subSystemItem.systemId})">${subSystemItem.sysName}</a></li>
																</c:forEach>  
															</ul>
														</div>
													</c:when>
                                            		<c:otherwise>
													<span class="label">
														<spr:message code="homePage.selectSys.noPermission" />
													</span>
												</c:otherwise>
                                       	    </c:choose>
                                       	    </div>
                                  </div>
                        </div>
                        <div class="copy">&copy;权所有 广州宏天软件 2008-2013 粤ICP备09066681号</div>
                        </center>
							
</body>
</html>
