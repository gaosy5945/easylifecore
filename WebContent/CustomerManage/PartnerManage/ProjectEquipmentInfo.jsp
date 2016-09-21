<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");//合作项目编号
	String PSerialNo = CurPage.getParameter("PSerialNo");//资产买卖流水号
	
	String sTempletNo = "ProjectEquipmentInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(PSerialNo);
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"false","All","Button","暂存","暂存","saveTemp()","","","",""},
			{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	/**保存数据	 */
	function saveRecord(){
			setItemValue(0,0,"TempSaveFlag","0");
			as_save(0);
	}
	/*暂存*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	/*返回列表*/
	function returnList(){
		OpenPage("/CustomerManage/PartnerManage/ProjectEquipmentList.jsp", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
