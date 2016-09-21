 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "担保信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String orgID = CurUser.getOrgID();
	String objectType =  CurComp.getParameter("ObjectType");
	String objectNo = CurComp.getParameter("ObjectNo");
	//String contractType = CurComp.getParameter("ContractType");
	String changeFlag = CurPage.getParameter("ChangeFlag"); //变更标示
	String transSerialNo = CurPage.getParameter("TransSerialNo"); //变更总交易流水号	
	String sRightType = CurPage.getParameter("RightType"); //modify by liuzq 

	//将空值转化为空字符串
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	if(changeFlag == null) changeFlag = "";
	if(transSerialNo == null) transSerialNo = "";
	if(sRightType == null) sRightType = "";
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("GuarantyContractList",BusinessObject.createBusinessObject(),CurPage);
	
	String jboFrom = doTemp.getJboFrom();
	String jboWhere = doTemp.getJboWhere();
	String[] relativeTables=GuarantyFunctions.getRelativeTable(objectType);
	if(!StringX.isEmpty(relativeTables[0])){
		jboFrom=StringFunction.replace(jboFrom, "jbo.app.APPLY_RELATIVE", relativeTables[0]);
		jboWhere=StringFunction.replace(jboWhere, "APPLYSERIALNO", relativeTables[1]);
	}
	doTemp.setJboFrom(jboFrom);
	doTemp.setJboWhere(jboWhere);
	
	if("Y".equals(changeFlag))
		doTemp.setVisible( "ChangeFlag", true);
	
	if("jbo.app.BUSINESS_CONTRACT".equals(objectType)){
		//doTemp.appendJboWhere(" and R.RelativeType<>'00' ");
		doTemp.setVisible("RelativeType", true);
	}
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
	dwTemp.genHTMLObjectWindow(objectNo+",jbo.guaranty.GUARANTY_CONTRACT");
	
	String sButtons[][] = {
			{"true","All","Button","新增","新增担保信息","newRecord()","","","",""},  
			{"true","All","Button","引入最高额担保合同","引入新的担保信息","importGuaranty()","","","",""},  
			{"true","","Button","详情","查看担保信息详情","viewAndEdit()","","","",""},
			{"true","All","Button","删除","删除担保信息","deleteRecord()","","","",""},
			{"false","All","Button","删除","删除担保变更信息","deletechange()","","","",""},
			{"false","","Button","自动添加联保成员担保","自动添加联保成员担保","autoAddGuarantyContract()","","","",""}, 
			{"false","All","Button","保存","保存","saveRecord()","","","",""},
	};
	if("Y".equals(changeFlag)){
		sButtons[3][0]="false";
		sButtons[4][0]="true";
	}

