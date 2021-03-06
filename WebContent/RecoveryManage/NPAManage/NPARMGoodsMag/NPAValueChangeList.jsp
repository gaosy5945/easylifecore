<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: 抵质押物信息变更列表;
		Input Param:
			ChangeType: 变更类型（010：价值变更；020：其他变更；030：他项权证变更）
			GuarantyID: 担保物流水号			
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵质押物信息变更列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletFilter = "";
	String sTempletNo = "";
	//获得组件参数	
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));
	String sChangeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ChangeType"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyType"));
	//将空值转化为空字符串
	if(sChangeType == null) sChangeType = "";
	if(sGuarantyID == null) sGuarantyID = "";
	if(sGuarantyType == null) sGuarantyType = "";
	if(sFinishType == null) sFinishType = "";
	//获得页面参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//显示模板		
	if(sGuarantyType.equals("050")){
		sTempletNo = "PawnChangeList";	
	}
	else if(sGuarantyType.equals("060")){
		sTempletNo = "ImpawnChangeList";
	}
	else{
		out.print("担保方式不是抵押或质押，无法显示变更信息!");
	}
		
	//根据ChangeType的不同，得到不同的过滤条件
    sTempletFilter = " (ColAttribute like '%"+sChangeType+"%' ) ";

	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);	

        	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//设置setEvent
	dwTemp.setEvent("AfterDelete","!BusinessManage.UpdateGuarantyChangeInfo("+sGuarantyID+",,"+sChangeType+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID+","+sChangeType);
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
				{sFinishType.equals("")?"true":"false","","Button","新增","新增抵质押物信息变更","newRecord()","","","",""},
				{"true","","Button","详情","查看抵质押物信息变更详情","viewAndEdit()","","","",""},
				{sFinishType.equals("")?"true":"false","","Button","删除","删除抵质押物信息变更","deleteRecord()","","","",""}
			};			
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeInfo.jsp?ChangeType=<%=sChangeType%>&GuarantyType=<%=sGuarantyType%>","_self");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}		
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeInfo.jsp?SerialNo="+sSerialNo+"&GuarantyType=<%=sGuarantyType%>","_self");
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