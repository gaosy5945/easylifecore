<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	
	//ASObjectModel doTemp = new ASObjectModel("InvoiceDetailList");
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	String invoiceSerialNo = CurPage.getParameter("InvoiceSerialNo");
	if(invoiceSerialNo == null) invoiceSerialNo = "";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("InvoiceDetailList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setDefaultValue("invoiceserialno", invoiceSerialNo);
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.ShowSummary="1";
	dwTemp.genHTMLObjectWindow(invoiceSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","All","Button","����","����","saveRecord()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){		
		<%-- var invoiceSerialNo = "<%=invoiceSerialNo%>";
		if(invoiceSerialNo == null || invoiceSerialNo == "" || typeof(invoiceSerialNo)!="undefined"){
			alert("���ȱ��淢Ʊ");
			parent.saveRecord();
			parent.reloadSelf();
		} --%>
<%-- 		var taxrate = parseFloat('<%=value%>'); --%>
// 		ALSObjectWindowFunctions.addRow(0,"","setItemValue(0,getRow(),'taxrate',"+taxrate+")");
		ALSObjectWindowFunctions.addRow(0,'','');
	}
	function saveRecord()
	{
		/* if(!vI_all("0")) return; */
		var iAmount = 0;
		var tAmount = 0;
		for(var i=0;i<getRowCount(0);i++){
			var invoiceNumber = getItemValue(0,i,"invoicenumber");
			var invoiceUnitPrice = getItemValue(0,i,"invoiceunitprice");
			if(invoiceNumber == null || invoiceNumber == "") invoiceNumber = "0";
			if(invoiceUnitPrice == null || invoiceUnitPrice == "") invoiceUnitPrice = "0";
			setItemValue(0,i,"invoiceamount",invoiceNumber.replace(",","")*invoiceUnitPrice.replace(",",""));
			var invoiceAmount = getItemValue(0,i,"invoiceamount");
			var taxRate = getItemValue(0,i,"taxrate");
			if(invoiceAmount == null || invoiceAmount == "") invoiceAmount = "0";
			if(taxRate == null || taxRate == "") taxRate = "0";
			setItemValue(0,i,"taxamount",invoiceAmount.replace(",","")*taxRate.replace(",","")/100);
			iAmount += Number(invoiceAmount.replace(",",""));
			tAmount += Number(invoiceAmount.replace(",","")*taxRate.replace(",","")/100);
		}
		parent.calculateAmount(iAmount,tAmount);
		as_save("reloadPage()");
	}
	function reloadPage(){
		reloadSelf();
	}

	function del(){
		if(confirm('ȷʵҪɾ����?')){
			reloadSelf();
			as_delete(0,"saveRecord()");
		}
	}
	

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
