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
	<title>业务预警</title>
	<link rel="stylesheet" href="<%=sWebRootPath%>/AppMain/resources/css/worktips.css">
	<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/worktips.css">
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody" style="background:transparent;">
	<div id="WindowDiv">
		<div id="WorkPlanDiv">
			<table align='left' border="0" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" width="100%" >
	        <%
	        String sAllItemNo = "";
	    	//取出代码对象
	    	Item[] codeDef = CodeManager.getItems("AlarmMain");
	    	if(codeDef!=null&&codeDef.length>0){
				for(int i=0;i<codeDef.length;i++){
	        		Item vpItem = codeDef[i];
	    			String sItemNo = (String)vpItem.getItemNo();
	    			String sItemName = (String)vpItem.getItemName();
	    			String sAttribute = (String)vpItem.getAttribute1();

	    			sAllItemNo += (","+sItemNo);
					%> 
					<tr>
						<td align="left" colspan="2"  background="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/workTipLine.gif" >
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td onclick="javascript:touchPlantform('<%=sItemNo%>');">
										<span class="FilterIcon" style="display:inline-block;" id="Plus<%=sItemNo%>" >&nbsp;</span>
										<span class="FilterIcon2" style="display:none" id="Minus<%=sItemNo%>" >&nbsp;</span>
									</td>
									<td onclick="javascript:touchPlantform('<%=sItemNo%>');">
										<b><a href="javascript:void(0);" ><%=sItemName%>&nbsp;<span id="CountSpan<%=sItemNo%>"></span>&nbsp;件</a></b>
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
		

<script type="text/javascript">
    var num=0;
	$(document).ready(function(){
		
		//加载工作待处理工作提示
		sAllItemNo = "<%=sAllItemNo%>";
// 		ItemNoArray = sAllItemNo.split(",");
// 		for(var i=0;i<ItemNoArray.length;i++){
// 			CountPlantform(ItemNoArray[i]); 
// 		}
		CountPlantformRecur(sAllItemNo, 0); //异步等待递归函数
	});
	//--------------------------
</script>
<script type="text/javascript">
	/**
	 *统计待处理的业务数量 递归函数 yzheng
	 *@allItemNo 所有的编号 String
	 *@index 当前的索引号
		 */
	function CountPlantformRecur(allItemNo, index)
	{
		//alert("alarm");
		if(allItemNo == null || allItemNo.length == 0) return;
		var itemNoArray = allItemNo.split(",");
		
		if(index >= itemNoArray.length  || index < 0) return "done";  //递归终止条件
		
		var ItemNo = itemNoArray[index];  //获取当前索引指向的元素
		var xmlHttp = getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
		url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=0&CodeNo=AlarmMain";
		xmlHttp.onreadystatechange = function(){
			var message = "";
			if (xmlHttp.readyState == 4  && xmlHttp.status == 200) {
				message = xmlHttp.responseText;
				message=parseInt(message);
				totalNum(message);
				message="<font color=red>"+message+"</font>";
				
				CountPlantformRecur(allItemNo, ++index);  //递归调用，前一个任务完成后再执行下一个，实现异步等待
			}
			else{
				message = "<img border=0 src='<%=sWebRootPath%>/Frame/page/resources/images/main/icons/35.gif'>";
			}
			$("#CountSpan"+ItemNo).html(message);
		};
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		return;
	}
	
	function totalNum(message){
		 num+=message;
		 parent.aem[self.name].text(num);
		 //parent.window.setNum("WarningNum",num); 
	}
	
	/**
	 *点击相应的Trip时，展示相应的数据
	 *@ItemNo 编号
	 */
	function touchPlantform(ItemNo){
		var xmlHttp = getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(eid("DataList"+ItemNo).innerHTML == ""){
			var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
			url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=1&CodeNo=AlarmMain";
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
	}
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