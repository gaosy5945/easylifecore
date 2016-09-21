<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xfliu 2014-04-13
		Tester:
		Describe: 
		Input Param:
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联额度申请信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	String packageNo = CurPage.getParameter("ObjectNo");//主申请编号
	if(StringX.isSpace(packageNo)) packageNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(StringX.isSpace(objectType)) objectType = "CreditApply";
	BizObject bo = null;
	String applyType = "";
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType)){
		//bo = com.amarsoft.app.als.process.action.GetApplyParams.getApplyParams(packageNo);
		CreditObjectAction coa=new CreditObjectAction(packageNo,objectType);
		applyType = coa.getString("ApplyType");
	}
	if(StringX.isSpace(applyType)) applyType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASObjectModel doTemp = new ASObjectModel("RelaLimitApplyList");
	//生成datawindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只
	dwTemp.genHTMLObjectWindow(objectType+","+packageNo);

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
		{"false","All","Button","新增","新增申请信息","newRecord()","","","",""},
		{"true","","Button","详情","查看申请详情","viewAndEdit()","","","",""},
		{"false","All","Button","删除","删除申请","deleteRecord()","","","",""},
	};
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType)){
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
	}
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		var applyType = "<%=applyType%>";	
		var packageNo = "<%=packageNo%>";
		var style = "dialogWidth=550px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		var compID = "NewApply";
		var compURL = "/CreditManage/CreditApply/NewApplyInfo.jsp";
		var returnMessage = popComp(compID,compURL,"ApplyType="+applyType+"&PackageNo="+packageNo,style);
		if(!returnMessage|| returnMessage=="_CANCEL_") return;
		returnMessage = returnMessage.split("@");
		var objectNo=returnMessage[0];
		var objectType=returnMessage[1];
        //根据新增申请的流水号，打开申请详情界面
		var paramString = "ObjectType="+objectType+"&ObjectNo="+objectNo;
		AsControl.OpenObjectTab(paramString);
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (!serialNo){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("确定取消该笔申请记录吗？")){
			var objectType = "<%=objectType%>";
			var returnMessage = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.InitializeApply","delRecord","ObjectNo="+serialNo+",ObjectType="+objectType);
			if(returnMessage == "SUCCESS"){
				alert("取消申请成功！");
			}else{
				alert("取消申请失败！");
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (!serialNo){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var paramString = "ObjectType=<%=objectType%>&ObjectNo="+serialNo;
		AsControl.OpenObjectTab(paramString);
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
