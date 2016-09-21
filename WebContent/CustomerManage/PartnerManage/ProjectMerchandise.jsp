<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "ProjectMerchandise";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回","top.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>合作项目建立</title>
</HEAD>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/ProjectMerchandise.js"></script>
<script type="text/javascript">
function selectCustomer(){
	AsDialog.SetGridValue("SelectPartnerCustomer", "<%=CurUser.getUserID()%>", "CustomerID=CustomerID@CustomerName=CustomerName@CertType=CertType@CertID=CertID@ListType=ListType", "");
}
function selectPercentOrAmount(){
	var value = getItemValue(0,0,'PercentOrAmount');
	if(value=='1'){
		showItem(0,'RelativePercent');
		hideItem(0,"RelativeAmount");
		showItemRequired(0,'RelativePercent');
		hideItemRequired(0,'RelativeAmount');
	}
	if(value =='2'){
		showItem(0,'RelativeAmount');
		hideItem(0,"RelativePercent");
		showItemRequired(0,'RelativeAmount');
		hideItemRequired(0,'RelativePercent');
	}

}
function showItem(dwname,sColName,display){
	if(display==undefined) display = ""; // 考虑该函数可能反复调用及Firefox的兼容性，这里将display属性由block改为‘’
	var sColIndex = getColIndexFromName(sColName);
	if(sColIndex!=""){
		var obj = document.getElementById("A_div_" + sColIndex);
		if(obj){
			obj.style.display = display;
			return true;
		}else{
			obj = document.getElementById("Title_" + sColIndex).parentNode;
			//alert(obj.outerHTML);
			if(obj){
				obj.style.display = display;
				if($(obj).next()[0])$(obj).next()[0].style.display = display;
				return true;
			}else
				return false;
		}
	}else
		return false;
}
function saveRecord(){
	//as_save("myiframe0","");	
	if(!iV_all("myiframe0"))return;
	var para = "";
	var productList = getItemValue(0,0,'ProductList').replace(/[,]/g,"@");
	para="CommunicationProviderID="+getItemValue(0,0,'CommunicationProviderID')+",";
	para+="ProjectType="+getItemValue(0,0,'ProjectType')+",";
	para+="MerchandiseType="+getItemValue(0,0,'MerchandiseType')+",";
	para+="MerchandisePrice="+getItemValue(0,0,'MerchandisePrice')+",";
	para+="BrandModel="+getItemValue(0,0,'BrandModel')+",";
	para+="MerchandiseBrand="+getItemValue(0,0,'MerchandiseBrand')+",";
	para+="MerchandiseID="+getItemValue(0,0,'MerchandiseID')+",";
	para+="InvoiceFlag="+getItemValue(0,0,'InvoiceFlag')+",";
	para+="ProductList="+productList+",";//产品编号
	para+="InputUserID="+"<%=CurUser.getUserID()%>"+",";//录入人
	para+="InputOrgID="+"<%=CurUser.getOrgID()%>"+",";//录入机构
	para+="InputDate="+"<%=DateHelper.getBusinessDate()%>"+",";//录入时间
	para+="RelativePercent="+getItemValue(0,0,'RelativePercent')+",";//首付比例
	para+="RelativeAmount="+getItemValue(0,0,'RelativeAmount')+",";//首付金额
	para+="CustomerID="+'<%=CurPage.getParameter("CustomerID")%>'+",";//首付金额
	para+="ListType="+'<%=CurPage.getParameter("ListType")%>';//首付金额
	
	var values = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.merchandise.InitMerchandiseInfo","initMerchandiseInfo",para);
	if(values=='false') {
		alert("商品协议已经存在，请勿重复添加");
		return;
	}
	top.returnValue = values;
	top.close();
}
function init(){
	setDialogTitle("新增合作协议");
	showItem(0,'RelativeAmount','none');
	showItem(0,'RelativePercent','none');
}
init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
