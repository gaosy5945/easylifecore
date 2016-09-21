<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String status=CurPage.getParameter("Status");
	String sSerialNo = CurPage.getParameter("SerialNo");
	
	if(sSerialNo == null) sSerialNo = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("UserID", CurUser.getUserID());
	inputParameter.setAttributeValue("OrgID", CurUser.getOrgID());
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("BreakContractList1",inputParameter,CurPage);
	ASObjectWindow  dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("Status", status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","deal()","","","","",""},
		    {String.valueOf(status.equals("1")),"","Button","����","����","edit()","","","","btn_icon_detail",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function deal(){
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		AsCredit.openFunction("BreakConfirmApply1","SerialNo="+serialNo);			
		reloadSelf();
	}
	function edit() {
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("BreakConfirmApply1","SerialNo="+serialNo+"&ReadType=ReadOnly");	
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
