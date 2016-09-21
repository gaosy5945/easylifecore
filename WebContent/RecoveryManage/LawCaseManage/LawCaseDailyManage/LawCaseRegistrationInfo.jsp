<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zqliu 2014.11.22
		Tester:
		Content: 立案登记
		Input Param:
			        SerialNo:台帐编号
			        ObjectNo:案件编号或对象类型
			        ObjectType：对象类型
			        BookType ：台帐类型
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "台帐信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sLawsuitStatus = "";
	
	//获得页面参数
	//台帐编号、台帐类型
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sBookType == null) sBookType = "";
	
	//案件编号或对象编号、对象类型、案件类型
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sLawCaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LawCaseType"));
	String sDate = StringFunction.getToday();
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sLawCaseType == null) sLawCaseType = "";
	
	//获得对应案件的诉讼地位，如果为原告、则我行败诉未付金额不用自动计算
	sSql =  " select LawsuitStatus from LAWCASE_INFO where SerialNo =:SerialNo ";
	//我行的诉讼地位
	sLawsuitStatus = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sLawsuitStatus == null) sLawsuitStatus = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sItemdescribe = "";
	String sItemdescribe1 = "";
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//根据不同的案件类型显示不同的生效判决书
	if (sLawCaseType.equals("01"))	//一般案件
		sItemdescribe1="10";
	if (sLawCaseType.equals("02"))	//公证仲裁案件
		sItemdescribe1="20";		
	
	sTempletNo="BeforeLawsuitInfo";
	sItemdescribe = "10";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写	
	
	if(sLawsuitStatus.equals("01"))   
	{
		doTemp.setReadOnly("JudgeNoPaySum",false);//设置只读
	}
	
	//根据不同的台帐类型过滤受理结果
	doTemp.setDDDWSql("CognizanceResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CognizanceResult' and Itemdescribe like '%"+sItemdescribe+"%' ");
	
	//根据不同的案件类型过滤生效判决书
	doTemp.setDDDWSql("JudgementNo","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'JudgementNo' and Itemdescribe like '"+sItemdescribe1+"%' ");
	
	//保存时后续事件（传入案件编号、台帐类型）
  	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");
	
	//更新保存时后续事件（传入案件编号、台帐类型）
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);	
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
			{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
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
	var sSaveFlag="FALSE";
	//---------------------定义按钮事件------------------------------------
		
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{

		setItemValue(0,0,"BookType","<%=sBookType%>");					
		setItemValue(0,0,"LawCaseSerialNo","<%=sObjectNo%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		as_save("myiframe0","setSaveFlag()");
		if(sSaveFlag=="TRUE"){
			self.returnValue="TRUE";
			self.close();
		}
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function setSaveFlag()
	{
		sSaveFlag="TRUE";
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=执行新增操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		//initSerialNo();//初始化流水号字段		
		bIsInsert = false;
	}

	/*~[Describe=选择受理机构 --不同的受理机构类型;InputParam=无;OutPutParam=无;]~*/
	function getAgencyForDepartType(DepartType){
		var sDepartType = "";
		if(DepartType==1){
			sDepartType = "01";
		}else if(DepartType==2){
			sDepartType="02";
		}else if(DepartType=3){
			sDepartType="03";
		}
		sParaString = "AgencyType,01,DepartType,"+sDepartType;
		setObjectValue("SelectAgencyForDepartType",sParaString,"@AcceptedCourt@1",0,0,"");
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;	

			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");		
			//台帐类型
			setItemValue(0,0,"BookType","<%=sBookType%>");					
			setItemValue(0,0,"LawCaseSerialNo","<%=sObjectNo%>");
								
			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//登记日期	更新日期					
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "LAWCASE_BOOK";//表名
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
	self.returnValue=sSaveFlag;	//返回 
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

