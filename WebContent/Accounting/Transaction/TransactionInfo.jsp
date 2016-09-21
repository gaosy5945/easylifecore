<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS"%>
<%@page import="com.amarsoft.app.base.config.impl.TransactionConfig"%>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  xjzhao 2015/11/17
		Tester:
		Content: 交易详情
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "交易申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String serialNo =CurPage.getParameter("SerialNo");//交易流水号
	
	BusinessObjectManager bom = new BusinessObjectManager();
	BusinessObject bo = bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction,"SerialNo",serialNo);
	if(bo == null)  throw new Exception("交易不存在！");
	String transCode = bo.getString("TransCode");
	String transStatus = bo.getString("TransStatus");
	String relaObjectType = bo.getString("RelativeObjectType");
	String relaObjectNo = bo.getString("RelativeObjectNo");
	String documentNo = bo.getString("DocumentNo");
	String documentType = bo.getString("DocumentType");
	//模板，交易类型，关联主体使用名
	BusinessObject templete = TransactionConfig.getTransactionConfig(transCode);
	String templeteNo=templete.getString("ViewTempletNo");
	String tranType=templete.getString("Type");
	
	String businessDate = DateHelper.getBusinessDate();
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", documentType);
	inputParameter.setAttributeValue("ObjectNo", documentNo);
	inputParameter.setAttributeValue("TransactionSerialNo", serialNo);
	
	//通过显示模版产生ASObjectModel对象doTemp
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templeteNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	DefaultObjectWindowController dwcontroller = new DefaultObjectWindowController();
	dwcontroller.initDataWindow(dwTemp,bom.keyLoadBusinessObject(relaObjectType, relaObjectNo));
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLObjectWindow
	dwTemp.genHTMLObjectWindow(serialNo);
	
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
		{"true","All","Button","保存","保存交易信息","saveRecord('afterSave()')",""},
		{"false","All","Button","还款计划测算","还款计划测算","viewConsult()",""},
	};
	if(("2002".equals(transCode) )  && !"1".equals(transStatus)){
		sButtons[1][0] = "true";
	}
	%> 
<%/*~END~*/%>


<%@include file="/Frame/resources/include/ui/include_info.jspf"%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=数据保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(!beforeSave()) return;  //公用校验添加
		as_save(sPostEvents);
	}
	
	/*~[Describe=根据自定义小数位数四舍五入,参数object为传入的数值,参数decimal为保留小数位数;InputParam=基数，四舍五入位数;OutPutParam=四舍五入后的数据;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	
	/*~[Describe=设置空值;InputParam=后续事件;OutPutParam=无;]~*/
	function setValue(colName,Value)
	{
		var sColName = getItemValue(0,getRow(),colName);
		if(typeof(sColName) == "undefined" || sColName.length == 0)
		{
			setItemValue(0,getRow(),colName,Value);
		}
	}
	</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>
<%
	/*通过配置文件获取每个交易对应的不同的JS文件--JSFile*/
	String jsfile=TransactionConfig.getTransactionConfig(transCode, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
		String[] s=jsfile.split("@");
		for(String s1:s){
%>
<script type="text/javascript" src="<%=sWebRootPath+s1%>">  </script>
<%		}
	}
	else{
%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/transaction/transaction.js"> </script>
<%		
	}
	%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>

<script language=javascript>	
	var bFreeFormMultiCol = true;
	var bCheckBeforeUnload = false;
	var businessDate = "<%=businessDate%>";
	var curUserID = "<%=CurUser.getUserID()%>";
	var curUserName = "<%=CurUser.getUserName()%>";
	var curOrgID = "<%=CurOrg.getOrgID()%>";
	var curOrgName = "<%=CurOrg.getOrgName()%>";
	var documentType = "<%=documentType%>";
	var documentNo = "<%=documentNo%>";
	var transactionSerialNo = "<%=serialNo%>";
	var relaObjectNo = "<%=relaObjectNo%>";
	var relaObjectType = "<%=relaObjectType%>";
	var objectType = "<%=documentType%>";
	var objectNo = "<%=documentNo%>";
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>