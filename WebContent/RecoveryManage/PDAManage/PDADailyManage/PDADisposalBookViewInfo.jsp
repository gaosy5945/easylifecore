<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDATSerialNo = CurPage.getParameter("SerialNo");
	if(sDATSerialNo == null) sDATSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String sDASerialNo = CurPage.getParameter("DASerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	String sTransactionType = CurPage.getParameter("TransactionType");
	if(sTransactionType == null) sTransactionType = "";//处置方式
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";

	String sTempletNo = "PDADisposalBookViewInfo";//--模板号--
	if ("Cash"==sObjectType || "Cash".equals(sObjectType)) {
		sTempletNo = "PDACashInfo1";
	} else if (sTransactionType=="05" || "05".equals(sTransactionType)) {
		sTempletNo = "PDADisposalBookViewInfo1";
	} else if (sTransactionType=="01" || "01".equals(sTransactionType)) {
		sTempletNo = "PDADisposalBookViewInfo2";
	}
	//ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();

	inputParameter.setAttributeValue("SERIALNO", sDATSerialNo);
	inputParameter.setAttributeValue("OBJECTTYPE", sObjectType);
	inputParameter.setAttributeValue("DEBTASSETSERIALNO", sDASerialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	//ALSInfoHtmlGenerator.replaceSubObjectWindow(dwTemp);
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	dwTemp.genHTMLObjectWindow("");

	if ("Cash"==sObjectType || "Cash".equals(sObjectType)) {
		//相关费用信息
		String sOtherFeeUrl = "/RecoveryManage/PDAManage/PDADailyManage/DAOtherFeeList.jsp";
		dwTemp.replaceColumn("OTHERFEE", "<iframe type='iframe' name=\"frame_list_DISPOSAL\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+sOtherFeeUrl+"?DAOSerialNo="+sDATSerialNo+"&TransactionCode="+sTransactionType+"&=RightType="+sRightType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	} 

	//dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
	


	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sDAStatus = "";
	sSql = " select status from npa_debtasset where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sDASerialNo));
	if(rs.next()){
		sDAStatus = DataConvert.toString(rs.getString("status"));	   	
		if((sDAStatus == null) || (sDAStatus.equals(""))) sDAStatus = ""; 
	}
	rs.getStatement().close(); 
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	 initRow();
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			setItemValue(0,getRow(),"DEBTASSETSERIALNO","<%=sDASerialNo%>");
			setItemValue(0,getRow(),"TRANSACTIONCODE","<%=sTransactionType%>");
		}
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	} 
	
	/*~[Describe=处置净收入;InputParam=无;OutPutParam=无;]~*/
	function getInterstAmount(){
		var sExpiateAmout = getItemValue(0,getRow(),"AMOUNT");
		var sPrincipalAmout = getItemValue(0,getRow(),"TRANSACTIONAMOUNT");
		var sInterstAmout = sExpiateAmout-sPrincipalAmout;
		if(sInterstAmout ==null||sInterstAmout ==""||sInterstAmout =="0")sInterstAmout = "0.00";
		setItemValue(0,getRow(),"INTERESTAMOUNT",sInterstAmout);
		
	}
	
	function selectUser(type)
	{	
		sParaString = "BelongOrg"+","+"<%=CurUser.getOrgID()%>";
		setObjectValue("SelectUserBelongOrg",sParaString,"@OPERATEUSERNAME@0@OPERATEUSERNAME@1@OPERATEORGID@2@OPERATEORGNAME@3",0,0,"");
	}
	
	function saveAs(){
		as_save(0,"aftersave()");	
	}
	
	function aftersave(){
		var sDAStatus = "<%=sDAStatus%>";
		if("03"==sDAStatus){//处置终结的状态不改变
			
		}else{
			var sDASerialNo = "<%=sDASerialNo%>";
			var sSql = "update NPA_DEBTASSET set status='02' where serialno='"+sDASerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue!=-1){
				alert("保存成功！");
			}else{
				alert("保存失败！");
			}
		}
	}
	
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
