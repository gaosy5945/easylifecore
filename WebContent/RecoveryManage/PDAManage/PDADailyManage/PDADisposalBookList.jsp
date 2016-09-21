<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "抵债资产处置台账列表";
	//获得页面参数
	String sAssetType = CurComp.getParameter("AssetType");
	String sAssetStatus = CurComp.getParameter("AssetStatus");
	String sObjectType	=CurComp.getParameter("ObjectType");
	String sDASerialNo = CurComp.getParameter("SerialNo");
	String sAssetSerialNo = CurComp.getParameter("AssetSerialNo");
	//将空值转化为空字符串
	if(sDASerialNo == null) sDASerialNo = "";
	if(sAssetSerialNo == null) sAssetSerialNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	if(sAssetType == null ) sAssetType = "";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PDADisposalBookList";//模型编号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
		
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow(sDASerialNo + "," + sObjectType);
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","All","Button","新增","新增","newRecord()","","","",""},
			{"true","","Button","详情","详细信息","viewAndEdit()","","","",""},
			{sAssetStatus.equals("03")?"false":"true","All","Button","删除","删除","deleteRecord()","","","",""},
		};
	%> 
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sDASerialNo="<%=sDASerialNo%>";
		var sObjectType = "<%=sObjectType%>";
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		var sAssetType = "<%=sAssetType%>";
		var sTransactionType = "";
		var sDATSerialNo = getSerialNo("NPA_DEBTASSET_TRANSACTION","SerialNo","");

		//var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp";
		var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookViewInfo.jsp";
		
		if("Lease"==sObjectType){
			sTransactionType = "01";
		} else if ("Cash"==sObjectType) {
			AsControl.PopComp(sURL,"SerialNo="+sDATSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"","");
		} else {
			sTransactionType = PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=10;center:yes;status:no;statusbar:no");
		}
		if(typeof(sTransactionType) != "undefined" && sTransactionType.length != 0)
		{			
			//获取流水号
			AsControl.PopComp(sURL,"SerialNo="+sDATSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&TransactionType="+sTransactionType+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType+"","");
		} 		
		reloadSelf();
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
			as_delete(0);
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得资产处置流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sDebtAssetSerialNo = getItemValue(0,getRow(),"DebtAssetSerialNo");
		var sObjectType = "<%=sObjectType%>";//处置类型台账
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		var sAssetType = "<%=sAssetType%>";
		var sTransCode = getItemValue(0,getRow(),"TRANSACTIONCODE");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp";
		var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookViewInfo.jsp";
		AsControl.PopComp(sURL,"SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&DASerialNo="+sDebtAssetSerialNo+"&TransactionType="+sTransCode,"");

		reloadSelf();
	}	
	
	</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>