<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   XWu  2004.11.29
		Tester:
		Content: 债权让步记录管理
		Input Param:
			sObjectType  :对象类型(组件参数)
			sObjectNo    :对象类型(组件参数)
			sSerialNo    :取流水号
		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "债权让步记录管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数	
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType")); //对象类型  
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //对象类型
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); //对象类型
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sFinishType == null) sFinishType = "";
	if(sFinishType == null) sFinishType = "";
	//获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo")); //取流水号
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ConsessionInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//定义自动累计字段
/* 	doTemp.appendHTMLStyle("ConcedeCorpusSum"," onChange=\"javascript:parent.getConcedeSumRate()\" "); */

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	double dBalance = 0;
	//取合同当前金额
	String sSql = " Select Balance from BUSINESS_CONTRACT Where SerialNo = :SerialNo";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));	
	while(rs.next()){
		dBalance = rs.getDouble(1);
	}
	rs.getStatement().close();    
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
		{sFinishType.equals("")?"true":"false","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/ConsessionList.jsp","_self","");
	}
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAuditUser()
	{
		setObjectValue("SelectAllUser","","@ApprovePerson@1@ApproveOrgName@3",0,0,"");		
	}	
  	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser()
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
	}	
    	
 	//计算让步金额占合同余额比例=债权让步本金金额(元)/合同本金
 	function getConcedeSumRate()
 	{ 	
 		sConcedeCorpusSum = getItemValue(0,getRow(),"ConcedeCorpusSum");
 		if(typeof(sConcedeCorpusSum)=="undefined" || sConcedeCorpusSum.length==0) 
 			sConcedeCorpusSum=0; 
		
   		if( <%=dBalance%> <= 0.01 ) 
   			sConcedeSumRate = 0;
   		else
   			sConcedeSumRate = sConcedeCorpusSum/<%=dBalance%>*100;
		if(sConcedeSumRate>100){
			alert("让步金额占合同余额比例值应小于100");
		}
		else
			setItemValue(0,getRow(),"ConcedeSumRate",Math.round(sConcedeSumRate*100)/100);
     }

</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"ConcedeDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
		}
		
		setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
    }
    
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CONCEDE_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
