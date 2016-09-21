 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String orgID = CurUser.getOrgID();
	String objectType =  CurComp.getParameter("ObjectType");
	String objectNo = CurComp.getParameter("ObjectNo");
	//String contractType = CurComp.getParameter("ContractType");
	String changeFlag = CurPage.getParameter("ChangeFlag"); //�����ʾ
	String transSerialNo = CurPage.getParameter("TransSerialNo"); //����ܽ�����ˮ��	
	String sRightType = CurPage.getParameter("RightType"); //modify by liuzq 

	//����ֵת��Ϊ���ַ���
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
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "0";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
	dwTemp.genHTMLObjectWindow(objectNo+",jbo.guaranty.GUARANTY_CONTRACT");
	
	String sButtons[][] = {
			{"true","All","Button","����","����������Ϣ","newRecord()","","","",""},  
			{"true","All","Button","������߶����ͬ","�����µĵ�����Ϣ","importGuaranty()","","","",""},  
			{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()","","","",""},
			{"true","All","Button","ɾ��","ɾ��������Ϣ","deleteRecord()","","","",""},
			{"false","All","Button","ɾ��","ɾ�����������Ϣ","deletechange()","","","",""},
			{"false","","Button","�Զ����������Ա����","�Զ����������Ա����","autoAddGuarantyContract()","","","",""}, 
			{"false","All","Button","����","����","saveRecord()","","","",""},
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(!confirm('ȷʵҪɾ����?')) return;
		var objectNo = "<%=objectNo%>";
		var objectType = "jbo.app.BUSINESS_CONTRACT";
		var documentObjectNo = getItemValue(0,getRow(),"SerialNo");//ȡ����������ˮ��
		var parentTransSerialNo = "<%=transSerialNo%>";
		var documentObjectType ="jbo.guaranty.GUARANTY_CONTRACT";
			
		var gcChangeFlag = getItemValue(0,getRow(),"ChangeFlag");
		if(gcChangeFlag == "ԭ��¼"){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003002,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=Y";
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
			reloadSelf();
		}else if(gcChangeFlag.indexOf("����") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003001,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);	
			reloadSelf();
		}else if(gcChangeFlag.indexOf("����") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003002,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);
			reloadSelf();
		}else if(gcChangeFlag.indexOf("����") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003006,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);	
			reloadSelf();
		}else if(gcChangeFlag.indexOf("�޸�") >=0){
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var contractType = getItemValue(0,getRow(),"ContractType");
		
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var gcChangeFlag = getItemValue(0,getRow(),"ChangeFlag");
		//modify by liuzq 20150326 ��������鿴��ͬ��Ϣ--������Ϣ���������ʱ��δ���ε����޸Ĳ������籣�棩
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
				if(gcChangeFlag.indexOf("ԭ��¼") >=0){
					if(confirm('ȷ���Ƿ��޸ĵ�ǰ������ͬ��Ϣ!')) {
					
						var returnValue =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeGuarantyInfo", "copyGuaratyInfo", "GcSerialNo="+serialNo+",ContractSerialNo=<%=objectNo%>");
						AsCredit.openFunction("NormalGCInfo", "ChangeFlag=Y&GCSerialNo="+serialNo+"&SerialNo="+returnValue+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
					}else
						AsCredit.openFunction("NormalGCInfo", "ChangeFlag=Y&GCSerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&RightType=ReadOnly&GuarantyType="+guarantyType+"&RightType="+sRightType, "");
				}else if(gcChangeFlag.indexOf("�޸�") >=0 )
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
			alert("����߶����ͬ�Ѿ����ñ�ҵ������");
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
		if (guarantyType == "01020") {//��Լ��֤����
			AsControl.OpenPage("/BusinessManage/GuarantyManage/InsuranceGuaranty.jsp","ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo,"rightdown","");
			return ;
		}
		else if(guarantyType == "01030"){//��������
			AsControl.OpenPage("/Blank.jsp", "", "rightdown", "");
			return;
		}
		else if(guarantyType.substring(0,3) == "020" || guarantyType.substring(0,3) == "040"){//����Ѻ����
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var contractStatus = getItemValue(0,getRow(),"ContractStatus");
		var contractType = getItemValue(0,getRow(),"ContractType");
		var arSerialNo = getItemValue(0,getRow(),"ARSerialNo");
		
		if("020"==contractType){//��߶��
			if("02"==contractStatus){//����Ч
				if(!confirm(getHtmlMessage('2'))){//�������ɾ������Ϣ��
					return ;
				}
				var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "deleteGCRelative", "SerialNo="+arSerialNo);
				if("true"==returnValue){
					alert("ɾ���ɹ���");
					selfRefresh();
				}else{
					alert("ɾ��ʧ�ܣ�ʧ��ԭ��"+returnValue);
				}
			}
			else{//δ��Ч,�ж�������������ռ��
				var isinuse = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "isCeilingGCInUse1", "GCSerialNo="+serialNo+",ApplySerialNo=<%=objectNo%>");
				if(isinuse == "true"){//����ʹ��
					if(!confirm(getHtmlMessage('2'))){//�������ɾ������Ϣ��
						return ;
					}
					var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "deleteGCRelative", "SerialNo="+arSerialNo);
					if("true"==returnValue){
						alert("ɾ���ɹ���");
						selfRefresh();
					}else{
						alert("ɾ��ʧ�ܣ�ʧ��ԭ��"+returnValue);
					}
				}
				else{//ֻ�иñ�ҵ��ʹ��
					as_doAction(0,'selfRefresh()','delete');
				}
			}
		}
		else{//һ�㵣��
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
 