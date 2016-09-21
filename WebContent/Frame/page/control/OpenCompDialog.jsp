<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//函狼由兆各
	String sProductName = CurConfig.getConfigure("ProductName");
	if (sProductName == null) sProductName = "";
	String sImplementationVersion = CurConfig.getConfigure("ImplementationVersion");
	if (sImplementationVersion == null) sImplementationVersion = "";
	String sComponentURL=CurPage.getParameter("ComponentURL");
	String sParaString=CurPage.getParameter("CompPara");
	String sDialogTitle = CurPage.getParameter("DialogTitle");
	
	if (sParaString == null)  sParaString = "";
	else sParaString = StringFunction.replace(sParaString,"$[and]","&");
%>
<html>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/comp_dialog.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/comp_dialog.css">
<head> 
<!-- 葎阻匈中胆鉱,萩音勣評茅和中 TITLE 嶄議腎鯉 -->
<title><%=sProductName%>V<%=sImplementationVersion%>
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body scroll=no onBeforeUnload="onClose(event)" onunload="destroyComp()">
<table height="100%" width="100%" cellspacing="0" cellpadding="0" border="0">
	<tr height="1">
		<td width="100%;">
			<span id="TopTitle"></span>
		</td>
		<td width="1">
			<span class="right_menu" style="white-space: nowrap;">
				<a class="refresh" href="#" onclick="refreshMe();" hidefocus>泡仟</a><a
				class="close" href="#" onclick="exitPopWindow();" hidefocus>購液</a>
			</span>
		</td>
	</tr>
	<tr height="100%" style="background:#fff;">
		<td colspan="2">
			<iframe name="ObjectList" width="100%" height="100%" frameborder="0"></iframe>
		</td>
	</tr>
</table>
</body>
</html>
<script type="text/javascript">
    var isWindowExit = false; 
	var sObjectInfo="";
	function closeAndReturn(){
		if(sObjectInfo==""){
			if(confirm(getHtmlMessage("44"))){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
		self.returnValue=sObjectInfo;
		self.close();
	}
    
	function cancleAndReturn(){
		sObjectInfo="_NONE_";
        self.returnValue=sObjectInfo;
		self.close();
	}
	
	function openComponentInMe(){
		AsControl.OpenView("<%=sComponentURL%>","<%=sParaString%>","ObjectList","");
	}

	function onClose(e){
		if(!e) e = window.event;
		if(checkFrameModified(self)) 
			e.returnValue=sUnloadMessage;
	}
	
	function destroyComp(){
		if (isWindowExit) {
			$.ajax({url: "<%=sWebRootPath%>/Frame/page/control/DestroyCompAction.jsp?ToDestroyClientID=<%=sCompClientID%>",async: false});
		}
		else {
			$.ajax({url: "<%=sWebRootPath%>/Frame/page/control/DestroyCompAction.jsp?ToDestroyClientID="+ObjectList.sCompClientID,async: false});
		}
	}
	
	function checkFrameModified(oFrame){
		try{
        	if(oFrame.bEditHtml && oFrame.bEditHtmlChange )
				return true;
		}catch(e){}
        
		if(typeof(oFrame.isModified)!="undefined"){
			for(var j=0;j<oFrame.frames.length;j++){ 	
				try{
					if(oFrame.bCheckBeforeUnload==false) continue;
					if(oFrame.isModified(oFrame.frames[j].name)) return true;
				}catch(e){}
			}
		}

		//殊臥和雫匈中議dw
		if(oFrame.frames.length==0) return false;
		for(var i=0;i<oFrame.frames.length;i++){
			if(checkFrameModified(oFrame.frames[i])) return true;
		}
		return false;
	}
	
	function refreshMe(){
		try{
			openComponentInMe();
		}catch(e){}
    }

	function reloadSelf(){
		refreshMe();
	}
    
	function exitPopWindow(){
		isWindowExit = true; 
		self.close();
    }
	
	function setTopTitle(title){
    	$("#TopTitle").show();
		$("#TopTitle").html(title);
    }
	function getTopTitle(){
		return $("#TopTitle").html();
    }
	document.onready = function() {
       <%if(sDialogTitle!=null && !sDialogTitle.equals("")) { %>setTopTitle("<%=sDialogTitle%>"); <%}%>
       <%if(sComponentURL!=null && !sComponentURL.equals("")) { %>openComponentInMe(); <%}%>
    };
</script>
<%@ include file="/IncludeEnd.jsp"%>