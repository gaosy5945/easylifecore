<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 产业详情页面
		Input Param:
		       --SerialNO:流水号
		Output param:
		History Log: 
		-- fbkang 重新整改页面

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产业详情页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	
	//定义变量
	
		//获得页面参数	：itemno
    	String itemNo = CurPage.getParameter("ItemNo");
		// 通过DW模型产生ASDataObject对象doTemp
		String sTempletNo = "IndustryInfo";//模型编号
		ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
		
		ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
		dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写

		//使用配置模板前的“显示后缀”
		//doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
		//doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
		
		//生成HTMLDataWindow
		dwTemp.genHTMLObjectWindow(itemNo);
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
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
	OpenPage("/CustomerManage/SpecialCustomerManage/IndustryList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload(){
		var itemNo = getItemValue(0,getRow(),"ItemNo");//--重新获得流水号
		OpenPage("/CustomerManage/SpecialCustomerManage/IndustryInfo.jsp?ItemNo="+itemNo+"", "_self","resizable=yes;dialogWidth=450px;dialogHeight=550px;center:yes;status:no;statusbar:no");
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			bIsInsert = true;
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORG","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"INPUTTIME","<%=StringFunction.getToday()%>");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
