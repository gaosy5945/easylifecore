
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
 
 
 String[][] wizArray={
			{"010","�ͻ�����","/FrameCase/ExampleInfo.jsp","CustomerID=1",""},
			{"020","������Ϣ","/FrameCase/ExampleInfo04.jsp","CustomerID=1",""},
			{"030","ҵ����Ϣ","/FrameCase/ExampleInfo03.jsp","CustomerID=1",""},
			{"040","������Ϣ","/FrameCase/UICaseMain.jsp","CustomerID=1",""},
		};
 

Wizard wiz=new Wizard(wizArray,sWebRootPath,true);
String sButtons[][] = { 
		{"true","","Button","����","�����޸�","saveRecord()","","","",""},//btn_icon_save 
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