<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
//"SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&DASerialNo="+sDebtAssetSerialNo+"&AssetType="+sAssetType+"&AssetSerialNo="+sAssetSerialNo
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDAOSerialNo = CurPage.getParameter("SerialNo");
	if(sDAOSerialNo == null) sDAOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String sDASerialNo = CurPage.getParameter("DASerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	String sTransactionType = CurPage.getParameter("TransactionType");
	if(sTransactionType == null) sTransactionType = "";//处置方式
	String sAssetType = CurPage.getParameter("AssetType");
	if(sAssetType == null) sAssetType = "";
	String sAssetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(sAssetSerialNo == null) sAssetSerialNo = "";
	String sTransCode = CurPage.getParameter("TransCode");
	if(sTransCode == null) sTransCode = "";
	String sTempletNo = "PDADisposalBookInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	// 
	String sDispoalUrl = "";//处置类型信息地址
	String sColumnName = "";//列名

	//新增产生DAO流水号
	if(sTransactionType!="" || !"".equals(sTransactionType)){
		sDAOSerialNo = DBKeyHelp.getSerialNo("npa_debtasset_object","SerialNo"); 
	}else{
		sTransactionType = sTransCode;
	}
	
	sDispoalUrl = "/RecoveryManage/PDAManage/PDADailyManage/PDADispoal01Info.jsp";
	sColumnName = "DISPOSAL"+sTransactionType.toString();
	if("01".equals(sTransactionType) || "01"==sTransactionType){
		sColumnName = "DISPOSAL01";
	}else if("02".equals(sTransactionType) || "02"==sTransactionType){
		sColumnName = "DISPOSAL02";
	}else if("03".equals(sTransactionType) || "03"==sTransactionType){
		sColumnName = "DISPOSAL03";
	}else  if("04".equals(sTransactionType) || "04"==sTransactionType){
		sColumnName = "DISPOSAL04";
	}else  if("05".equals(sTransactionType) || "05"==sTransactionType){
		sColumnName = "DISPOSAL05";
	}else  if("06".equals(sTransactionType) || "06"==sTransactionType){
		sColumnName = "DISPOSAL06";
	}
	//处置信息 
	doTemp.setVisible(sColumnName, true);
	dwTemp.genHTMLObjectWindow(sDAOSerialNo+","+sObjectType+","+sDASerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveAs()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
	dwTemp.replaceColumn(sColumnName, "<iframe type='iframe' name=\"frame_list_DISPOSAL\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+sDispoalUrl+"?DAOSerialNo="+sDAOSerialNo+"&TransactionCode="+sTransactionType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//相关费用信息
	String sOtherFeeUrl = "/RecoveryManage/PDAManage/PDADailyManage/DAOtherFeeList.jsp";
	dwTemp.replaceColumn("OTHERFEE", "<iframe type='iframe' name=\"frame_list_DISPOSAL\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+sOtherFeeUrl+"?DAOSerialNo="+sDAOSerialNo+"&TransactionCode="+sTransactionType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());


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
			//as_add("myiframe0");//新增记录
			bIsInsert = true;	
			//initSerialNo();//初始化流水号字段
			setItemValue(0,0,"SERIALNO","<%=sDAOSerialNo%>");
			setItemValue(0,0,"DEBTASSETSERIALNO","<%=sDASerialNo%>");
			setItemValue(0,0,"OBJECTTYPE","<%=sObjectType%>");
			<%-- setItemValue(0,0,"OBJECTNO","<%=sObjectNo%>"); --%>
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");	
		}
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "NPA_DEBTASSET_OBJECT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=处置净收入;InputParam=无;OutPutParam=无;]~*/
	function _getInterstAmount(){
		var sExpiateAmout = getItemValue(0,getRow(),"EXPIATEAMOUNT");
		var sPrincipalAmout = getItemValue(0,getRow(),"PRINCIPALAMOUNT");
		var sInterstAmout = sExpiateAmout-sPrincipalAmout;
		if(sInterstAmout ==null||sInterstAmout ==""||sInterstAmout =="0")sInterstAmout = "0.00";
		setItemValue(0,getRow(),"INTERESTAMOUNT",sInterstAmout);
		
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
