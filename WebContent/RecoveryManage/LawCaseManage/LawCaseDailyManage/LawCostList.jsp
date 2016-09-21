<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zqliu
		Tester:
		Content: 法律费用台帐列表
		Input Param:
				SerialNo：案件编号				      
		Output param:
				ObjectNo：对象编号
				ObjectType：对象类型
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "法律费用台帐列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
		
	//获得组件参数（案件流水号）	
	String sSerialNo =  DataConvert.toString(CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>

<%

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LawCostList";//模型编号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow(sSerialNo);
	
	
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
		{"true","All","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","All","Button","删除","删除所选中的记录","del()","","","",""},
		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{			
		AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCostInfo.jsp","ObjectNo=<%=sSerialNo%>&ObjectType=LawcaseInfo&SerialNo=","right","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function del(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		}
		if(!confirm("确认删除吗?")) return;
		as_delete(0);
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得记录流水号、案件编号或对象编号、对象类型
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCostInfo.jsp","SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"","right","");
	}
	
	</script>
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>