%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function newRecord(){
		AsControl.PopComp("/CreditManage/CreditApply/GuarantyInfo.jsp", "SerialNo=&ChangeFlag=<%=changeFlag%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&ParentTransSerialNo=<%=transSerialNo%>&DocumentObjectType=jbo.guaranty.GUARANTY_CONTRACT", "");
		selfRefresh();
	}

	function deletechange(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(!confirm('确实要删除吗?')) return;
		var objectNo = "<%=objectNo%>";
		var objectType = "jbo.app.BUSINESS_CONTRACT";
		var documentObjectNo = getItemValue(0,getRow(),"SerialNo");//取新增担保流水号
		var parentTransSerialNo = "<%=transSerialNo%>";
		var documentObjectType ="jbo.guaranty.GUARANTY_CONTRACT";
			
		var gcChangeFlag = getItemValue(0,getRow(),"ChangeFlag");
		if(gcChangeFlag == "原记录"){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003002,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=Y";
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
			reloadSelf();
		}else if(gcChangeFlag.indexOf("新增") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003001,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);	
			reloadSelf();
		}else if(gcChangeFlag.indexOf("减少") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003002,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);
			reloadSelf();
		}else if(gcChangeFlag.indexOf("引入") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003006,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);	
			reloadSelf();
		}else if(gcChangeFlag.indexOf("修改") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003005,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);	
			reloadSelf();
		}
		
	}
	
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");	
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var contractType = getItemValue(0,getRow(),"ContractType");
		
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var gcChangeFlag = getItemValue(0,getRow(),"ChangeFlag");
		//modify by liuzq 20150326 档案管理查看合同信息--担保信息，点击详情时，未屏蔽掉可修改操作（如保存）
		var sRightType = "<%=sRightType%>";
		if(contractType == "020"){
			var gStatus = getItemValue(0,getRow(),"ContractStatus");
			if(gStatus=="02" || gStatus=="01"){
				AsCredit.openFunction("CeilingGCInfo", "GCSerialNo="+serialNo+"&gStatus="+gStatus+"&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Flag=View&ChangeFlag=N&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
			}
			else
				AsCredit.openFunction("CeilingGCInfo", "GCSerialNo="+serialNo+"&gStatus=03&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Flag=View&ChangeFlag=N&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
		}
		else if(contractType == "010"){
			if("<%=changeFlag%>" =="Y"){
				if(gcChangeFlag.indexOf("原记录") >=0){
					if(confirm('确认是否修改当前担保合同信息!')) {
					
						var returnValue =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeGuarantyInfo", "copyGuaratyInfo", "GcSerialNo="+serialNo+",ContractSerialNo=<%=objectNo%>");
						AsCredit.openFunction("NormalGCInfo", "ChangeFlag=Y&GCSerialNo="+serialNo+"&SerialNo="+returnValue+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
					}else
						AsCredit.openFunction("NormalGCInfo", "ChangeFlag=Y&GCSerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&RightType=ReadOnly&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
				}else if(gcChangeFlag.indexOf("修改") >=0 )
					AsCredit.openFunction("NormalGCInfo", "ChangeFlag=Y&GCSerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
				else{
					AsCredit.openFunction("NormalGCInfo", "ChangeFlag=N&SerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
				}
			}else{
				var prjSerialNo = getItemValue(0,getRow(),"ProjectSerialNo");
				if(prjSerialNo.length > 0){
					AsCredit.openFunction("PrjGCInfo", "GCSerialNo="+serialNo+"&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ChangeFlag=N&RightType="+sRightType, "");
				}
				else{
					AsCredit.openFunction("NormalGCInfo", "ChangeFlag=N&SerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+guarantyType+"&RightType="+sRightType+"&ProjectSerialNo=", "");
				}
			}
		}
		else{}
		selfRefresh();
	}
	
	function importGuaranty(){
		var returnValue =AsDialog.SelectGridValue("SelectGuarantyContract2", "<%=orgID%>", "SERIALNO@GUARANTYTYPE@GUARANTORNAME@GUARANTYVALUE@GUARANTYCURRENCY@CONTRACTSTATUS", "", false,"","",'1');
		if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
		
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		var parameter = returnValue.split("@");
		var checkFlag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "checkCeilingGC", "GCSerialNo="+parameter[0]+",ApplySerialNo=<%=objectNo%>");
		if(checkFlag == "false"){
			alert("该最高额担保合同已经被该笔业务引用");
			return;
		}
		AsCredit.openFunction("CeilingGCInfo", "GCSerialNo="+parameter[0]+"&gStatus="+parameter[5]+"&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Flag=Add&ChangeFlag=<%=changeFlag%>&ParentTransSerialNo=<%=transSerialNo%>", "");
		
		AsControl.OpenPage("/BusinessManage/GuarantyManage/GuarantyContractList.jsp", 
				"ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_self");
	}

	 function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var changeFlag = "";
		var prjSerialNo = getItemValue(0,getRow(),"ProjectSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ) {
			AsControl.OpenPage("/Blank.jsp", "", "rightdown", "");
			return;
		}
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
			if("<%=changeFlag%>"=="Y"){
				changeFlag = getItemValue(0,getRow(),"ChangeFlag");
			}
			var contractType = getItemValue(0,getRow(),"ContractType");
			var contractStatus = getItemValue(0,getRow(),"ContractStatus");
			AsControl.OpenPage("/CreditManage/CreditApply/CollateralList.jsp","GCSerialNo="+serialNo+"&ContractType="+contractType+"&CStatus="+contractStatus+"&VouchType="+guarantyType+"&ChangeFlag="+changeFlag+"&TransSerialNo=<%=transSerialNo%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","rightdown","");
		}
		else{
			//AsControl.OpenPage("/CreditManage/CreditApply/GuarantyCLRInfo.jsp", "ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo+"&RightType=ReadOnly", "rightdown", "");
			AsControl.OpenPage("/Blank.jsp", "", "rightdown", "");
		}
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var contractStatus = getItemValue(0,getRow(),"ContractStatus");
		var contractType = getItemValue(0,getRow(),"ContractType");
		var arSerialNo = getItemValue(0,getRow(),"ARSerialNo");
		
		if("020"==contractType){//最高额担保
			if("02"==contractStatus){//已生效
				if(!confirm(getHtmlMessage('2'))){//您真的想删除该信息吗？
					return ;
				}
				var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "deleteGCRelative", "SerialNo="+arSerialNo);
				if("true"==returnValue){
					alert("删除成功！");
					selfRefresh();
				}else{
					alert("删除失败！失败原因："+returnValue);
				}
			}
			else{//未生效,判断有无其他申请占用
				var isinuse = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "isCeilingGCInUse1", "GCSerialNo="+serialNo+",ApplySerialNo=<%=objectNo%>");
				if(isinuse == "true"){//正被使用
					if(!confirm(getHtmlMessage('2'))){//您真的想删除该信息吗？
						return ;
					}
					var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "deleteGCRelative", "SerialNo="+arSerialNo);
					if("true"==returnValue){
						alert("删除成功！");
						selfRefresh();
					}else{
						alert("删除失败！失败原因："+returnValue);
					}
				}
				else{//只有该笔业务使用
					as_doAction(0,'selfRefresh()','delete');
				}
			}
		}
		else{//一般担保
			as_doAction(0,'selfRefresh()','delete');
		}
	}
	
	
	function selfRefresh()
	{
		AsControl.OpenPage("/BusinessManage/GuarantyManage/GuarantyContractList.jsp", 
				"ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_self");
	}
	
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 