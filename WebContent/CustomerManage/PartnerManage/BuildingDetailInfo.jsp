<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("PSerialNo");
	if(serialNo == null) serialNo = "";//¥����Ϣ��ˮ��
	
	String estateNo = CurPage.getParameter("EstateNo");
	if(estateNo == null) estateNo = "";//¥�̺�

	String sTempletNo = "BuildingDetailInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0,'thisReload();')","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function thisReload(){
		parent.OpenPage("/CustomerManage/PartnerManage/BuildingDetailList.jsp","rightup","");
	}
	setItemValue(0,0,"EstateNo","<%=estateNo%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
