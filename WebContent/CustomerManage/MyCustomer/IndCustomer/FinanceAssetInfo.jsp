<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	
	String sTempletNo = "FinanceAssetInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">

	function selectFinanceAsset(){
		var result = CustomerManage.qureyFinanceAssetInfo("<%=customerID%>");
		result = result.split("@");
		if(result[1] == "100"){
			setItemValue(0,getRow(0),"FinanceAssetLevel","��ͨ�ͻ�");
			hideItem(0,"LastMonthFA");
			hideItem(0,"OneYearContribution");
		}else if(result[1] == "7" || result[1] == "10" || result[1] == "20"){
			var FinanceAssetLevel = "";
			if(result[1] == "7"){
				FinanceAssetLevel = "���ʿͻ�";
			}else if(result[1] == "10"){
				FinanceAssetLevel = "�׽�ͻ�";
			}else if(result[1] == "20"){
				FinanceAssetLevel = "��ʯ�ͻ�";
			}
			setItemValue(0,getRow(0),"LastMonthFA",result[0]);
			setItemValue(0,getRow(0),"FinanceAssetLevel",FinanceAssetLevel);
			setItemValue(0,getRow(0),"OneYearContribution",result[2]);
		}else{
			setItemValue(0,getRow(0),"FinanceAssetLevel",result[1]);
			hideItem(0,"LastMonthFA");
			hideItem(0,"OneYearContribution");
		}
	}
	selectFinanceAsset();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
