<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	//获取参数
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null ) serialNo = "";
	String agencyType = CurPage.getParameter("AgencType");
	if(agencyType == null) agencyType = "";
	

	String templetNo = "AgencyInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function returnList(){
		OpenPage("/CustomerManage/PartnerManage/AgencyList.jsp","_self","");
	}
	/*~[Describe=保存数据;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		as_save(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
