<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = " 抵债资产价值评估记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;抵债资产价值评估记录&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sAssetStatus = CurComp.getParameter("AssetStatus");
	String sSerialNo = CurComp.getParameter("SerialNo");
	String sAssetSerialNo = CurComp.getParameter("AssetSerialNo");
	//获取合同终结类型
    String sFinishType = CurComp.getParameter("FinishType");   
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sAssetStatus ==  null) sAssetStatus = "";
    if(sFinishType == null) sFinishType = "";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PDAEvaluateList";//模型编号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
	
	dwTemp.genHTMLObjectWindow(sAssetSerialNo);

	String sButtons[][] = {
		{"true","All","Button","新增","新增价值评估记录","newRecord()","","","",""},
		{"true","","Button","详情","价值评估记录详情","viewAndEdit()","","","",""},
		{sAssetStatus.equals("03")?"false":"true","All","Button","删除","删除评估记录","deleteRecord()","","","",""}
		};
	%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		AsControl.OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp","AssetSerialNo="+sAssetSerialNo,"right","");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		//var sAssetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{		
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
				as_delete('myiframe0');
			}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			AsControl.OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetStatus="+sAssetStatus,"right","");
		}
	}	
	</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
