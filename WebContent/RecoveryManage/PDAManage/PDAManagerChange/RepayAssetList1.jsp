<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  zqliu
		Tester:
		Content: 抵债资产管理人变更
		Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：已抵入/处置中的资产列表
			    ComponentType		组件类型： ListWindow
		Output param:
				ObjectNo				抵债资产编号
				ObjectType			LAP_REPAYASSETINFO
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产管理人变更---资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;抵债资产管理人变更---资产列表&nbsp;&nbsp;";
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sComponentType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentType"));	
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String sTempletNo = "AssetManageUserList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
				{"true","","Button","资产详情","查看抵债资产详情","viewAndEdit()","","","",""},
				{"true","","Button","变更管理人","变更管理人","Change_Manager()","","","",""},
				{"true","","Button","查看变更记录","查看变更记录","Change_History()","","","",""}
			};
			
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看资产详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号
		var sDASerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAISerialNo = getItemValue(0,getRow(),"AssetSerialNo");					
		if (typeof(sDASerialNo) == "undefined" || sDASerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sDASerialNo+"&AssetSerialNo="+sAISerialNo,"");
		reloadSelf();
	}

	/*~[Describe=变更管理人信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function Change_Manager()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //获得抵债资产流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！			
		}else
		{
			var sDAOSerialNo = getSerialNo("npa_debtasset_object","SerialNo","");
			var sDATSerialNo = getSerialNo("npa_debtasset_transaction","SerialNo","");
			var sManageOrgID=getItemValue(0,getRow(),"ManageOrgID");	
			var sManageOrgName=getItemValue(0,getRow(),"ManageOrgName");	
			var sManageUserID=getItemValue(0,getRow(),"ManageUserID");	
			var sManageUserName=getItemValue(0,getRow(),"ManageUserName");	
			OpenPage("/RecoveryManage/Public/ChanageManagerInfo.jsp?"+
					"ObjectType=DAChangeManager&ObjectNo="+sSerialNo+
					"&OldManagerUserId="+sManageUserID+
					"&OldManagerUserName="+sManageUserName+
					"&OldManagerOrgId="+sManageOrgID+
					"&OldManagerOrgName="+sManageOrgName+
					"&DAOSerialNo="+sDAOSerialNo+
					"&DATSerialNo="+sDATSerialNo+"&GoBackType=2","right");
		}
	}

	/*~[Describe=查看变更管理人历史;InputParam=无;OutPutParam=SerialNo;]~*/	
	function Change_History()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //获得抵债资产流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！			
		}else
		{ 
			//关联类型：LIChangeManager 案件管理人变更、DAChangeManager 抵债资产管理人变更、PDAChangeManager 已核销资产管理人变更
			OpenPage("/RecoveryManage/Public/ChangeManagerList.jsp?ObjectType=DAChangeManager&ObjectNo="+sSerialNo+"&GoBackType=2","right");
		}
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
