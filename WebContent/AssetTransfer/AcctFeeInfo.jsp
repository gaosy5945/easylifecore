<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String sSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//���÷�����ˮ��
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//��Ŀ���
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//��Ŀ����
	String sTempletNo = "ProjectAssetAcctFeeInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setReadOnly("ObjectNo,ObjectType", true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setPageSize(30);
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","asSave()","","","",""},
		{"true","","Button","����","�����б�","returnList()","","","",""}
	};
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function asSave(){
		setItemValue(0,0,"ObjectNo",'<%=sObjectNo%>');
		setItemValue(0,0,"ObjectType",'<%=sObjectType%>'); 
		as_save("myiframe0","");
	}

	function returnList(){
		AsControl.OpenPage("/ProjectManage/ProjectAssetTransfer/ProjectAssetAcctFeeList.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
