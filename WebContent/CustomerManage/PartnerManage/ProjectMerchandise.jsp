<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "ProjectMerchandise";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","����","top.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>������Ŀ����</title>
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
	if(display==undefined) display = ""; // ���Ǹú������ܷ������ü�Firefox�ļ����ԣ����ｫdisplay������block��Ϊ����
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
	para+="ProductList="+productList+",";//��Ʒ���
	para+="InputUserID="+"<%=CurUser.getUserID()%>"+",";//¼����
	para+="InputOrgID="+"<%=CurUser.getOrgID()%>"+",";//¼�����
	para+="InputDate="+"<%=DateHelper.getBusinessDate()%>"+",";//¼��ʱ��
	para+="RelativePercent="+getItemValue(0,0,'RelativePercent')+",";//�׸�����
	para+="RelativeAmount="+getItemValue(0,0,'RelativeAmount')+",";//�׸����
	para+="CustomerID="+'<%=CurPage.getParameter("CustomerID")%>'+",";//�׸����
	para+="ListType="+'<%=CurPage.getParameter("ListType")%>';//�׸����
	
	var values = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.merchandise.InitMerchandiseInfo","initMerchandiseInfo",para);
	if(values=='false') {
		alert("��ƷЭ���Ѿ����ڣ������ظ����");
		return;
	}
	top.returnValue = values;
	top.close();
}
function init(){
	setDialogTitle("��������Э��");
	showItem(0,'RelativeAmount','none');
	showItem(0,'RelativePercent','none');
}
init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
