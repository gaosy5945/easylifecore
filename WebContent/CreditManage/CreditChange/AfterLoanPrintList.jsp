<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String EdocNo = DataConvert.toString(CurPage.getParameter("EdocNo"));//文件编号
	String FullPathFmt = Sqlca.getString("select FULLPATHFMT from pub_edoc_config where EdocNo = '"+EdocNo+"'").toString();
	String sTempletNo = Sqlca.getString("select LISTTEMPLETNO from pub_edoc_config where EdocNo = '"+EdocNo+"'").toString();
	String ObjectType = Sqlca.getString(new SqlObject("select ad.Jboclass from awe_do_catalog ad where ad.dono = :DONO").setParameter("DONO", sTempletNo));
	String businessDate = com.amarsoft.app.base.util.DateHelper.getBusinessDate();
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	if(("3023".equals(EdocNo))){
		doTemp.setJboFrom("O,jbo.app.BUSINESS_APPROVE bap");
		doTemp.setJboWhere("O.serialno = bap.APPLYSERIALNO");
	}else if("3007".equals(EdocNo)){//第三方还款
		doTemp.appendJboWhere(" and ats.transactioncode = '0020'");
	}else if("3021".equals(EdocNo)){//提前还款
		doTemp.appendJboWhere(" and ats.transactioncode = '0010'");
	}else if("3012".equals(EdocNo)){//专户转备用金
		doTemp.appendJboWhere(" and ats.transactioncode = '0155'");
	}
	if("3024".equals(EdocNo)){
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.InputOrgID) ");
	}else if("3014".equals(EdocNo)){//放款审核书只能上海分行及其下属机构查看
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
		+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.OperateOrgID and exists(select 1 from jbo.sys.ORG_BELONG OB1 "+
		" where OB1.ORGID = '9800' and OB1.BelongOrgID = O.OperateOrgID)) ");
	}else{
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
			+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.OperateOrgID) ");
	}
	doTemp.setJboWhereWhenNoFilter(" and 1=2"); 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "1";
	dwTemp.setParameter("BusinessDate", businessDate);
	dwTemp.genHTMLObjectWindow("");
	

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{!("3022".equals(EdocNo)||"3021".equals(EdocNo)||"3007".equals(EdocNo)||"3001".equals(EdocNo)||"3010".equals(EdocNo))?"true":"false","All","Button","打印","打印","print()","","","","",""},
			{("3022".equals(EdocNo))?"true":"false","All","Button","打印","打印","printBusinessApprove()","","","","",""},
			{("3021".equals(EdocNo)||"3007".equals(EdocNo))?"true":"false","All","Button","打印","打印","AdvRepay()","","","","",""},
			{("3001".equals(EdocNo)||"3010".equals(EdocNo))?"true":"false","All","Button","打印","打印","NDHKPrint()","","","","",""},
			{"true","All","Button","查询打印记录","查询打印记录","searchLog()","","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function print(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.AfterLoanPrintInsertRecord","insertPrintRecord",
				"SerialNo="+serialNo+",ObjectType="+objectType+",EdocNo="+'<%=EdocNo%>'+",UserId="+'<%=CurUser.getUserID()%>'+
				",OrgId="+'<%=CurOrg.getOrgID()%>');  
		AsControl.OpenView('<%=FullPathFmt%>',"SerialNo="+serialNo,"_blank");
	}
	
	function AdvRepay(){
		var serialNo = getItemValue(0,getRow(),"RELATIVEOBJECTNO");
		var transSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		if (typeof(transSerialNo)=="undefined" || transSerialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.AfterLoanPrintInsertRecord","insertPrintRecord",
				"SerialNo="+serialNo+",ObjectType="+objectType+",EdocNo="+'<%=EdocNo%>'+",UserId="+'<%=CurUser.getUserID()%>'+
				",OrgId="+'<%=CurOrg.getOrgID()%>');  
		AsControl.OpenView('<%=FullPathFmt%>',"SerialNo="+serialNo+"&TransSerialNo="+transSerialNo,"_blank");
	}
	
	function NDHKPrint(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		var edocNo = '<%=EdocNo%>';
		var fullPathFmt = '<%=FullPathFmt%>';
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.AfterLoanPrintInsertRecord","insertPrintRecord",
				"SerialNo="+serialNo+",ObjectType="+objectType+",EdocNo="+'<%=EdocNo%>'+",UserId="+'<%=CurUser.getUserID()%>'+
				",OrgId="+'<%=CurOrg.getOrgID()%>');  
		AsControl.PopPage("/CreditManage/CreditChange/NDHKImportDate.jsp","SerialNo="+serialNo+"&EdocNo="+edocNo+"&FullPathFmt="+fullPathFmt,"dialogWidth:25;dialogHeight:18;resizable:yes;scrollbars:no;status:no;help:no","");
	}
	
	function printBusinessApprove(){
		var BusinessType = getItemValue(0,getRow(0),'BUSINESSTYPE');
		var serialNo = getItemValue(0,getRow(0),'SERIALNO');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		if(typeof(BusinessType) == "undefined" || BusinessType.length == 0){
			alert("基础产品为空！");//基础产品不能为空！
			return;
		} 
		var PRODUCTTYPE3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType"
				,"ProductID="+BusinessType);
		
		if(PRODUCTTYPE3 == "01" && BusinessType != "555" && BusinessType != "999"){ 
			AsCredit.openFunction("PrintConsumeLoanApprove","SerialNo="+serialNo);//消费类贷款审批意见表
		}else if(PRODUCTTYPE3 == "02"){
			AsControl.OpenView("/BillPrint/BusinessApprove.jsp","SerialNo="+serialNo,"_blank");//经营类贷款审批意见表
		}else if(BusinessType == "555" || BusinessType == "999"){
			AsControl.OpenView("/BillPrint/ApplyDtl1For555.jsp","SerialNo="+serialNo,"_blank");//个人授信额度贷款审批意见表
		}
	}
	
	function searchLog(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/CreditManage/CreditChange/AfterLoanPrintDetail.jsp","ObjectNo="+serialNo+"&ObjectType="+objectType,"_blank");
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
