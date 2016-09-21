<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "抵债资产收现台账列表";
	//获得页面参数
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = "Cash";//收现 sObjectType="Cash"
	String sDASerialNo = CurPage.getParameter("SerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	String sAISerialNo = CurPage.getParameter("AssetSerialNo");
	if(sAISerialNo == null) sAISerialNo = "";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PDACashBookList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDASerialNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","All","Button","新增","新增抵债资产收现记录","newRecord()","","","",""},
			{"true","","Button","详情","查看抵债资产收现详细信息","viewAndEdit()","","","",""},
			{"true","All","Button","删除","删除抵债资产收现信息","deleteRecord()","","","",""},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{		
		var sDATSerialNo = getSerialNo("npa_debtasset_transaction","SerialNo","");
		var sDAOSerialNo = getSerialNo("npa_debtasset_object","SerialNo","");
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp","DASerialNo=<%=sDASerialNo%>&ObjectType=Cash"+"&DATSerialNo="+sDATSerialNo+"&DAOSerialNo="+sDAOSerialNo,"");
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sDAOSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sDASerialNo = getItemValue(0,getRow(),"DASerialNo");
		var sDATSerialNo = getItemValue(0,getRow(),"DATSerialNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sDAOSerialNo) == "undefined" || sDAOSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp","DAOSerialNo="+sDAOSerialNo
				+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&DATSerialNo="+sDATSerialNo+"&RightType=<%=sRightType%>","");
		reloadSelf();
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


<%@include file="/IncludeEnd.jsp"%>
