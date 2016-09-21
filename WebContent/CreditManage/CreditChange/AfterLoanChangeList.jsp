<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transStatus = CurPage.getParameter("TransStatus");
	String applyType = CurPage.getParameter("ApplyType");
	ASObjectModel doTemp = new ASObjectModel("AfterLoanChangeList");	
	
	doTemp.appendJboWhere(" and AT.TransStatus in('"+transStatus.replaceAll(",", "','")+"')");
	doTemp.setJboOrder(" AT.INPUTTIME");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","cancel()","","","","btn_icon_delete",""},
			{"true","All","Button","�ύ","�ύ","submit();","","","","",""},
			{"false","","Button","�ջ�","�ջ�","takeBack();","","","","",""},
		};
	if(!"0".equals(transStatus)){
		sButtons[4][0]="true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var userID = "<%=CurUser.getUserID()%>";
		var orgID = "<%=CurUser.getOrgID()%>";	
		var sStyle = "dialogWidth:700px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no";
		
		sReturn = AsDialog.SelectGridValue('SelectChangeContract',orgID,'serialNo@customerId','','',sStyle,'','1');
    	if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_CLEAR_") return;
    	else{
    		var serialNo = sReturn.split("@")[0];
    		var returnValue = AsControl.RunASMethod("BusinessManage","InsertTransInfo",serialNo+","+userID+","+orgID);
    		if(typeof(returnValue) == "undefined" || returnValue.length == 0)  return;
	    	AsCredit.openFunction("PostLoanChangeTab","serialNo="+serialNo+"&transSerialNo="+returnValue);
	    	reloadSelf();
    	}
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'RELATIVEOBJECTNO');
		 var transSerialNo = getItemValue(0,getRow(0),'SERIALNO');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		 }
		 AsCredit.openFunction("PostLoanChangeTab","serialNo="+serialNo+"&transSerialNo="+transSerialNo);
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
		if( returnValue.split("@")[0] == "true" ){
			var returnValue1 = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","presumbit","TransactionSerialNo="+transSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,ApplyType=<%=applyType%>");
			
			var flag = returnValue1.split("@")[0];
			var functionID = returnValue1.split("@")[1];
			var flowSerialNo = returnValue1.split("@")[2];
			var taskSerialNo = returnValue1.split("@")[3];
			var phaseNo = returnValue1.split("@")[4];
			var msg = returnValue1.split("@")[5];
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") {
				return;
			}
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
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
