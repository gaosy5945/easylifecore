<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS"%>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-11
        Content: 示例详情页面
        History Log: 
    */
	String record = CurPage.getParameter("record");

	String productID = CurPage.getParameter("productID");
	String sTempletNo = "CreatInvoiceInfo";//--模板号--
	
	//当前的
	BusinessObject businessApply = BusinessObject.createBusinessObject();
	businessApply.setAttributeValue("BusinessType", productID);//输入的产品编号
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,businessApply,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	DefaultObjectWindowController dwcontroller = new DefaultObjectWindowController();//将产品中的数据和模板中的数据对应起来
	dwcontroller.initDataWindow(dwTemp,businessApply);
	
// 	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
// 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","确定","确定","creat()","","","",""},
		{"true","All","Button","取消","取消","top.close();","","","",""}, 
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function creat(){
		if(!iV_all("0")) return ;
		var record = "<%=record%>";
		var purpose = getItemValue(0,getRow(),"purpose");
		var billingmode = getItemValue(0,getRow(),"InvoiceBillingMode");
		var invoicetype1 = getItemValue(0,getRow(),"invoicetype1");
		var invoicetype2 = getItemValue(0,getRow(),"invoicetype2");
		var isornot = getItemValue(0,getRow(),"isornot");
		var taxrate = getItemValue(0,getRow(),"taxrate");
		//record格式:选择流水号(@分隔)&票据用途&开票方式&生成票据类型(本金)&生成票据类型(收益)&是否使用统一税率&税率值&用户id&机构id
		record += "&" + purpose + "&" + billingmode + "&" + invoicetype1 + "&" + invoicetype2 + "&" + isornot + "&" 
				  + taxrate + "&" + "<%=CurUser.getUserID()%>"+"&"+"<%=CurOrg.getOrgID()%>"; 
		var result = RunJavaMethod("com.amarsoft.app.als.afterloan.invoice.InvoiceCreat","InvoiceCreat","record="+record);
		if(result=="true")
			alert("票据生成成功,请在【已出票】中进行确认!");
		top.close();
	}
	var tax = "";
	function initRow(){
		setItemValue(0,0,"invoicetype1","01");
		setItemValue(0,0,"purpose","P01");
		tax = getItemValue(0,getRow(),"taxrate");
		hideItem(0,"taxrate");
	};
	function taxrate(){
		var is = getItemValue(0,getRow(),"isornot");
		if(is==1){
			hideItem(0,"taxrate");
			setItemValue(0,getRow(),"taxrate",tax);
			setItemRequired(0,"taxrate", false);
		}else{
			showItem(0,"taxrate");
			setItemRequired(0,"taxrate", true);
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>