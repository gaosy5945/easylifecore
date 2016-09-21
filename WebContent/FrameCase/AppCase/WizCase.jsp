
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
 
 
 String[][] wizArray={
			{"010","客户详情","/FrameCase/ExampleInfo.jsp","CustomerID=1",""},
			{"020","交易信息","/FrameCase/ExampleInfo04.jsp","CustomerID=1",""},
			{"030","业务信息","/FrameCase/ExampleInfo03.jsp","CustomerID=1",""},
			{"040","分类信息","/FrameCase/UICaseMain.jsp","CustomerID=1",""},
		};
 

Wizard wiz=new Wizard(wizArray,sWebRootPath,true);
String sButtons[][] = { 
		{"true","","Button","保存","保存修改","saveRecord()","","","",""},//btn_icon_save 
	};
 %>
 <%@
 include file="/AppMain/resources/include/wiz_include.jsp"%>
 
 
<%@page import="com.amarsoft.app.als.sys.widget.Wizard"%><script type="text/javascript">
	function saveRecord(){
		curFrame=getCurWizFrame();
		if(typeof(getCurWizFrame)!="undefined" && curFrame.saveRecord){
				curFrame.saveRecord();
		}
	}
 
 </script>
 <%@ include file="/IncludeEnd.jsp"%>