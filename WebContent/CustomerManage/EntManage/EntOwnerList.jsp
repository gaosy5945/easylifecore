<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --股东情况列表;
		Input Param:
			CustomerID：--当前客户编号
		Output Param:
			CustomerID：--当前客户编号
			RelativeID：--关联客户组织机构代码
			Relationship：--关联关系      
			EditRight:--权限代码（01：查看权；02：维护权）      
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	参数、格式
			2009-6-25   fwang   增加展现"是否有效"			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "股东情况列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%


	//获得页面参数	
	
	//获得组件参数：用户编号	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";

	String sTempletNo = "EntOwnerList"; //模版编号

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页
	
	//设置setEvent
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//传入显示模板参数
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
			{"true","All","Button","新增","新增资本构成","newRecord()","","","",""},
			{"true","","Button","详情","查看资本构成详情","viewAndEdit()","","","",""},
			{"true","All","Button","删除","删除资本构成","deleteRecord()","","","",""},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserID");//--用户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID == '<%=CurUser.getUserID()%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{      
		sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.getUserID()%>')
			sEditRight='02';
		else
			sEditRight='01'; 
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--客户代码
		sRelationShip = getItemValue(0,getRow(),"RelationShip");//--客户关联
		sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight="+sEditRight, "_self","");
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


<%@	include file="/IncludeEnd.jsp"%>
