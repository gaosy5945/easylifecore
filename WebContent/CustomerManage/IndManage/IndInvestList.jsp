<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "对外股权投资信息列表";
	//获得页面参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID==null) sCustomerID="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "IndInvestList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","All","Button","新增","新增股权投资信息","newRecord()","","","",""},
		{"true","","Button","详情","查看股权投资信息详情","viewAndEdit()","","","",""},
		{"true","All","Button","删除","删除股权投资信息","deleteRecord()","","","",""},
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
		OpenPage("/CustomerManage/IndManage/IndInvestInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"InputUserId");//--用户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>')
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
		sUserID=getItemValue(0,getRow(),"InputUserId");
		if(sUserID=='<%=CurUser.getUserID()%>')
			sEditRight='02';
		else
			sEditRight='01'; 
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--客户代码
		sRelationShip = getItemValue(0,getRow(),"RelationShip");//--关联关系
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CustomerManage/IndManage/IndInvestInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight="+sEditRight, "_self","");
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
