<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "对应案件相关信息列表";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	//资产流水号
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetStatus == null ) sAssetStatus = "";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PDALawCaseList";//模型编号
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
		{sAssetStatus.equals("03")?"false":"true","","Button","引入","引入一条合同信息","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"false","","Button","案件详情","察看合同详情","my_LawCase()","","","",""}	,
		{sAssetStatus.equals("03")?"false":"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""}		
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
		var sLawCaseSerialNo = "";	
		//获取抵债资产关联的合同流水号	
		var sLawCaseInfo  = AsDialog.OpenSelector("SelectRelativeLawCase","","");
		if(typeof(sLawCaseInfo) != "undefined" && sLawCaseInfo != "" && sLawCaseInfo != "_NONE_" 
		&& sLawCaseInfo != "_CLEAR_" && sLawCaseInfo != "_CANCEL_")  
		{
			sLawCaseInfo = sLawCaseInfo.split('@');
			sLawCaseSerialNo = sLawCaseInfo[0];
		}		
		if(sLawCaseSerialNo == "" || typeof(sLawCaseSerialNo) == "undefined") return;
		{	
			var sObjectType = "LawCase_Info";//关联类型  抵债资产关联案件信息
			var sDASerialNo = "<%=sSerialNo%>";	//抵债资产流水号
			var sSerialNo = initSerialNo();	//抵债资产抵债信息流水号  在DAO表中新增一条 抵债资产关联贷款信息 产生流水号
			var sReturn=PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/AddNPABCActionAjax.jsp?SerialNo="+sSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&RelativeContractNo="+sLawCaseSerialNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				popComp("PDAAssetLawCaseInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeLawCaseInfo.jsp","LawCaseSerialNo="+sLawCaseSerialNo+"&DASerialNo="+sDASerialNo+"&SerialNo="+sSerialNo);
				reloadSelf();
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
			var sSql = "delete npa_debtasset_object where serialno ='"+sSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue > -1){ 
				sMsg = "删除成功！";
			}else {
				sMsg = "删除失败！";
			}  
			alert(sMsg);
			//as_del("myiframe0");
			//as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{				
		sLawCaseSerialNo = getItemValue(0,getRow(),"OBJECTNO");  
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");		
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！	
			return;		
		}
		
		popComp("PDAAssetLawCaseInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeLawCaseInfo.jsp","LawCaseSerialNo="+sLawCaseSerialNo+"&SerialNo="+sSerialNo);
		reloadSelf();
	}	
	
	/*~[Describe=查看合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_LawCase()
	{  
		//获得合同流水号
		var sContractNo = getItemValue(0,getRow(),"ContractSerialNo");  //合同流水号或对象编号
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		sObjectType = "AfterLoan";
		sObjectNo = sContractNo;				
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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
