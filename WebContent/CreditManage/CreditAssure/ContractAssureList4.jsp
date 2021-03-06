<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-28
		Tester:
		Describe: 担保合同所对应的拟引入的担保合同列表（一个保证合同对应多个保证人）;
		Input Param:
				ObjectType：对象类型（BusinessContract）
				ObjectNo: 对象编号（合同流水号）
		Output Param:
				
		HistoryLog:				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "拟引入担保合同列表"; // 浏览器窗口标题 
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
	//add by hwang 20090721.解决贷后管理中抵质押物详情显示不了问题。当对象类型为AfterLoan等其他类型时,GUARANTY_RELATIVE表中无数据。
	//现在修改逻辑,当对象类型为非申请、审批、合同时，默认为合同《
	if(!(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))){
		sObjectType="BusinessContract";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","担保合同编号"},
							{"GuarantyTypeName","担保方式"},							
							{"GuarantorName","担保人名称"},
							{"GuarantyValue","担保总金额"},				            
							{"GuarantyCurrency","币种"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	sSql =  " select GC.SerialNo,GC.CustomerID,GC.GuarantyType, "+
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName "+
			" from GUARANTY_CONTRACT GC "+
			" where  exists (Select CR.ObjectNo from CONTRACT_RELATIVE CR where "+
			" CR.SerialNo = '"+sObjectNo+"' and CR.ObjectType='GuarantyContract' "+
			" and CR.ObjectNo = GC.SerialNo) and GC.ContractType='020'"+
			" and (ContractStatus = '010' or ContractStatus = '020') ";
	
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,InputUserID,InputOrgID",false);
	doTemp.setUpdateable("GuarantyTypeName,GuarantyCurrency,InputUserName,InputOrgName",false);
	//设置格式
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
	//获取业务申请人代码
	sSql = " select CustomerID from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sCustomerID == null) sCustomerID = "";
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
		{"true","All","Button","引入","引入担保合同信息","importRecord()","","","",""},
		{"true","","Button","详情","查看担保合同信息详情","viewAndEdit()","","","",""},
		{"true","All","Button","删除","删除担保合同信息","deleteRecord()","","","",""},
		{"true","","Button","担保客户详情","查看担保合同相关的担保客户详情","viewCustomerInfo()","","","",""},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=引入记录;InputParam=无;OutPutParam=无;]~*/
	function importRecord(){
	    //传入当前的条件即可
		sParaString = "RelativeTableName,CONTRACT_RELATIVE RT,ObjectNo,<%=sObjectNo%>,ContractStatus,020,ContractType,020,OrgID,<%=CurUser.getOrgID()%>";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","ImportGauarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
		if(sReturn == "EXIST") alert(getBusinessMessage('415'));//该担保合同已经引入！
		if(sReturn == "SUCCEEDED") {
			alert(getBusinessMessage('416'));//引入担保合同成功！
			reloadSelf();
		}
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED"){
				alert(getHtmlMessage('7'));//信息删除成功！
				reloadSelf();
			}else{
				alert(getHtmlMessage('8'));//对不起，删除信息失败！
				return;
			}	
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--担保方式
			OpenPage("/CreditManage/CreditAssure/ContractAssureInfo4.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//系统中不存在担保人的客户基本信息，不能查看！
			else
				AsCredit.openFunction("CustomerDetail","CustomerID="+sCustomerID,"");
				//openObject("Customer",sCustomerID,"002");
		}
	}
	
	/*~[Describe=选中某笔担保合同,联动显示担保项下的抵质押物;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else{
			var sGuarantyType = getItemValue(0,getRow(),"GuarantyType");			
			if (sGuarantyType.substring(0,3) == "010") //保证
				OpenPage("/CreditManage/GuarantyManage/ContractGuarantorList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
			else if (sGuarantyType.substring(0,3) == "050") //抵押
				OpenPage("/CreditManage/GuarantyManage/ContractPawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
			else //质押
				OpenPage("/CreditManage/GuarantyManage/ContractImpawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
		}
	}
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