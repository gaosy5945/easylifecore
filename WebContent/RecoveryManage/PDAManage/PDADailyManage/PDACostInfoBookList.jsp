<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "抵债资产处置相关费用台账列表";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetStatus"));
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetSerialNo"));
	String sSerialNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRightType	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType"));
	//将空值转化为空字符串
	if(sRightType == null) sRightType = "";
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PDACostInfoBookList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","All","Button","新增","新增","newRecord()","","","",""},
			{"true","","Button","详情","详细信息","viewAndEdit()","","","",""},
			{sAssetStatus.equals("03")?"false":"true","All","Button","删除","删除","deleteRecord()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=","right");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得费用流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookInfo.jsp?SerialNo="+sSerialNo
				+"&ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&AssetStatus="+sAssetStatus,"right");
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
