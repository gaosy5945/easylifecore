<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String applyStatus=CurPage.getParameter("ApplyStatus");
	String approveStatus=CurPage.getParameter("ApproveStatus");
	String sSerialNo = CurPage.getParameter("SerialNo");
	
	if(applyStatus == null) applyStatus = "";
	if(approveStatus == null) approveStatus = "";
	if(sSerialNo == null) sSerialNo = "";
	String sWhereClause = ""; //Where����
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("UserID", CurUser.getUserID());
	inputParameter.setAttributeValue("OrgID", CurUser.getOrgID());
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("BreakContractApproList",inputParameter,CurPage);
	
	if(applyStatus=="1" || "1".equals(applyStatus)){
		sWhereClause = "  and O.ApproveStatus= '" + approveStatus + "' ";	
	} 
	
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereClause);	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	
	ASObjectWindow  dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("ApplyStatus", applyStatus);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		    {String.valueOf(applyStatus.equals("1")),"","Button","����","����","edit()","","","","btn_icon_detail",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit() {
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("BreakConfirmApply1","SerialNo="+serialNo+"&ReadType=ReadOnly");
		//AsControl.PopComp("/RiskClassify/BreakContractInfo.jsp", "SerialNo="+serialNo);
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
