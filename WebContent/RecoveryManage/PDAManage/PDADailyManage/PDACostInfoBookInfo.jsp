<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	//获得页面参数
	String sAssetStatus = (String)CurPage.getParameter("AssetStatus");
	String sSerialNo = (String)CurPage.getParameter("SerialNo");
	String sObjectNo = (String)CurPage.getParameter("ObjectNo");
	String sObjectType = (String)CurPage.getParameter("ObjectType");
	//将空值转化为空字符串
	if(sSerialNo == null ) sSerialNo = "";//新增记录
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "PDACostInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sObjectType + "," + sObjectNo + "," + sSerialNo);
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"true","","Button","返回","保存所有修改","goBack()","","","",""},
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	initRow();
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		/* if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		} */
	
		as_save("myiframe0");		
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
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//新增记录
			bIsInsert = true;		
			initSerialNo();
			setItemValue(0,0,"OBJECTNO","<%=sObjectNo%>");
			setItemValue(0,0,"OBJECTTYPE","<%=sObjectType%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");		
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		
		<%-- var sColName = "AssetName@AssetType"+"~";
		var sTableName = "ASSET_INFO"+"~";
		var sWhereClause = "String@ObjectNo@"+"<%=sObjectNo%>"+"@String@ObjectType@AssetInfo"+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{									
					//设置资产名称
					if(my_array2[n] == "assetname")
						setItemValue(0,getRow(),"AssetName",sReturnInfo[n+1]);					
					//设置资产类型
					if(sReturnInfo[n] == "assettype")
						setItemValue(0,getRow(),"AssetType",sReturnInfo[n+1]);					
				}
			}			
		}		 --%>	
	}
	
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookList.jsp","right","");
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "NPA_FEE_LOG";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
