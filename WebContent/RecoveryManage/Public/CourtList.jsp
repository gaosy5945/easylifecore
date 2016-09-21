<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "受理机关信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASObjectModel doTemp = new ASObjectModel("CourtList");

	
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
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

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
		{"true","","Button","新增","新增代理机构","newRecord()","","","",""},
		{"true","","Button","详情","查看代理机构","viewAndEdit()","","","",""},
		
		{"true","","Button","下属受理机关人员","查看下属受理机关人员","my_courtPerson()","","","",""},
		{"true","","Button","已受理案件","查看已受理案件","my_lawcase()","","","",""},
		{"true","","Button","删除","删除代理机构","deleteRecord()","","","",""}
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		AsControl.PopComp("/RecoveryManage/Public/CourtInfo.jsp","","");
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_delete(0);
			/* as_del('myiframe0');
			as_save('myiframe0');  */ //如果单个删除，则要调用此语句
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
		AsControl.PopComp("/RecoveryManage/Public/CourtInfo.jsp","SerialNo="+sSerialNo+"&RightType="+rightType, "","");
		reloadSelf();
	}


	//下属受理机关方人员信息
	function my_courtPerson()
	{
		//获得受理机关流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			AsControl.PopComp("/RecoveryManage/Public/CourtPersonList.jsp","BelongNo="+sSerialNo+"&Flag=Y&rand="+randomNumber(),"","");           	
		}		
	}
	//已受理案件信息
	function my_lawcase()
	{
		//获得受理机关流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			AsControl.PopComp("/RecoveryManage/Public/SupplyLawCase.jsp","QuaryName=OrgNo&QuaryValue="+sSerialNo+"&Back=3&rand="+randomNumber(),"","");           	
		}		
	}

	</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
