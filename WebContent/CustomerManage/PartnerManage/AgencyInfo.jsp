<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	//��ȡ����
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null ) serialNo = "";
	String agencyType = CurPage.getParameter("AgencType");
	if(agencyType == null) agencyType = "";
	

	String templetNo = "AgencyInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function returnList(){
		OpenPage("/CustomerManage/PartnerManage/AgencyList.jsp","_self","");
	}
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		as_save(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
