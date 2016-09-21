<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "抵债资产日常管理列表";
	
	//通过DW模型产生ASDataObject对象doTemp AppNoDisposalList模板改为PDADailyList
	String sTempletNo = "PDADailyList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);
	
	//删除抵债资产后删除关联信息
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(AssetInfo,#SerialNo,DeleteBusiness)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
			{"true","","Button","资产详情","查看/修改资产详情","viewAndEdit()","","","",""},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
			{"true","","Button","处置终结","终结所选中的记录","finishRecord()","","","",""}
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
		var sAssetInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDATypeDialog.jsp","","resizable=yes;dialogWidth=28;dialogHeight=10;center:yes;status:no;statusbar:no");
		sAssetInfo = sAssetInfo.split("@");
		var sAISerialNo=sAssetInfo[1];
		var sDASerialNo=sAssetInfo[2];
		if(typeof(sAISerialNo) != "undefined" && sAISerialNo.length != 0)
		{			
			//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"AssetSerialNo="+sAssetSerialNo,"");
			var sFunctionID="PDAInfoList";
			AsCredit.openFunction(sFunctionID,"SerialNo="+sDASerialNo+"&AssetSerialNo="+sAISerialNo+"&AssetType="+sAssetInfo[0]);	
			reloadSelf();
		} 		
	}
			
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		 var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		 var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		 var sDebtAssetStatus = getItemValue(0,getRow(),"Status");
		 if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		} else {
			 if(sDebtAssetStatus!="01"){
				 alert("请选择处置状态为待处置的信息进行删除操作！");
				 return;
			 }
			if(confirm("确定要删除吗？")){
				//插入刚刚产生的序列号记录，补充缺省值。
				PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDADeleteActionAjax.jsp?SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo,"","");
			}
		}
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		var sAssetType = getItemValue(0,getRow(),"AssetType");					
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo,"");
		var sFunctionID="PDAInfoList";
		AsCredit.openFunction(sFunctionID,"SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType);	
		reloadSelf();	
	}	
		
	/*~[Describe=终结资产，设置终结状态，终结日期;InputParam=无;OutPutParam=SerialNo;]~*/
	function finishRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//type=1 意味着从AppDisposingList中执行处置终结并且汇总。
		//type=2 意味着从PDADisposalEndList中察看汇总。
		//type=3 意味着从PDADisposalBookList中察看汇总。
        sReturn = popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&Type=1","dialogWidth:720px;dialogheight:580px","");
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

<%@ include file="/IncludeEnd.jsp"%>
