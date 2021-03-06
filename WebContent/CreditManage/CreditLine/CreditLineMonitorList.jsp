<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: 授信额度监控列表页面
		Input Param:
			
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度监控"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
    String sToday = StringFunction.getToday();
	
	//获得组件参数	
	
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//显示标题				
 String sTempletNo="CreditLineMonitorList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteLineRelative(#BCSerialNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sToday);
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
		{"true","","Button","额度详情","查看/修改详情","openWithObjectViewer()","","","",""},
		{"true","","Button","授信额度项下业务","相关授信额度项下业务","lineSubList()","","","",""},
		{"true","","Button","额度使用查询","检查所选中的额度项下业务的合法性","checkCreditLine()","","","",""},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=授信额度项下业务;InputParam=无;OutPutParam=无;]~*/
	function lineSubList()
	{		
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//modify by hwang 20070701,修改组件参数。将CreditAggreement改为LineNo
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","LineNo="+sSerialNo,"","");
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer(){
		var sLineID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		openObject("BusinessContract",sLineID,"002");
	}
	
	/*~[Describe=检查所选中的额度项下业务的合法性;InputParam=无;OutPutParam=无;]~*/
	function checkCreditLine(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");

		if (typeof(serialNo)=="undefined" || serialNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }  
		AsControl.PopView("/CreditManage/CreditLine/CreditLineUseList.jsp","SerialNo="+serialNo,"dialogWidth=800px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//alert("返回值："+sReturn+" \n说明： Refuse 表示授信校验不通过  Pass 表示授信校验通过!");
	}

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
