<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 新增提款记录;
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "用款记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sItemNo = CurPage.getParameter("ItemNo");

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	 
	 ASObjectModel doTemp = null;
	 String sTempletNo = "UsedRecordInfo";
	 doTemp = new ASObjectModel(sTempletNo);//新增模型：2013-5-9
	 
	 
	 doTemp.setDefaultValue("ItemDate",StringFunction.getToday());
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sObjectType+","+sItemNo);//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存并返回","保存提款记录并返回","saveRecord()","","","",""}
		};
	%>
<%/*~END~*/%>


<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		initSerialNo();//初始化流水号字段
		as_save("myiframe0","goBack()");
	}
	function goBack()
	{
		OpenPage("/CreditManage/CreditCheck/UsedRecordList.jsp?SerialNo=<%=sSerialNo%>&rand="+randomNumber(),"_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ItemType","02");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"ItemNo","<%=sItemNo%>");
		}
    }
	//新增ItemNo记录：2013-5-9
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "INSPECT_DETAIL";//表名
		var sColumnName = "ItemNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntStockInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>

