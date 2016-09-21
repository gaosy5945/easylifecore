<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: 我的工作台
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/28 页面重新整理，去除多余无用的HTML
								 syang 2009/10/20页面待处理工作提示整理，让这些页面可配置
								 				请参考代码表代码：PlantformTask的配置情况。
								 												增加一个未完成工作提示，只需要配置好相应页面URL地址即可，不需要再来修改此页面
								 syang 2009/12/10 工作台style样式文件分享，引入走马灯库，不再使用HTML走马灯效果
		注意：新增工作提示，请不要修改此页面，请参考代码[PlantformTask]的配置，只需要在该代码里配置好相应页面即可
	 */
	%>
<%/*~END~*/%>
<html>
<head>
	<title>日常工作提示</title>
	<link rel="stylesheet" href="<%=sWebRootPath%>/AppMain/resources/css/worktips.css">
	<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/worktips.css">
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody" style="background:transparent;">
	<div id="WindowDiv">
		<!-- 注意：新增工作提示，请不要修改此页面，请参考代码[PlantformTask]的配置，只需要在该代码里配置好相应页面即可 -->
		<!-- 工作任务 -->
		<div id="WorkPlanDiv">
			<table align='left' border="0" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" width="100%" >
	        <%
	        String sAllItemNo = "";
	    	//取出代码对象
	    	Item[] codeDef = CodeManager.getItems("PlantformTask");
	    	if(codeDef!=null&&codeDef.length>0){
	        	for(int i=0;i<codeDef.length;i++){
	        		Item vpItem = codeDef[i];
	    			String sItemNo = (String)vpItem.getItemNo();
	    			String sItemName = (String)vpItem.getItemName();
	    			String sRoleID = (String)vpItem.getRelativeCode();//配置的角色
	    			String sAttribute = (String)vpItem.getAttribute1();
	    			boolean bPass = false;
	    			
	    			//检查当前用户是否有查看的角色
	    			if(sRoleID == null || sRoleID.length() == 0){	//如果没有配置角色限制，则默认全部可见
	    				sRoleID = "";
	    				bPass = true;
	    			}
	    			if(bPass == false){
	    				String[] roleIDArray = sRoleID.split(",");
	    				for(int j=0;j<roleIDArray.length;j++){	//角色检查
	    					if(CurUser.hasRole(roleIDArray[j])){
	    						bPass = true;
	    						break;
	    					}
	    				}
	    			}
	    					
	    			//如果角色检查未通过，则不显示当前类别的数据了
	    			if(bPass == false){
	    				continue;
	    			}
	    			sAllItemNo += (","+sItemNo);
					%> 
					<tr>
						<td align="left" colspan="2"  background="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/workTipLine.gif" >
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<span style="display:inline-block;" id="Plus<%=sItemNo%>" >&nbsp;</span><!-- class="FilterIcon"  -->
										<span class="FilterIcon2" style="display:none" id="Minus<%=sItemNo%>" >&nbsp;</span>
									</td>
									<td>
										<b><a href="javascript:void(0);" ><%=sItemName%>&nbsp;<span id="CountSpan<%=sItemNo%>"></span>&nbsp;件；任务池中可办&nbsp;<span id="CountSpan1<%=sItemNo%>"></span>&nbsp;件</a></b>
									</td>
								</tr>
							</table>
	           </td>
					</tr>
   	     <!-- 内容区域 -->
					<tr>
						<td align="left" colspan="2" class="DataList" id="DataList<%=sItemNo%>"></td>
					</tr>
         <%
         		}
	    	}
	        if(sAllItemNo != null && sAllItemNo.length() > 0){
	        	sAllItemNo = sAllItemNo.substring(1,sAllItemNo.length());
	        }
         %>       		
				</table>
		</div>
	</div>
</body>
</html>



<script type="text/javascript">
   var num=0;
	$(document).ready(function(){
		sAllItemNo = "<%=sAllItemNo%>";
		CountPlantformRecur(sAllItemNo, 0); //异步等待递归函数
	});
	//--------------------------
</script>
<script type="text/javascript">
	function openFile(sDocNo){
	    AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&RightType=ReadOnly", "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//查看全部工作笔记
	function viewWorkRecord(){
		PopComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","NoteType=All","","");
	}
	
	/**
	 *统计待处理的业务数量 递归函数 yzheng
	 *@allItemNo 所有的编号 String
	 *@index 当前的索引号
 	 */
	function CountPlantformRecur(allItemNo, index)
	{
		//alert("tips");
		if(allItemNo == null || allItemNo.length == 0) return;
		var itemNoArray = allItemNo.split(",");
		
		if(index >= itemNoArray.length  || index < 0) return "done";  //递归终止条件
		
		var ItemNo = itemNoArray[index];  //获取当前索引指向的元素
		//alert(index + " : " + ItemNo);
		var xmlHttp = getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
		url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=0&CodeNo=PlantformTask";

		xmlHttp.onreadystatechange = function(){
			var message = "";
			var message1 = "";
			if (xmlHttp.readyState == 4  && xmlHttp.status == 200) {
				message = xmlHttp.responseText;
				message1 = xmlHttp.responseText;
				message=parseInt(message.split("@")[0]);
				message1 = parseInt(message1.split("@")[1]);
		 		//totalNum(message);
		 		//totalNum(message1);
				message="<font color=red>"+message+"</font>";
				message1="<font color=red>"+message1+"</font>";
				
				var rs = CountPlantformRecur(allItemNo, ++index);  //递归调用，前一个任务完成后再执行下一个，实现异步等待
				
				if(rs == "done");// parent.clickPrompt();
			}
			else{
				message = "<img border=0 src='<%=sWebRootPath%>/Frame/page/resources/images/main/icons/35.gif'>";
			}
			$("#CountSpan"+ItemNo).html(message);
			$("#CountSpan1"+ItemNo).html(message1);
		};
		
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		return;
	}
	
	function totalNum(message){
		 num+=message;
		 parent.aem[self.name].text(num);
		 //parent.window.setNum("TaskNum",num); 
	}
	
	/**
	 *点击相应的Trip时，展示相应的数据
	 *@ItemNo 编号
	 */
	 <%--function touchPlantform(ItemNo){
		 var xmlHttp = getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(eid("DataList"+ItemNo).innerHTML == ""){
			var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
			url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=1&CodeNo=PlantformTask";
			xmlHttp.onreadystatechange = function(){
				var message = "";
				if (xmlHttp.readyState == 4) {
					//message = genDataList(xmlHttp.responseText);
					message = xmlHttp.responseText;
				}else{
					message = "<img border=0 bordercolordark='#CCCCCC' src='<%=sWebRootPath%>/Frame/page/resources/images/main/icons/33.gif'>";
				}
				eid("DataList"+ItemNo).innerHTML=message;
			};
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
			eid("Plus"+ItemNo).style.display = "none";
			eid("Minus"+ItemNo).style.display = "block";
		}else{
			eid("DataList"+ItemNo).innerHTML = "";
			eid("Plus"+ItemNo).style.display = "block";
			eid("Minus"+ItemNo).style.display = "none";
		} 
	}--%>
	function eid(id){
		return document.getElementById(id);
	}

	function getXmlHttpObject() {
		var xmlHttp=null;
		try{
			  // Firefox, Opera 8.0+, Safari
			  xmlHttp=new XMLHttpRequest();
		  }catch (e) {
			  // Internet Explorer
			  try{
			    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
			  }catch (e){
			    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
			  }
	  	}
		return xmlHttp;
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>