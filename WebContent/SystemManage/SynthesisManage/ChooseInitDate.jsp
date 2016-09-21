<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 选择初始化日期区间
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择初始化日期区间"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	//获得组件参数
	String area = CurPage.getParameter("Area");
     area="Land";//默认为大陆
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ChooseInitDate";
	String sTempletFilter = "1=1";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
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
			{"true","","Button","初始化","初始化","doSure()","","","",""},
			{"true","","Button","取消","取消","javascript:top.close();","","","",""},
		};
	%> 
<%/*~END~*/%>
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function doSure()
	{
		var sBeginDate = getItemValue(0,0,"BeginDate");
		var sEndDate = getItemValue(0,0,"EndDate");
		//var datePara = sBeginDate+"@"+sEndDate;
		//alert(datePara);
		if(sBeginDate>=sEndDate){
			alert("开始日期必须小于结束日期。");
			return;
		}
		var years = sEndDate.substring(0,4) - sBeginDate.substring(0,4);
		if(years > 1){
			alert("时间跨度太大，请修改！");
			return;
		}
		//sReturn=AsCredit.runFunction("BizInitDay","Area=<%=area%>&BeginDate="+sBeginDate+"&EndDate="+sEndDate);
		sReturn = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.sys.holiday.BizInitDay","run","Area="+"<%=area%>"+",BeginDate="+sBeginDate+",EndDate="+sEndDate);
		top.returnValue = sReturn;
		top.close();
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
