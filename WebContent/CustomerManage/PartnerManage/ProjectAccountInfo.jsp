<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNoAcc");//账户表流水号
	if(serialNo==null) serialNo = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo==null) objectNo ="";
	
	String sTempletNo = "ProjectAccountInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("ObjectNo", objectNo);
	doTemp.setDefaultValue("ObjectType", "Project");
	doTemp.setDefaultValue("Status", "1");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"true","All","Button","返回","返回列表页面","goback()","","","",""},
			{"false","All","Button","暂存","暂存","saveTemp()","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	/**保存数据	 */
	function saveRecord(){
			//setItemValue(0,0,"TempSaveFlag","0");
			as_save(0,"goback();");
	}
	/*暂存*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	
	function goback(){
		OpenPage("/CustomerManage/PartnerManage/ProjectAccountList.jsp?ObjectNo=<%=objectNo%>",'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
