<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	
	String sTempletNo = "CadReInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("LISTTYPE", listType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","as_save(0)","","","","",""},
			{"true","","Button","����","����","goBack()","","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

function initRow(){
	setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
	setItemValue(0,0,"BEGINDATE","<%=StringFunction.getToday()%>");
	setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
	setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
}
function goBack(){
	OpenPage("/CustomerManage/SpecialCustomerManage/CadReList.jsp","_self","");
}
initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
