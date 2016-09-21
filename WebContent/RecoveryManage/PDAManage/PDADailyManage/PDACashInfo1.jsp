<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDATSerialNo = CurPage.getParameter("DATSerialNo");
	if(sDATSerialNo == null) sDATSerialNo = "";
	String sDAOSerialNo = CurPage.getParameter("DAOSerialNo");
	if(sDAOSerialNo == null) sDAOSerialNo = "";
	String sTransctionType = CurPage.getParameter("TransctionType");
	if(sTransctionType == null) sTransctionType = "";

	String sTempletNo = "PDACashInfo1";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sDATSerialNo+","+sDAOSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false;
	initRow();
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			//beforeInsert();
			setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>");
			
			bIsInsert = false;
		}
	
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//新增记录
			bIsInsert = true;	

			setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>");
			setItemValue(0,0,"DEBTASSETSERIALNO","<%=sDAOSerialNo%>");
			setItemValue(0,0,"AMOUNT","0.00");			
			setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");			
			setItemValue(0,0,"OPERATEUSERNAME","<%=CurUser.getUserName()%>");			
			setItemValue(0,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OPERATEORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");	
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "npa_debtasset_transaction";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	

	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
