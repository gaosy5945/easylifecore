<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sSerialNo = (String)CurComp.getParameter("SerialNo");	//资产流水号
	String sAssetStatus =  (String)CurComp.getParameter("AssetStatus");
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetStatus == null ) sAssetStatus = "";

	ASObjectModel doTemp = new ASObjectModel("PDALawCaseList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"03".equals(sAssetStatus)?"false":"true","All","Button","引入","引入一条合同信息","newRecord()","","","",""},
			{"true","","Button","抵债详情","查看/修改详情","viewAndEdit()","","","",""},
			{"true","","Button","案件详情","察看合同详情","my_LawCase()","","","",""}	,
			{"03".equals(sAssetStatus)?"false":"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","",""}		
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
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
			var sObjectType = "jbo.preservation.LAWCASE_INFO";//关联类型  抵债资产关联案件信息
			var sDASerialNo = "<%=sSerialNo%>";	//抵债资产流水号
			var sSerialNo = initSerialNo();	//抵债资产抵债信息流水号  在DAO表中新增一条 抵债资产关联贷款信息 产生流水号
			var sReturn=PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/AddNPABCActionAjax.jsp?SerialNo="+sSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&RelativeContractNo="+sLawCaseSerialNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				popComp("PDAAssetLawCaseInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeLawCaseInfo.jsp","LawCaseSerialNo="+sLawCaseSerialNo+"&DASerialNo="+sDASerialNo+"&SerialNo="+sSerialNo);
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
			var sSql = "delete npa_debtasset_object where serialno ='"+sSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue > -1){ 
				sMsg = "删除成功！";
			}else {
				sMsg = "删除失败！";
			}  
			alert(sMsg);
		}
		reloadSelf();
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
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"OBJECTNO");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			var sFunctionID="";
			if(sLawCaseType == "01" ){
				sFunctionID = "CaseInfoList1";
			}else{
				sFunctionID = "CaseInfoList2";
			}
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType+"&RightType=ReadOnly");	
		}	
		reloadSelf();	
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
<%@ include file="/Frame/resources/include/include_end.jspf"%>
