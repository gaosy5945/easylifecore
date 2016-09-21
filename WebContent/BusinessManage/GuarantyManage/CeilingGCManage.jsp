 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "最高额担保合同登记"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String contractType = CurPage.getParameter("ContractType");
	if(contractType == null) contractType = "";
	String contractStatus = CurPage.getParameter("ContractStatus");
	if(contractStatus == null) contractStatus = "";
	String sRightType = CurPage.getParameter("sRightType");
	if(sRightType == null) sRightType = "";
	String openType = CurPage.getParameter("OpenType");
	if(openType == null) openType = "1";//1登记，2查询
	
	String templateNo = "CeilingGCManage";//登记
	if(openType.equals("2")){
		templateNo = "CeilingGCManage1";//查询
	}
	
	ASObjectModel doTemp = new ASObjectModel(templateNo);
	if(!contractStatus.equals("")){
		doTemp.appendJboWhere(" and ContractStatus = '"+contractStatus+"'");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ContractType", contractType);
	
	if(openType.equals("1")){//最高额登记
		dwTemp.setParameter("InputUserID", CurUser.getUserID());
		dwTemp.genHTMLObjectWindow(contractType+","+CurUser.getUserID());
	}
	else{//最高额查询
		dwTemp.setParameter("OrgID", CurUser.getOrgID());
		dwTemp.genHTMLObjectWindow(contractType+","+CurUser.getOrgID());
	}
	
	String sButtons[][] = {
			{"true","All","Button","登记最高额担保合同","登记最高额担保合同","newRecord()","","","",""},  
			{"true","","Button","详情","查看担保信息详情","viewAndEdit()","","","",""},
			{"true","All","Button","取消担保合同","取消担保合同","deleteRecord()","","","",""},
			{"false","","Button","担保客户详情","查看担保相关的担保客户详情","viewCustomerInfo()","","","",""}, 
			{"false","","Button","被担保的贷款信息","被担保的贷款信息","viewBusiness()","","","",""}, 
			{"false","All","Button","担保合同余额","担保合同余额","gcBalance()","","","",""},
			{"false","All","Button","失效","失效最高额担保","inValidate()","","","",""},
			{"true","All","Button","电子合同","最高额担保电子合同","create()","","","",""}
	};
	if(contractStatus.equals("02") || contractStatus.equals("03")){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		//sButtons[5][0] = "true";
		sButtons[7][0] = "false";
	}
	if("03".equals(contractStatus)){
		sButtons[5][0] = "false";
	}
	if(sRightType.equals("ReadOnly") && "02".equals(contractStatus)){
		sButtons[6][0] = "true";
	}
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function newRecord(){
		AsControl.PopComp("/BusinessManage/GuarantyManage/CeilingGCInfo.jsp", "ContractType=020", "");
		reloadSelf();
	}
	function create(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsControl.PopView("/CreditManage/CreditContract/EdocContractList.jsp", "ObjectNo="+serialNo+"&ObjectType=jbo.guaranty.GUARANTY_CONTRACT");
	}
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var guarantorID=getItemValue(0,getRow(),"GuarantorID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			guarantorID = "";
		}
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		AsCredit.openFunction("CeilingGCTab", "SerialNo="+serialNo+"&GuarantyType="+guarantyType+"&GuarantorID="+guarantorID+"&RightType=<%=sRightType%>");
		reloadSelf();
	}

	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  return ;
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");		
		if (guarantyType == "01020") {//履约保证保险
			AsControl.OpenPage("/BusinessManage/GuarantyManage/InsuranceGuaranty.jsp","ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo,"rightdown","");
			return ;
		}
		else if(guarantyType == "01030"){//联贷联保
			AsControl.OpenPage("/Blank.jsp", "", "rightdown", "");
			return;
		}
		else if(guarantyType.substring(0,3) == "020" || guarantyType.substring(0,3) == "040"){//抵质押担保
			AsControl.OpenPage("/CreditManage/CreditApply/CollateralList.jsp","GCSerialNo="+serialNo+"&VouchType="+guarantyType+"&Mode=<%=sRightType%>","rightdown","");
		}
		else{
			AsControl.OpenPage("/CreditManage/CreditApply/GuarantyCLRInfo.jsp", "ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo+"&RightType=<%=sRightType%>", "rightdown", "");
		}
	}

	function viewCustomerInfo(){
		var sCustomerID = getItemValue(0,getRow(),"GuarantorID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0){
			alert(getBusinessMessage('413'));//系统中不存在担保人的客户基本信息，不能查看！
			return ;		
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.GetCustInfoFunction", "getFunction", "CustomerID="+sCustomerID);
		returnValue = returnValue.split("@");
		if(returnValue[0] == "false"){
			alert("缺乏此担保人必要信息！");
			return;
		}
			
		AsCredit.openFunction(returnValue[1],"CustomerID="+sCustomerID,"");
	}
	
	function viewBusiness(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  return ;
		AsControl.PopComp("/BusinessManage/GuarantyManage/CeilingGCRelaBusiness.jsp", "SerialNo="+serialNo, "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	function gcBalance(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var balance = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CeilingGCAction", "getBalance", "SerialNo="+serialNo);
		alert("担保合同余额 "+balance+" 元");
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(!confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			return ;
		}
		var contractStatus = getItemValue(0,getRow(),"ContractStatus");
		if(contractStatus == "02"){
			alert("该最高额担保已生效！");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "isCeilingGCInUse", "GCSerialNo="+serialNo);
		if(returnValue == "true"){
			alert("该最高额担保合同正在被使用！");
			return;
		}
		as_delete('0');
	}
	
	function inValidate(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(!confirm("确定要失效该笔最高额担保合同吗？")){
			return ;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "isCeilingGCInUse", "GCSerialNo="+serialNo);
		if(returnValue == "true"){
			alert("该最高额担保合同项下有未结清业务，不能失效！");
			return;
		}
		if(returnValue == "false"){//失效操作
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.CeilingGCAction", "inValidateContract", "SerialNo="+serialNo);
			if(sReturn == "true"){
				alert("失效完成！");
				self.reloadSelf();
			}
			else{
				alert("失效失败！");
			}
		}
	}
	
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 