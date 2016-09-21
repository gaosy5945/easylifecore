<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("LawCaseAgencyList");
	
	String role [] = {"PLBS0052"};
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.InputOrgID) ");
	}else{
		doTemp.appendJboWhere(" and O.InputUserID='"+CurUser.getUserID()+"' ");
	}

	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","新增","新增代理机构","newRecord()","","","",""},
			{"true","","Button","详情","查看代理机构","viewAndEdit()","","","",""},
			
			{"true","","Button","下属代理人","查看下属代理人","my_agent()","","","",""},
			{"true","","Button","已代理案件","查看已代理案件","my_lawcase()","","","",""},
			{"true","","Button","删除","删除代理机构","deleteRecord()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		AsControl.PopComp("/RecoveryManage/Public/AgencyInfo.jsp","","");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_delete(0);

			//as_del('myiframe0');
			//as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var inputUserID = getItemValue(0,getRow(),"InputUserID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		if(inputUserID!="<%=CurUser.getUserID()%>"){
			rightType = "ReadOnly";
		}
		AsControl.PopComp("/RecoveryManage/Public/AgencyInfo.jsp","SerialNo="+sSerialNo+"&RightType="+rightType, "","");
		reloadSelf();
	}
	
	/*~[Describe=下属代理人信息;InputParam=无;OutPutParam=无;]~*/
	function my_agent()
	{
		//获得代理机构流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/Public/AgentList.jsp","BelongNo="+sSerialNo+"&Flag=Y&rand="+randomNumber(),"","");
		reloadSelf();
	}
	
	/*~[Describe=已代理案件信息;InputParam=无;OutPutParam=无;]~*/
	function my_lawcase()
	{
		//获得法院流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/Public/SupplyLawCase.jsp","QuaryName=OrgNo&QuaryValue="+sSerialNo+"&Back=1&rand="+randomNumber(),"","");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
