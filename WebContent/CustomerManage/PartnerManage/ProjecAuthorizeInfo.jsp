<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String projectNo = CurPage.getParameter("ProjectNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "ProjecAuthorizeInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","goBack()","","","",""},
		{"false","All","Button","�ݴ�","�ݴ�","saveTemp()","","","",""}
	};
//	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	/**��������	 */
	function saveRecord(){
		setItemValue(0,0,"ConsignerIssueCountry",getItemValue(0,0,"ConsignerIssueCountryName"));
//		setItemValue(0,0,"TempSaveFlag","0");
		as_save(0);
	}
	/*�ݴ�*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	
	function goBack(){
		var sUrl = "/CustomerManage/PartnerManage/ProjectAuthorizeList.jsp?SerialNo=<%=projectNo%>";
		 OpenPage(sUrl,'_self','');
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>