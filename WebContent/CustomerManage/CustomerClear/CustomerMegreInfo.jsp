 <%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "CustomerMegreInfo";//模板号//CustomerClearInfo1
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","确认","确认","doConfirm(0)","","","",""},
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function doConfirm(){
		if(!iV_all("0")) return ;
		var customerId1=getItemValue(0,getRow(),"CustomerID");
		var CustomerName1=getItemValue(0,getRow(),"CustomerName1");
		var customerId2=getItemValue(0,getRow(),"MegCustomerID");
		var CustomerName2=getItemValue(0,getRow(),"CustomerName2");
		if(customerId1==customerId2){
			setItemUnit(0,0,'CustomerName1',"<font color=red>不能对同一个客户进行合并</font>");
			return 
		}
		if(confirm("客户["+CustomerName1+"]业务将合并至["+CustomerName2+"]您确认吗?"))
			var owStr=AsCredit.getOWDataString("&");
		alert(owStr);
		sReturn=AsCredit.runFunction("CustomerMergeAction",owStr+"&userId=<%=CurUser.getUserID()%>");
		if(sReturn.getResult()){
			alert("合并成功!");
			top.returnValue="true";
			top.close();
		}else{
			alert("合并失败"+sReturn);
			return ;
		}
	}

	function selectCustomer(){
		setItemUnit(0,0,'CustomerType',"");
		setItemUnit(0,0,'CustomerName1',"");
		var sCustomerType= getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType)=="undefined" || sCustomerType.length==0){
			setItemUnit(0,0,'CustomerType',"<font color=red>请选择客户类型</font>");
			return ;
		}
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		selectName="SelectApplyCustomer3";//公司客户和中小企业
		if(sCustomerType=="03") selectName="SelectApplyCustomer1";//个人客户 
		returnValue = setObjectValue(selectName,sParaString,"",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue.length==0){
			return ;
		}
		oArray = returnValue.split("@");
		if(oArray[0]=="_CLEAR_"){
			setItemValue(0,0,"CustomerID","");
			setItemValue(0,0,"CustomerName1","");
			setItemValue(0,0,"CertID1","");
			return;
		}
		setItemValue(0,0,"CustomerID",oArray[0]);
		setItemValue(0,0,"CustomerName1",oArray[1]);
		setItemValue(0,0,"CertID1",oArray[3]);
		//改变客户类型时清空业务品种、关联借据和关联重组方案 
		
	}

	function customerTypeChange(){ 
		setItemUnit(0,0,'CustomerType',""); 
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName1",""); 
		setItemValue(0,0,"MegCustomerID","");
		setItemValue(0,0,"CustomerName2","");
	}

	function selectCustomer2(){
		setItemUnit(0,0,'CustomerType',"");
		setItemUnit(0,0,'CustomerName1',"");
		var sCustomerType= getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType)=="undefined" || sCustomerType.length==0){
			setItemUnit(0,0,'CustomerType',"<font color=red>请选择客户类型</font>");
			return ;
		}
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		selectName="SelectApplyCustomer3";//公司客户和中小企业
		if(sCustomerType=="03") selectName="SelectApplyCustomer1";//个人客户 
		returnValue = setObjectValue(selectName,sParaString,"",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue.length==0){
		return ;
		}
		oArray = returnValue.split("@");
		if(oArray[0]=="_CLEAR_"){
			setItemValue(0,0,"MegCustomerID","");
			setItemValue(0,0,"CustomerName2","");
			setItemValue(0,0,"CertID2","");
			return;
		}
		setItemValue(0,0,"MegCustomerID",oArray[0]);
		setItemValue(0,0,"CustomerName2",oArray[1]);
		setItemValue(0,0,"CertID2",oArray[3]);
		//改变客户类型时清空业务品种、关联借据和关联重组方案 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 