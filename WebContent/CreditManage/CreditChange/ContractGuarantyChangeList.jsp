<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"  %>
<%@ page import="com.amarsoft.dict.als.object.Item"  %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String relativeObjectNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");	
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	if(relativeObjectNo == null) relativeObjectNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";
	
	Item changeCode = CodeCache.getItem("ChangeCode", transCode);
	
	String sTempletNo = "ContractGuarantyChangeList";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("TransSerialNo", transSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","新增","新增担保信息","newRecord()","","","",""},  
			{"true","","Button","详情","查看担保信息详情","viewAndEdit()","","","",""},
			{"true","All","Button","删除","删除担保信息(/取消待删除的担保信息)","deleteRecord()","","","",""},
			{"true","All","Button","引入最高额担保合同","引入新的担保信息","importGuaranty()","","","",""}, 
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/GuarantyManage/ContractGuarantyChangeInfo.jsp", "TransSerialNo=<%=transSerialNo%>&ChangeFlag=020&RightType=<%=CurPage.getParameter("RightType")%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>", "_blank","");
		reloadSelf();
	}

	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"OBJECTNO");	
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var guarantyType=getItemValue(0,getRow(),"GUARANTYTYPE");
		var changeFlag=getItemValue(0,getRow(),"ChangeFlag");
		var contractType=getItemValue(0,getRow(),"CONTRACTTYPE");
		
		var rightType="<%=CurPage.getParameter("RightType")%>";
		if("020"==contractType){
			AsCredit.openFunction("ContractChangeCeilingGCInfo", "TransSerialNo=<%=transSerialNo%>&GCCSerialNo="+serialNo+"&GuarantyType="+guarantyType+"&ContractType="+contractType+"&ChangeFlag="+changeFlag+"&RightType="+rightType+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>", "");
		}else{
			AsControl.OpenView("/BusinessManage/GuarantyManage/ContractGuarantyChangeInfo.jsp",
					"TransSerialNo=<%=transSerialNo%>&GCCSerialNo="+serialNo+"&GuarantyType="+guarantyType+"&ContractType="+contractType+"&ChangeFlag="+changeFlag+"&RightType="+rightType+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_blank","");
		}
		reloadSelf();
	}
		
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var changeFlag = getItemValue(0,getRow(),"ChangeFlag");
		/*
		var contractStatus = getItemValue(0,getRow(),"ContractStatus");
		var contractType = getItemValue(0,getRow(),"ContractType");
		if("010"==changeFlag&&"020"==contractType&&"02"==contractStatus){
			alert("已生效的最高额担保，不允许删除！");
			return;
		}
		else 
		*/
		if ("020"==changeFlag){//一般担保
			if(confirm("您真的想删除该信息吗？")){
				as_do(0, 'reloadSelf()', 'delete');
			}
		}else if("040"==changeFlag){//删除引入的最高额担保合同
			if(!confirm('确实要删除吗?')) return;		
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ContractGuarantyChange", "romoveGuarantyContract", "CRSerialNo="+serialNo+",ChangeFlag="+changeFlag);
			if("success"!=result){
				alert(result);
				return;
			}else{
				reloadSelf();
			}
		}else{
			var alertPara = '确实要删除吗?';
			if("030"==changeFlag){
				alertPara = '确实要恢复吗?'
			}
			if(!confirm(alertPara)) return;		
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ContractGuarantyChange", "updateChangeFalg", "CRSerialNo="+serialNo+",ChangeFlag="+changeFlag);
			if("true"!=result){
				alert(result);
				return;
			}else{
				reloadSelf();
			}
		}
		
	}
	
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"objectno");//--流水号码
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  return ;
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");		
		if (guarantyType == "01020") {//履约保证保险
			var changeFlag = getItemValue(0,getRow(),"ChangeFlag");
			var rightType = "<%=CurPage.getParameter("RightType")%>";
			if("020"!=changeFlag){
				rightType = "ReadOnly";
			}
			AsControl.OpenView("/BusinessManage/GuarantyManage/InsuranceGuaranty.jsp","ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo+"&RightType="+rightType,"rightdown","");
		}
		else if(guarantyType == "01030"){//联贷联保
			AsControl.OpenView("/Blank.jsp", "", "rightdown", "");
		}
		else if(guarantyType.substring(0,3) == "020" || guarantyType.substring(0,3) == "040"){//抵质押担保
			var changeFlag = getItemValue(0,getRow(),"ChangeFlag");
			var contractStatus = getItemValue(0,getRow(),"ContractStatus");
			var contractType = getItemValue(0,getRow(),"ContractType");
			var rightType = "<%=CurPage.getParameter("RightType")%>";
			if("020"!=changeFlag&&"020"==contractType){
				rightType = "ReadOnly";
			}
			AsControl.OpenView("/CreditManage/CreditApply/GCChangeCollateralList.jsp","GCSerialNo="+serialNo+"&VouchType="+guarantyType+"&RightType="+rightType,"rightdown","");
		}else{
			AsControl.OpenView("/Blank.jsp", "", "rightdown", "");
		}
	}
	
	function importGuaranty(){
		var returnValue =AsDialog.SelectGridValue("SelectGuarantyContract2", "<%=CurUser.getOrgID()%>", "SERIALNO@GUARANTYTYPE@GUARANTORNAME@GUARANTYVALUE@GUARANTYCURRENCY@CONTRACTSTATUS", "", false,"","",'1');
		if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
		
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		
		var parameter = returnValue.split("@");
		var checkFlag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ContractGuarantyChange", "checkGuarantyContract", "TransSerialNo=<%=transSerialNo%>,ContractSerialNo=<%=objectNo%>,GCSerialNo="+parameter[0]);
		if(checkFlag == "false"){
			alert("该最高额担保合同已经被该笔业务引用");
			return;
		}
		
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ContractGuarantyChange", "importGuarantyContract", "TransSerialNo=<%=transSerialNo%>,ContractSerialNo=<%=objectNo%>,GCSerialNo="+parameter[0]);
		var resultPara = result.split("@");
		if("success"!=resultPara[0]){
			alert(result);
			return;
		}
		
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		AsControl.OpenView("/BusinessManage/GuarantyManage/ContractGuarantyChangeInfo.jsp",
				"TransSerialNo=<%=transSerialNo%>&GCCSerialNo="+resultPara[1]+"&GuarantyType="+parameter[1]+"&ContractType=020&ChangeFlag=040&RightType="+rightType+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_blank","");
		
		reloadSelf();
		//AsCredit.openFunction("CeilingGCInfo", "GCSerialNo="+parameter[0]+"&gStatus="+parameter[5]+"&ObjectType=&ObjectNo=&Flag=Add&ChangeFlag=&ParentTransSerialNo=", "");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
