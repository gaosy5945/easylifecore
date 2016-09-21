<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "押品评估"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");if(assetSerialNo == null) assetSerialNo = "";
	String ApplyFlag = CurPage.getParameter("ApplyFlag");if(ApplyFlag == null) ApplyFlag = "";
	
	String sTempletNo = "CollateralEvaluate";
	if("1".equals(ApplyFlag)) {
		sTempletNo = "CollateralEvaluate1";
	}
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,BusinessObject.createBusinessObject(),CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	doTemp.setDefaultValue("EvaluateMethod", "1");
	
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
	};
	
	String assetType = "",assetName="",clrSerialNo="";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ASSETTYPE,ASSETNAME,CLRSerialNo from ASSET_INFO where SerialNo=:SerialNo").setParameter("SerialNo", assetSerialNo));
    
	if(rs.next())
    {
    	assetType = rs.getString("ASSETTYPE");
    	assetName = rs.getString("ASSETNAME");
    	clrSerialNo = rs.getString("CLRSerialNo");
    }
    rs.close();

%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function closeSelf(){
		var evaluateMethod = getItemValue(0,0,"EvaluateMethod");
		top.returnValue = evaluateMethod;
	} 

	function saveRecord(){
		var evaluateMethod = getItemValue(0,0,"EvaluateMethod");
		var assetSerialNo = getItemValue(0,0,"AssetSerialNo");
		
		if(evaluateMethod == "4") {
			var confirmValue = getItemValue(0,0,"ConfirmValue");
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.AssetEvaCheck","updateAssetInfo","AssetSerialNo="+assetSerialNo+",ConfirmValue="+confirmValue);
		}
		var assetEvaParams = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEva1","AssetSerialNo="+assetSerialNo);
		if(assetEvaParams == "false") {
			alert("该押品有未完成的估值任务,不能重复保存任务！");
			return;
		}
		as_save(0,"closeSelf()");
	}
	
	function ChangeEvaluateMethod()
	{
		var applyType = getItemValue(0,getRow(),"EvaluateMethod");
		if(applyType == '4')
		{
			showItem("0","EvaluateValue");
			setItemRequired("myiframe0","EvaluateValue",true);
			showItem("0","ConfirmValue");
			setItemRequired("myiframe0","ConfirmValue",true);
			showItem("0","EvaluateCurrency");
			setItemRequired("myiframe0","EvaluateCurrency",true);
			setItemRequired("myiframe0","EvaluateModel",true);
		}
		else
		{
			hideItem("0","EvaluateValue");
			setItemRequired("myiframe0","EvaluateValue",false);
			setItemValue(0,0,"EvaluateValue","");
			hideItem("0","ConfirmValue");
			setItemRequired("myiframe0","ConfirmValue",false);
			setItemValue(0,0,"ConfirmValue","");
			hideItem("0","EvaluateCurrency");
			setItemRequired("myiframe0","EvaluateCurrency",false);
			setItemValue(0,0,"EvaluateCurrency","");
			if(applyType == '2') {
				setItemRequired("myiframe0","EvaluateModel",false);
			} else {
				setItemRequired("myiframe0","EvaluateModel",true);
			}
		}
		operateDescription();
	}
	
	function operateDescription(){
		var tranSactionType=getItemValue(0,0,"EvaluateMethod");
		$("[name=EVALUATEMODEL]").each(function(){
		 	$(this).parent().hide();
		 	if("4"==tranSactionType){
				if(this.value=="M_CMG_PVM" || this.value=="M_CMG_MVM"){
					$(this).parent().show();
				}
		 	}else {
		 		if(this.value=="01" || this.value=="02"|| this.value=="03"){
					$(this).parent().show();
				}
		 	} 
	 	 });
	}  
	
	function ChangeEvaluateScenario()
	{
		var applyType = getItemValue(0,getRow(),"EvaluateScenario");
		if(applyType == '1' || applyType == '4')
		{
			setItemRequired("myiframe0","EvaluateReason",false);
		}
		else
		{
			setItemRequired("myiframe0","EvaluateReason",true);
		}
	}
	
	function init(){
		setItemValue(0,0,"AssetSerialNo","<%=assetSerialNo%>");
		setItemValue(0,0,"AssetType","<%=assetType%>");
		setItemValue(0,0,"AssetName","<%=assetName%>");
		setItemValue(0,0,"CLRSerialNo","<%=clrSerialNo%>");
		
		if(getRowCount(0)==0){
			var userId = getItemValue(0,getRow(),"EvaluateUserID");
			var orgId = getItemValue(0,getRow(),"EvaluateOrgID");
			var evaDate = getItemValue(0,getRow(),"EvaDate");
			
			if(userId == '') {
				setItemValue(0,0,"EvaluateUserID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"EvaluateUserName","<%=CurUser.getUserName()%>");
			}
			if(orgId == '') {
				setItemValue(0,0,"EvaluateOrgID","<%=CurUser.getOrgID()%>");
				setItemValue(0,0,"EvaluateOrgName","<%=CurUser.getOrgName()%>");
			}
			if(evaDate == '') {
				setItemValue(0,0,"EvaDate","<%=DateHelper.getToday()%>");
			}
		}
		ChangeEvaluateMethod();
	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
