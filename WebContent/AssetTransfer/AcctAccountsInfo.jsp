<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//�˻���Ϣ��ˮ��
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//��Ŀ���
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//��Ŀ����

	String sTempletNo = "AcctAccountsInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","asSave()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function asSave(){
		setItemValue(0,0,"ObjectNo",'<%=sObjectNo%>');
		setItemValue(0,0,"ObjectType",'<%=sObjectType%>');
		as_save(0);
	}
	
	function returnList(){
		OpenPage("/AssetTransfer/AcctAccountsList.jsp", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
