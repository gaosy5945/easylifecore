<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//定义变量
	boolean bIsBelong = false; //是否是点击所属机构进入的
		
	//获得页面参数
	String sBelongNo = CurPage.getParameter("BelongNo");
	String sFlag = CurPage.getParameter("Flag");
	if(sBelongNo == null) sBelongNo = "";
	if(sFlag == null) sFlag = ""; //Flag=Y表示从代理机构列表进入的
	

	String sTempletNo = "",doWhereSql="";
	if(sBelongNo.equals(""))
	{
		sTempletNo = "AgentList";//模型编号
		String role [] = {"PLBS0052"};
		if(CurUser.hasRole(role)){
			doWhereSql = " and exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
					+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.InputOrgID) ";
		}else{
			doWhereSql = " and O.InputUserID='"+CurUser.getUserID()+"' ";
		}
	}else
	{
	 	bIsBelong = true;
	 	sTempletNo = "AgentList1";//模型编号
	 }      


	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	doTemp.appendJboWhere(doWhereSql);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	if(bIsBelong)
	{
		dwTemp.setParameter("BelongNo",sBelongNo);
		dwTemp.setParameter("Flag",sFlag);
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","新增","新增代理人","newRecord()","","","",""},
			{"true","","Button","详情","查看代理人","viewAndEdit()","","","",""},
			
			{"true","","Button","已代理案件","查看已代理案件","my_lawcase()","","","",""},
			{"true","","Button","返回","返回列表页面","goBack()","","","",""},
			{"true","","Button","删除","删除代理人","deleteRecord()","","","",""}
		};
	
	
	if(sFlag.equals("Y")) //从机构信息列表进入
	{
		sButtons[0][0]="false";		
		sButtons[4][0]="false";
	}else
	{
		sButtons[3][0]="false";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		AsControl.PopComp("/RecoveryManage/Public/AgentInfo.jsp","","");
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
		AsControl.PopComp("/RecoveryManage/Public/AgentInfo.jsp","SerialNo="+sSerialNo+"&RightType="+rightType, "","");
		reloadSelf();
	}
	
	/*~[Describe=返回到代理机构列表;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{     	
		self.close();
		/* OpenPage("/RecoveryManage/Public/AgencyList.jsp?rand="+randomNumber(),"_self",""); */
	}
	
	/*~[Describe=已代理案件信息;InputParam=无;OutPutParam=无;]~*/
	function my_lawcase()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/Public/SupplyLawCase.jsp","QuaryName=PersonNo&QuaryValue="+sSerialNo+"&Back=2&rand="+randomNumber(),"","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
