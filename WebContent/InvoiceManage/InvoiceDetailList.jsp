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
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.ShowSummary="1";
	dwTemp.genHTMLObjectWindow(invoiceSerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","All","Button","保存","保存","saveRecord()","","","","",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){		
		<%-- var invoiceSerialNo = "<%=invoiceSerialNo%>";
		if(invoiceSerialNo == null || invoiceSerialNo == "" || typeof(invoiceSerialNo)!="undefined"){
			alert("请先保存发票");
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
		if(confirm('确实要删除吗?')){
			reloadSelf();
			as_delete(0,"saveRecord()");
		}
	}
	

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
