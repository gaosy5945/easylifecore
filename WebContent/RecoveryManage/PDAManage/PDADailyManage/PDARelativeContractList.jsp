<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "对应合同相关信息列表";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	//抵债资产流水号
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetStatus == null ) sAssetStatus = "";
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if(sRightType == null) sRightType = "";	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PDARelativeContractList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{sAssetStatus.equals("04")?"false":"true","All","Button","引入","引入一条合同信息","newRecord()","","","",""},
		{"true","","Button","抵债详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","合同详情","察看合同详情","my_Contract()","","","",""}	,
		{sAssetStatus.equals("04")?"false":"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","",""}		
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
		var sRelativeContractNo = "";	
		//获取抵债资产关联的合同流水号	
		<%-- var sContractInfo  = AsDialog.OpenSelector("SelectRelativeContract","orgID,<%=CurUser.getOrgID()%>",""); --%>
		var sContractInfo = AsDialog.SelectGridValue('RelativeContractChooseList',"<%=CurUser.getOrgID()%>",'SERIALNO','',"false","","","1");
		//var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" && sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_")  
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}		
		if(sRelativeContractNo == "" || typeof(sRelativeContractNo) == "undefined"){
			alert("未选中合同！");
			return;
		} else {	
			var sObjectType = "Business_Contract";//关联类型
			var sDASerialNo = "<%=sSerialNo%>";	//抵债资产流水号
			var sSerialNo = initSerialNo();	//抵债资产抵债信息流水号  在DAO表中新增一条 抵债资产关联贷款信息 产生流水号
			var sReturn=PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/AddNPABCActionAjax.jsp?SerialNo="+sSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&RelativeContractNo="+sRelativeContractNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				//self.close();
				AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sRelativeContractNo+"&DASerialNo="+sDASerialNo+"&SerialNo="+sSerialNo);
				reloadSelf();
			}else{
				alert("已引入过，请选择其他引入。");
				return ;
			}
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");
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
		var sContractSerialNo = getItemValue(0,getRow(),"OBJECTNO");  
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！	
			return;		
		}
		
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sContractSerialNo+"&SerialNo="+sSerialNo + "&RightType=<%=sRightType%>");
	}	
	
	/*~[Describe=查看合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Contract()
	{  
		//获得合同流水号
		var sContractNo = getItemValue(0,getRow(),"OBJECTNO");  //合同流水号或对象编号
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		AsCredit.openFunction("ContractInfo","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+sContractNo+"&RightType=ReadOnly");
	}	
	/*  产生流水号 */
	function initSerialNo()
	{
		 //生成一个新的记录插入NPA_DebtAsset_Object：序列号。
		var sTableName = "NPA_DEBTASSET_OBJECT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		var  sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		return sSerialNo;
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
