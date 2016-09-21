<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDAOSerialNo = CurPage.getParameter("DAOSerialNo");
	if(sDAOSerialNo == null) sDAOSerialNo = "";
	String sDATSerialNo = CurPage.getParameter("DATSerialNo");
	if(sDATSerialNo == null) sDATSerialNo = "";
	String sDASerialNo = CurPage.getParameter("DASerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	/* String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = ""; */
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	//String sDAStatus = CurPage.getParameter("DAStatus");
	//if(sDAStatus == null) sDAStatus = "";
	
	String sTempletNo = "PDACashInfo1";//--模板号--
	//ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	BusinessObject inputParameter = BusinessObject.createBusinessObject();

	inputParameter.setAttributeValue("SERIALNO", sDAOSerialNo);
	inputParameter.setAttributeValue("ObjectType", sObjectType);
	inputParameter.setAttributeValue("DebtAssetSerialNo", sDASerialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	//dwTemp.genHTMLObjectWindow(sDAOSerialNo+","+sDASerialNo+","+sObjectType);
	//ALSInfoHtmlGenerator.replaceSubObjectWindow(dwTemp);
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	dwTemp.genHTMLObjectWindow("");
	
	//相关费用信息
	String sOtherFeeUrl = "/RecoveryManage/PDAManage/PDADailyManage/DAOtherFeeList.jsp";
	dwTemp.replaceColumn("OTHERFEE", "<iframe type='iframe' name=\"frame_list_DISPOSAL\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+sOtherFeeUrl+"?DAOSerialNo="+sDATSerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表","returnList()","","","",""},
	};
	//dwTemp.replaceColumn("CASHINFO", "<iframe type='iframe' name=\"frame_list_CashInfo\" width=\"100%\" height=\"320\" frameborder=\"0\" src=\""+sWebRootPath+"/RecoveryManage/PDAManage/PDADailyManage/PDACashInfo1.jsp?DATSerialNo="+sDATSerialNo+"&DAOSerialNo="+sDAOSerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
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
	var bIsInsert = false;
	//initRow();
	//$(document).ready(function(){
		initRow();
	//});
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
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

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//新增记录
			bIsInsert = true;	

			<%-- setItemValue(0,0,"SERIALNO","<%=sDAOSerialNo%>"); --%>
			setItemValue(0,0,"DEBTASSETSERIALNO","<%=sDASerialNo%>");
			setItemValue(0,0,"OBJECTTYPE","<%=sObjectType%>");
			setItemValue(0,0,"EXPIATEAMOUNT","0.00");			
			setItemValue(0,0,"CURRENCY","CNY");			
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			
			<%-- setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>"); --%>
			<%-- var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"CASHINFO");
			setItemValue(subdwname,0,"DEBTASSETSERIALNO","<%=sDAOSerialNo%>");
			setItemValue(subdwname,0,"AMOUNT","0.00");			
			setItemValue(subdwname,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");			
			setItemValue(subdwname,0,"OPERATEUSERNAME","<%=CurUser.getUserName()%>");			
			setItemValue(subdwname,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(subdwname,0,"OPERATEORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(subdwname,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(subdwname,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(subdwname,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(subdwname,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>"); --%>
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "npa_debtasset_object";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	
	
	function returnList(){
		self.close();
	}
	
	//获取当前机构的领用人：可以选择当前机构下的任意用户
 	function  selectUser(){
 		var sReturn = setObjectValue("SelectRoleUser","OrgID,<%=CurOrg.orgID%>","@OPERATEUSERID@0@OPERATEUSERNAME@1@OPERATEORGID@2@OPERATEORGNAME@3",0,0,"");
 		var sReturnValues = new Array();
 		sReturnValues = sReturn.split("@");
 		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"CASHINFO");
		setItemValue(subdwname,0,"OPERATEUSERID",sReturnValues[0]);			
		setItemValue(subdwname,0,"OPERATEUSERNAME",sReturnValues[1]);			
		setItemValue(subdwname,0,"OPERATEORGID",sReturnValues[2]);
		setItemValue(subdwname,0,"OPERATEORGNAME",sReturnValues[3]);
 	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
