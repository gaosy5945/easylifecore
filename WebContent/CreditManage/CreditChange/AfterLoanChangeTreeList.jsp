<%@page import="java.awt.datatransfer.SystemFlavorMap"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"  %>
<%@ page import="com.amarsoft.dict.als.object.Item"  %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transStatus = CurPage.getParameter("TransStatus");
	String transCode = CurPage.getParameter("TransCode");
	String applyType = CurPage.getParameter("ApplyType");
	
	Item changeCode = CodeCache.getItem("ChangeCode", transCode);
	String selectCode = changeCode.getAttribute2();
	if(selectCode==null)selectCode="";
	String objectType = changeCode.getAttribute5();
	String tempFlow = changeCode.getAttribute4();
	
	String sTempletNo = "AfterLoanChangeListToTree";
	if("jbo.app.BUSINESS_CONTRACT".equals(objectType)){
		sTempletNo = "AfterLoanChangeListToTree_BC";
	}else if("jbo.app.BUSINESS_DUEBILL".equals(objectType)){
		sTempletNo = "AfterLoanChangeListToTree_BD";
	}else if("jbo.guaranty.GUARANTY_CONTRACT".equals(objectType)){
		sTempletNo = "AfterLoanChangeListToTree_GC";
	}else if("jbo.cl.CL_INFO".equals(objectType)){
		sTempletNo = "AfterLoanChangeListToTree_CL";
	}
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	
	
	doTemp.appendJboWhere(" and O.TransStatus in('"+transStatus.replaceAll(",", "','")+"')");
	doTemp.setJboOrder(" O.INPUTTIME desc ");
	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("TransCode", transCode);
	dwTemp.genHTMLObjectWindow("");

	
	boolean flowFlag = true;
	if(tempFlow==null||tempFlow.length()==0){
		flowFlag = false;
	}
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"false","All","Button","�����ͣ","�����ͣ","addApply()","","","","",""},
			{"false","All","Button","��Ȼָ�","��Ȼָ�","recoverApply()","","","","",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","cancel()","","","","btn_icon_delete",""},
			{"true","All","Button","�ύ","�ύ","submit();","","","","",""},
			{"false","","Button","�ջ�","�ջ�","takeBack();","","","","",""},
			{"0010".equals(transCode)&&!"0".equals(transStatus)?"true":"false","","Button","��ӡ��ǰ����֪ͨ��","��ӡ��ǰ����֪ͨ��","print()","","","","",""},
			{"0020".equals(transCode)&&!"0".equals(transStatus)?"true":"false","","Button","��ӡ����������֪ͨ��","��ӡ����������֪ͨ��","print()","","","","",""},
			{"0155".equals(transCode)&&!"0".equals(transStatus)?"true":"false","","Button","��ӡר���ʽ�һ����ת���ý�֪ͨ��","ר���ʽ�һ����ת���ý�֪ͨ��","printZHChangeToBY()","","","","",""},
		};
	if(!"0".equals(transStatus)&&flowFlag){
		sButtons[6][0]="true";
	}
	
	if("017001".equals(transCode)||"017002".equals(transCode)){
		sButtons[0][0]="false";
		sButtons[1][0]="true";
		sButtons[2][0]="true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function add(){
		var userID = "<%=CurUser.getUserID()%>";
		var orgID = "<%=CurUser.getOrgID()%>";	
		var sStyle = "dialogWidth:700px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no";
		var selectCode = "SelectChangeContract";
		if("<%=selectCode%>".length>0){
			selectCode="<%=selectCode%>";
		}
		
		sReturn = AsDialog.SelectGridValue(selectCode,orgID,'serialNo@customerId','','',sStyle,'','1');
    	if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_CLEAR_") return;
    	else{
    		var serialNo = sReturn.split("@")[0];
    		
    		var checkResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterLoanTransAction",
    				"checkTransaction", "ObjectNo="+serialNo+",ObjectType=<%=objectType%>,TransCode=<%=transCode%>");
    		if("true"!=checkResult){
    			alert("��ǰ����{"+serialNo+"}����������;���룬�ݲ���ִ���������������ף�");
    			return;
    		}
    		
    		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterLoanTransAction",
    				"createTransaction", "ObjectNo="+serialNo+",ObjectType=<%=objectType%>,TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>");
    		if(typeof(returnValue) == "undefined" || returnValue.length == 0)  return;
    		
    		var functionID = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","getAfterLoanApplyFunctionID","TransactionSerialNo="+returnValue);
    		AsCredit.openFunction(functionID,"TransSerialNo="+returnValue+"&TransCode=<%=transCode%>");//PostLoanChangeTabNew
   		 	reloadSelf();
    		/* var returnValue = AsControl.RunASMethod("BusinessManage","InsertTransInfo",serialNo+","+userID+","+orgID);
    		if(typeof(returnValue) == "undefined" || returnValue.length == 0)  return;
	    	AsCredit.openFunction("PostLoanChangeTab","serialNo="+serialNo+"&transSerialNo="+returnValue);
	    	reloadSelf(); */
    	}
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'RELATIVEOBJECTNO');
		 var transSerialNo = getItemValue(0,getRow(0),'SERIALNO');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		 }
		 
		 var functionID = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","getAfterLoanApplyFunctionID","TransactionSerialNo="+transSerialNo);
		 AsCredit.openFunction(functionID,"serialNo="+serialNo+"&TransSerialNo="+transSerialNo+"&TransCode=<%=transCode%>");//PostLoanChangeTabNew
		 reloadSelf();
	}
	
	
	function submit(){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(!confirm('ȷʵҪ�ύ��?'))return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","sumbit","TransactionSerialNo="+transSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,ApplyType=<%=applyType%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;
		if(returnValue.split("@")[0] == "true" && returnValue.split("@").length > 2){
			
			var flag = returnValue.split("@")[0];
			var functionID = returnValue.split("@")[1];
			var flowSerialNo = returnValue.split("@")[2];
			var taskSerialNo = returnValue.split("@")[3];
			var phaseNo = returnValue.split("@")[4];
			var msg = returnValue.split("@")[5];
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") {
				return;
			}
		}else if(returnValue.split("@")[0] == "true" && returnValue.split("@").length <= 2)
		{
			alert(returnValue.split("@")[1]);
			if("<%=transCode%>" == "0010"||"<%=transCode%>" == "0020"){
				print();
			}
		}
		else{
			alert(returnValue.split("@")[1]);
		}
		reloadSelf();
	}
	function cancel(){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}		
		if(!confirm('ȷʵҪɾ����?')) return;	
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","delete","TransactionSerialNo="+transSerialNo+",ApplyType=<%=applyType%>");
		alert(returnValue);
		reloadSelf();
	}
	
	function takeBack(){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		var taskSerialNo = getItemValue(0,getRow(0),"CORERETURNSERIALNO");
		var userID = "<%=CurUser.getUserID()%>";
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		if(!confirm("ȷ���ջظ�����")) return;
		//�����ջؽӿ�
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterLoanTakeBack","back","TransSerialNo="+transSerialNo+",TaskSerialNo="+taskSerialNo+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	}
	
	function print(){
		var transSerialNo = getItemValue(0,getRow(),"SerialNo");//ȡ�����ˮ��
		var serialNo = getItemValue(0,getRow(),"RELATIVEOBJECTNO");//ȡ�����ˮ��
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if('<%=transCode%>' == '0010'){
			AsControl.OpenView("/BillPrint/AdvRepay.jsp","SerialNo="+serialNo+"&TransSerialNo="+transSerialNo,"_blank");//���˴�����ǰ����֪ͨ��
		}else {
			AsControl.OpenView("/BillPrint/ThirdPartyAdvRepay.jsp","SerialNo="+serialNo+"&TransSerialNo="+transSerialNo,"_blank");//���˴���������˻���ǰ����֪ͨ��
		}
	}
	function printZHChangeToBY(){
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		AsControl.OpenView("/BillPrint/OnetimeChg.jsp","SerialNo="+serialNo,"_blank");//ר��һ����ת���ý�
	}
	
	function addApply(){
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var selectpara = "SelectCLNSList";
		if("017001"=="<%=transCode%>"){
			selectpara = "SelectCLNSList017001";
		}else{
			selectpara = "SelectCLNSList017002";
		}
		
		var returnValue = AsDialog.SelectGridValue(selectpara, inputOrgID, "SerialNo@Status","", "","","","1");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		returnValue = returnValue.split("@");
		var CLSerialNo = returnValue[0];
		var preStatus = returnValue[1];
		
		var checkresult = CreditLineManage.checkCL(CLSerialNo);
		if("true"!=checkresult){
			alert("��ǰ�������;��δ��Ч�Ķ�ȵ������ף����ɽ��ж����ͣ������");
			return;
		}
		
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterLoanTransAction",
				"createTransaction", "ObjectNo="+CLSerialNo+",ObjectType=<%=objectType%>,TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,PreStatus="+preStatus);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0)  return;
		
		var functionID = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","getAfterLoanApplyFunctionID","TransactionSerialNo="+returnValue);
		AsCredit.openFunction(functionID,"TransSerialNo="+returnValue+"&TransCode=<%=transCode%>");//PostLoanChangeTabNew
		reloadSelf();
	}
	
	function recoverApply(){
		
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var selectpara = "";
		if("017001"=="<%=transCode%>"){
			selectpara = "SelectCLNSList017001-r";
		}else{
			selectpara = "SelectCLNSList017002-r";
		}
		var returnValue = AsDialog.SelectGridValue(selectpara, inputOrgID, "SerialNo@Status","", "","","","1");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		
		returnValue = returnValue.split("@");
		var CLSerialNo = returnValue[0];
		var preStatus = returnValue[1];
		
		var checkresult = CreditLineManage.checkCL(CLSerialNo);
		if("true"!=checkresult){
			alert("��ǰ�������;��δ��Ч�Ķ�ȵ������ף����ɽ��ж�Ȼָ�������");
			return;
		}
		
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterLoanTransAction",
				"createTransaction", "ObjectNo="+CLSerialNo+",ObjectType=<%=objectType%>,TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,PreStatus="+preStatus);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0)  return;
		
		var functionID = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","getAfterLoanApplyFunctionID","TransactionSerialNo="+returnValue);
		AsCredit.openFunction(functionID,"TransSerialNo="+returnValue+"&TransCode=<%=transCode%>");//PostLoanChangeTabNew
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
