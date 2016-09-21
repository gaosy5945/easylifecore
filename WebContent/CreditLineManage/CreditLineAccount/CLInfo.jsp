 <%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.app.als.apply.model.BusinessApply"%><style>
	.div_frm{
		 position: absolute;
		 width:500px;
		 height:400px; 
	}
</style>
<%
	String sSerialNo = CurPage.getParameter("SerialNo");
	String objectType=CurPage.getParameter("ObjectType");
	String objectNo=CurPage.getParameter("ObjectNo");
	String parentSerialNo=CurPage.getParameter("ParentSerialNo");
	if(parentSerialNo==null) parentSerialNo="";
	if(sSerialNo==null) sSerialNo="";
	String sTempletNo = "CLInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("ObjectType",objectNo);
	doTemp.setDefaultValue("ObjectType",objectType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
	dwTemp.replaceColumn("RuleList", "<iframe type='iframe' name=\"RuleList\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("CustomerList", "<iframe type='iframe' name=\"CustomerList\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	
	
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord(0)","","","",""},
		{"true","All","Button","返回","返回","goBack(0)","","","",""},
	}; 
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript"><!--
	var sSerialNo="<%=sSerialNo%>";
	function goBack(){
		self.close();
	}
	parentSerialNo="<%=parentSerialNo%>";
	if(parentSerialNo!=""){
		setItemValue(0,getRow(),"ParentSerialNo","<%=parentSerialNo%>");
	}

	var result=[];
	function saveRecord(){
		if(!iV_all("0")) return ;
		for(var key in result){
			obj=getColIndex(0,key);
			if(obj>0){
				setItemUnit(0,getRow(),key,"");
			}
		}
		vresult=AsCredit.runFunction("CheckCreditLine",AsCredit.getOWDataString());//.doAction("5030");
		result=vresult.getOutputAllParameter();
		var bsuccess=true;
		for(var key in result){
			obj=getColIndex(0,key);
			if(obj>0){
				bsuccess=false;
				message=result[key];
				setItemUnit(0,getRow(),key,"<font color=red>"+message+"</font>");
			}
		}
		
	   if(!bsuccess) return ;
		as_save(0,"afterSave()");
	}
	
	function afterSave(){
		sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		if(window.frames["RuleList"].saveRecord){
			window.frames["RuleList"].saveRecord(sSerialNo);
		}
	}
	
	
	function divideChange(){
		var sDivideType=getItemValue(0,getRow(),"DIVIDETYPE");
		if(sDivideType.indexOf("10")>=0){//产品
			showItem(0,"BusinessName");
		}else{
			hideItem(0,"BusinessName");
			setItemValue(0,getRow(),"BusinessName","");
			setItemValue(0,getRow(),"BusinessType","");
		}

		if(sDivideType.indexOf("20")>=0){
			showItem(0,"OrgName");
		}else{
			hideItem(0,"OrgName");
			setItemValue(0,getRow(),"OrgName","");
			setItemValue(0,getRow(),"OrgID","");
		}

		if(sDivideType.indexOf("30")>=0){
			showItem(0,"BUSINESSCURRENCY");
		}else{
			hideItem(0,"BUSINESSCURRENCY");
			setItemValue(0,getRow(),"BUSINESSCURRENCY","");
		}

		if(sDivideType.indexOf("40")>=0){
			showItem(0,"VouchType");
		}else{
			hideItem(0,"VouchType");
			setItemValue(0,getRow(),"VouchType","");
		}


		if(sDivideType.indexOf("50")>=0){
			if(!window.frames["CustomerList"].add){
				AsControl.OpenPage("/CreditLineManage/CreditLine/CLCustomerList.jsp","SerialNo="+sSerialNo,"CustomerList");
			}
			$("#A_Group_0025").show();
		}else{
			$("#A_Group_0025").hide();
		}
	
	}
	var div_business,div_org,div_vouch;
	function selectBusinessType(obj){
		var selectedProduct = getItemValue(0,getRow(),"BusinessType");
		if(typeof selectedProduct == "undefined") selectedProduct = "";
		sUrl = "/ImageManage/ImageConfigSelectProduct.jsp";
		sParameters ="selectedProduct="+selectedProduct;
		pageStyle = "dialogWidth=400px;dialogHeight=500px;center:yes;resizable:yes;scrollbars:auto;status:no;help:no";
		var returnValue = AsControl.PopView(sUrl,sParameters,pageStyle);
		if(returnValue ==null || typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_" || returnValue=="_NONE_"){
			return;
		}
		org = returnValue.split("@");
		setItemValue(0,getRow(),"BUSINESSTYPE",org[0]);
		setItemValue(0,getRow(),"BusinessName",org[1]);
		  
		
		//o = setObjectValue("SelectEntBusinessType","","",0,0,"");
		
	}
	function selectOrgName(obj){
		var selectedOrg = getItemValue(0,getRow(),"OrgID");
		if(typeof selectedOrg == "undefined") selectedOrg = "";
		sUrl = "/ImageManage/ImageConfigSelectOrg.jsp";
		sParameters ="selectedOrg="+selectedOrg;
		pageStyle = "dialogWidth=400px;dialogHeight=500px;center:yes;resizable:yes;scrollbars:auto;status:no;help:no";
		var returnValue = AsControl.PopView(sUrl,sParameters,pageStyle);
		if(returnValue ==null || typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_" || returnValue=="_NONE_"){
			return;
		}
		org = returnValue.split("@");
		setItemValue(0,getRow(),"OrgID",org[0]);
		setItemValue(0,getRow(),"OrgName",org[1]);
	}
	function selectVouchType(obj){
	 

	}
	function userRuleChange(){
		useRule=getItemValue(0,getRow(),"USERULE");
		rootSerialNo=getItemValue(0,getRow(),"ROOTSERIALNO");;
		parentSerialNo=getItemValue(0,getRow(),"parentSerialNo");
		var serialNo="<%=sSerialNo%>";
		if(parentSerialNo=="<%=objectNo%>"){
			setItemValue(0,getRow(),"USERULE","10");
			 $("[name=USERULE]").each(function(){
				 $(this).attr("disabled","disabled");
			 });
			$("#A_Group_0015").hide();
		}else if(useRule=="10"||useRule==""){
			$("#A_Group_0015").hide();
		}else{
			$("#A_Group_0015").show();
			if(serialNo=="") serialNo="<%=parentSerialNo%>";
			AsControl.OpenPage("/CreditLineManage/CreditLineAccount/UseRuleList.jsp","SerialNo="+serialNo+"&RootSerialNo="+rootSerialNo,"RuleList");
		}
	}

	function selectCustomer(){
		getItemValue(0,getRow(),"CustomerID")
	}
 	
	divideChange();
	userRuleChange();
	
--></script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>