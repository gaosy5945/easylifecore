<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "�����˻���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String sObjectNo = CurPage.getParameter("OBJECTNO");
	String sObjectType = CurPage.getParameter("OBJECTTYPE");
	String accountIndicator =CurPage.getParameter("ACCOUNTINDICATOR");
	String status = CurPage.getParameter("STATUS");
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	String templateNo="FixAccountsInfo03";

	if("0".equals(status) ) templateNo ="FixAccountsInfo05";
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(templateNo,BusinessObject.createBusinessObject(),CurPage);
	
	doTemp.appendJboWhere(" and Status in('"+status.replaceAll("@","','")+"')");
	if(accountIndicator != null && !"".equals(accountIndicator)) 
		doTemp.appendJboWhere(" and AccountIndicator in('"+accountIndicator.replaceAll("@","','")+"')");
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp, CurPage, request);
	
	dwTemp.setParameter("ObjectType", sObjectType);
	dwTemp.setParameter("ObjectNo", sObjectNo);
	dwTemp.genHTMLObjectWindow("");

	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		
		if(!checkAccount()) return;
		
		if(!iV_all(0)) return;
		as_save(0);
	}
	
	function checkAccount(){
		if(!iV_all(0)) return;
		//�˻����� ���Ϊ�ſ��˻���Ϊ������Ա������Ϊ�����˻�������ֻ�ܱ���һ���ٴγ������ܱ���
		var accountIndicator = getItemValue(0,getRow(),"AccountIndicator");
		var status = getItemValue(0,getRow(),"Status");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var accountType = getItemValue(0, getRow(), "AccountType");
		var accountNo = getItemValue(0, getRow(), "AccountNo");
		var accountName = getItemValue(0, getRow(), "AccountName");
		var accountCurrency = getItemValue(0, getRow(), "AccountCurrency");
		if("0" == accountType || "1" == accountType || "7" == accountType)
		{
			var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName",accountIndicator+","+accountNo+","+accountType+","+accountName+","+accountCurrency);
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
			if(returnValue.split("@")[0] == "false"){
				alert(returnValue.split("@")[1]);
				return false;
			}else{
				setItemValue(0, getRow(0), "AccountNo1", returnValue.split("@")[1]);
				setItemValue(0, getRow(0), "AccountName", returnValue.split("@")[2]);
				setItemValue(0, getRow(0), "CustomerID", returnValue.split("@")[3]);
				setItemValue(0, getRow(0), "MFCustomerID", returnValue.split("@")[4]);
			}
		}
		return true;
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"Status","0");
			setItemValue(0,0,"AccountIndicator","<%=accountIndicator%>");

		}
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
