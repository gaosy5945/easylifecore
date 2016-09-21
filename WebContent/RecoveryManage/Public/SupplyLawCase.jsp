<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//定义变量
	String sSql = "";
	
	//获得组件参数
	
	//获得页面参数	    
	String sQuaryName = CurPage.getParameter("QuaryName");
	String sQuaryValue = CurPage.getParameter("QuaryValue");
	String sBack = CurPage.getParameter("Back");
	//将空值转化为空字符串
	if(sQuaryName == null) sQuaryName = "";
	if(sQuaryValue == null) sQuaryValue = "";
	if(sBack == null) sBack = "";
	
	//通过DW模型产生ASDataObject对象doTemp
    String sTempletNo = "";
	
	if(sQuaryName.equals("OrgNo"))
	{
		sTempletNo = "SupplyLawCaseList";//模型编号
	}
	
	if(sQuaryName.equals("PersonNo"))
	{
		sTempletNo = "SupplyLawCaseList1";//模型编号
	}
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//查询已受理案件时增加机构与用户限制，与诉讼案件日常管理保持一致  
	doTemp.setJboWhere(doTemp.getJboWhere() + " and O.MANAGEORGID = '"+CurOrg.getOrgID()+"' AND O.MANAGEUSERID = '"+CurUser.getUserID()+"'");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sQuaryValue+","+sQuaryName+","+sBack);

	String sButtons[][] = {
			{"true","","Button","详情","详情","viewAndEdit()","","","",""},
			{"true","","Button","返回","返回","goBack()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
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
			reloadSelf();	
		}
	}
	
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{		
		self.close();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
