<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zqliu
		Tester:
		Content: 案件基本信息
		Input Param:
			        SerialNo:案件流水号
			        LawCaseType：案件类型			        
		Output param:
		               
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "案件基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数（案件流水号、案件类型）
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sLawCaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LawCaseType"));
	//将空值转化为空字符串
	if(sSerialNo == null ) sSerialNo = "";
	if(sLawCaseType == null ) sLawCaseType = "";
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	if (sLawCaseType.equals("01"))
		sTempletNo="LawCaseInfo1";	//一般案件
	else if (sLawCaseType.equals("02"))
		sTempletNo="LawCaseInfo2";	//公正/仲裁执行案件
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//自动计算诉讼总标的
//	doTemp.appendHTMLStyle("Principal,InDebtInterest,OutDebtInterest,OtherCost"," onChange=\"javascript:parent.getAimSum()\" ");
	
	//选择现机构及人员
	/* doTemp.setUnit("ManageUserName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.getOrgID()+"\",\"ManageUserID\",\"ManageUserName\",\"ManageOrgID\",\"ManageOrgName\")>");
	doTemp.setUnit("OperateUserName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.getOrgID()+"\",\"OperateUserID\",\"OperateUserName\",\"OperateOrgID\",\"OperateOrgName\")>");
	
	//选择法院
	doTemp.setUnit("CourtStatus"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getAgencyName()\">");
	doTemp.appendHTMLStyle("CourtStatus","  style={cursor:pointer;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getAgencyName()\" ");
	
	//根据不同的案件类型过滤我行的诉讼地位
	doTemp.setDDDWSql("LawsuitStatus","select ItemNo,ItemName from CODE_LIBRARY where isinuse='1' and CodeNo = 'LawsuitStatus' and trim(ItemAttribute) = '"+sLawCaseType+"' ");
	 */
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为： 0.是否显示 1.注册目标组件号(为空则自动取当前组件) 2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank) 3.按钮文字 4.说明文字 5.事件 6.资源图片路径
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		beforeUpdate();
		as_save("myiframe0");
	}
	
	/*~[Describe=选择受理机构名称;InputParam=无;OutPutParam=无;]~*/
	function getAgencyName()
	{		
		sParaString = "AgencyType"+",01";
		setObjectValue("SelectAgency",sParaString,"@CourtStatus@1",0,0,"");			
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	//根据输入的其中：本金，表内利息，表外利息，其它算出诉讼总标的	
	function getAimSum()
 	{ 
       sPrincipal = getItemValue(0,getRow(),"Principal");
       sInDebtInterest = getItemValue(0,getRow(),"InDebtInterest");
       sOutDebtInterest = getItemValue(0,getRow(),"OutDebtInterest");
       sOtherCost = getItemValue(0,getRow(),"OtherCost");
       sCurrency = getItemValue(0,getRow(),"Currency");
 
       if(typeof(sPrincipal)=="undefined" || sPrincipal.length==0) sPrincipal=0; 
       if(typeof(sInDebtInterest)=="undefined" || sInDebtInterest.length==0) sInDebtInterest=0;
       if(typeof(sOutDebtInterest)=="undefined" || sOutDebtInterest.length==0) sOutDebtInterest=0; 
       if(typeof(sOtherCost)=="undefined" || sOtherCost.length==0) sOtherCost=0; 

		//获取币种sCurrency对人民币的汇率
		//var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialogAjax.jsp?ReclaimCurrency="+sCurrency,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//sReturn = sReturn.split("@");
		//sRatio=sReturn;//[0];
		//sOtherCost=sOtherCost*sRatio;  //转换为外币
		  
       //诉讼总标的=其中：本金+表内利息+表外利息+其它
       sAimSum = sPrincipal+sInDebtInterest+sOutDebtInterest+sOtherCost;
	   setItemValue(0,getRow(),"AimSum",sAimSum);       
    }
     	
    /*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{		
		sParaString = "BelongOrg"+","+sParam;
		setObjectValue("SelectUserBelongOrg",sParaString,"@"+sUserID+"@0@"+sUserName+"@1@"+sOrgID+"@2@"+sOrgName+"@3",0,0,"");
	}
		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//新增记录
			setItemValue(0,0,"Currency","CNY");
			setItemValue(0,0,"CasePhase","010");
			setItemValue(0,0,"LawCaseType","<%=sLawCaseType%>");

		}

		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		<%-- setItemValue(0,0,"CourStatusName","<%=sCourStatusName%>"); --%>
    }
	
	/*~[Describe=代理/受理 机构信息：起诉法院;InputParam=无;OutPutParam=无;]~*/
	function getAgencyName(){
		sParaString = "AgencyType"+",01,DepartType,01";  //AGENCYTYPE='01' DepartType='01'
		//modified by qjliang 添加返回CourtNo 法院编号
		setObjectValue("SelectAgency",sParaString,"@CourtStatus@0@CourtStatusName@1",0,0,"");	
		//AsDialog.OpenSelector(sSelname,sParaString,sStyle)
	}
	
	initRow();	
	</script>

<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

