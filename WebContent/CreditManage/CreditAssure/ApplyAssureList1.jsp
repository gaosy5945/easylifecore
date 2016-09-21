<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: 业务申请所对应的新增的担保信息列表（一个保证合同对应一个保证人）;
		Input Param:
				ObjectType：对象类型（CreditApply）
				ObjectNo: 对象编号（申请流水号）
		Output Param:
				
		HistoryLog:gftang 2013-5-9 改成模板生成
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	String packageNo = CurPage.getParameter("PackageNo");//主申请编号
	if(StringX.isSpace(packageNo)) packageNo = "";
	BizObject bo = null;
	String applyType = "";
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(sObjectType)){
 		CreditObjectAction coa=new CreditObjectAction(sObjectNo,sObjectType);
		applyType =coa.getString("ApplyType");// bo.getAttribute("ApplyType").getString();
	}
	if(StringX.isSpace(applyType)) applyType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
 //通过DW模型产生ASDataObject对象doTemp
	String sTempletNo="ApplyAssureList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
		{"true","All","Button","新增","新增担保信息","newRecord()","","","",""},  
		{"true","","Button","详情","查看担保信息详情","viewAndEdit()","","","",""},
		{"true","All","Button","删除","删除担保信息","deleteRecord()","","","",""},
		{"true","","Button","担保客户详情","查看担保相关的担保客户详情","viewCustomerInfo()","","","",""}, 
		{"false","","Button","自动添加联保成员担保","自动添加联保成员担保","autoAddGuarantyContract()","","","",""}, 
		};
	if(CreditConst.APPLYTYPE_UGBODY.equals(applyType)){
		sButtons[4][0] = "true";
	}
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
		sGuarantyType=PopPage("/CreditManage/CreditAssure/AddAssureDialog.jsp","","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sGuarantyType) != "undefined" && sGuarantyType.length != 0 && sGuarantyType != '_none_')
		{
			OpenPage("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp?GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
			{
				alert(getHtmlMessage('7'));//信息删除成功！
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('8'));//对不起，删除信息失败！
				return;
			}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保信息编号
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--担保方式
			OpenPage("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//系统中不存在担保人的客户基本信息，不能查看！
			else
				AsCredit.openFunction("CustomerDetail","CustomerID="+sCustomerID,"");
				//openObject("Customer",sCustomerID,"002");
		}
	}


	/*~[Describe=选中某笔担保合同,联动显示担保项下的抵质押物;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");			
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=保证担保下无详细信息!","DetailFrame","");
			}else 
			{
				if (sGuarantyType.substring(0,3) == "050") //抵押
					OpenPage("/CreditManage/GuarantyManage/ApplyPawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
				else //质押
					OpenPage("/CreditManage/GuarantyManage/ApplyImpawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
			}
		}
	}
	/*~[Describe=自动添加联保成员保证担保;InputParam=无;OutPutParam=无;]~*/
	function autoAddGuarantyContract(){
		var packageNo = "<%=packageNo%>";
		var objectNo = "<%=sObjectNo%>";
		var userID = "<%=CurUser.getUserID()%>";
		if(confirm("确认自动添加其他联保成员的保证担保吗？")){
			var returnMessage = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.InitializeApply","autoAddGuarantyContract","PackageNo="+packageNo+",ObjectNo="+objectNo+",UserID="+userID);
			if(returnMessage == "SUCCESS"){
				alert("增加成功！");
			}else{
				alert("增加失败！");
			}
		}
		reloadSelf();
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
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的担保信息!","DetailFrame","");
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>