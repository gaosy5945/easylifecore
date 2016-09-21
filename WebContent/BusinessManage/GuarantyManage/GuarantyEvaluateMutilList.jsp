<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	String PG_TITLE = "����ѺƷ����"; 

	String applyStatus = CurPage.getParameter("ApplyStatus");if(applyStatus == null)applyStatus = "";
	String approveStatus = CurPage.getParameter("ApproveStatus");if(approveStatus == null) approveStatus = "";
	String approveFlag = CurPage.getParameter("ApproveFlag");if(approveFlag == null) approveFlag = "";
	
	ASObjectModel doTemp = new ASObjectModel("GuarantyEvaluateMutilList");
	String sWhereSql =  " and exists (select OB.belongorgid from jbo.sys.ORG_BELONG OB where OB.orgid = '"+CurOrg.getOrgID()+"' and OB.belongorgid = O.EVALUATEORGID)";
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	
	dwTemp.setParameter("ApplyStatus", applyStatus);
	dwTemp.setParameter("ApproveStatus", approveStatus);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","�����ֵ","�����ֵ","newBtch()","","","",""},
			{"true","All","Button","��ֵ����","��ֵ����","dealBtch()","","","",""},
			{"true","All","Button","�鿴��ֵ","�鿴��ֵ","viewBtch()","","","",""},
			{"true","All","Button","ȡ��","ȡ��","cancel()","","","",""},
			{"true","All","Button","�˻�","�˻�","cancel()","","","",""},
			{"true","All","Button","ǩ�����","ǩ�����","signOpinion()","","","",""},
			{"true","All","Button","�鿴���","�鿴���","viewSignOpinion()","","","",""},
			{"true","All","Button","�ύ","�ύ","smt()","","","",""},
	};
	
	if("1".equals(applyStatus) && "1".equals(approveStatus)){
		sButtons[0][0] = "true";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
		sButtons[3][0] = "true";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";
		sButtons[7][0] = "true";
	} else if("2".equals(applyStatus) && "1".equals(approveStatus) && "1".equals(approveFlag)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "true";
		sButtons[5][0] = "true";
		sButtons[6][0] = "true";
		sButtons[7][0] = "true";
	} else {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "true";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "true";
		sButtons[7][0] = "false";
	} 
	
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	function newBtch(){
		var cmisbtchApplyno = AsControl.PopComp("/BusinessManage/GuarantyManage/GuarantyEvaluateMutilInfo.jsp", "SerialNo=", "", "");
		
		reloadSelf();
	} 
	
	function dealBtch(){
		var cmisbtchApplyno = getItemValue(0,getRow(),"CMISBTCHAPPLYNO");
		
		var pstnType = "1";
		if("<%=applyStatus%>"=="2"){
			pstnType = "2";
		}
		if(typeof(cmisbtchApplyno) == "undefined" || cmisbtchApplyno.length == 0){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+cmisbtchApplyno+"&pstnType="+pstnType+"&viewMode=0&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");
		reloadSelf();
	}
	
	/*~[Describe=�鿴ѺƷ��ֵ����;InputParam=��;OutPutParam=��;]~*/
	function viewBtch(){
		var cmisbtchApplyno = getItemValue(0,getRow(),"CMISBTCHAPPLYNO");
		var pstnType = "1";
		if("<%=applyStatus%>"=="2" || "<%=approveStatus%>"=="2"){
			pstnType = "2";
		}
		if(typeof(cmisbtchApplyno) == "undefined" || cmisbtchApplyno.length == 0){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+cmisbtchApplyno+"&pstnType="+pstnType+"&viewMode=1&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");
		reloadSelf();
	}
	
	function cancel(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//�����
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"backMutilEva","SerialNo="+serialNo+",ApplyStatus=<%=applyStatus%>,ApproveStatus=<%=approveStatus%>");
		
		alert(sReturn);
		reloadSelf();
	}

	function signOpinion(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/MutilOpinionInfo.jsp", "SerialNo="+serialNo, "", "");
	}
	
	function viewSignOpinion(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		// �鿴ǩ�����
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"getOpinion","SerialNo="+serialNo);
		if (sReturn == "true") {
			alert("��˸ڻ�δǩ�������");
			return; 
		} 
		AsControl.PopComp("/BusinessManage/GuarantyManage/MutilOpinionInfo.jsp", "SerialNo="+serialNo+"&RightType=ReadOnly", "", "");
	}
	
	function smt(){
		var cmisApplyNo = getItemValue(0,getRow(),"CMISBTCHAPPLYNO");//�����
		var EstDestType = "3";//����Ŀ������  ��ǰ������������ϸ��������١�����ǰ����
		var EstMthType = getItemValue(0,getRow(),"EvaluateModel");//������������
		var PrdNo = "1";//�׶�����
		if("<%=applyStatus%>"=="2" || "<%=approveStatus%>"=="2"){
			PrdNo = "2";
		}
		var InrExtEstType = "1";//������
		if(typeof(cmisApplyNo) == "undefined" || cmisApplyNo.length == 0){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"checkEvaInfo","CMISApplyNo="+cmisApplyNo+",EstDestType="+EstDestType+",EstMthType="+EstMthType
				+",PrdNo="+PrdNo+",InrExtEstType="+InrExtEstType);
		sReturnValue = sReturn.split("@");
		if (sReturnValue[1] == "000000000000") {
			if(sReturnValue[0] != "1") {
				alert("������¼���ֵ������Ϣ�����ύ��");
				return; 
			} 
		} else if(sReturnValue[1] == "021200000002") {
			alert("����м�ֵ���������ύ��");
			return; 
		} 
		
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		// ��ȡǩ�����
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
					"getOpinion","SerialNo="+serialNo);
		// ���ǩ�����
		if("<%=applyStatus%>"=="2"){
			if (sReturn == "true") {
				alert("����ǩ��������ύ��");
				return; 
			} 
		}
		
		if(sReturn == "01") {
			// ��ȡ��ֵ��Ϣ�����¹�ֵ��
			if("<%=applyStatus%>"=="2"){
				var getEvaValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
						"getEvaValue","CMISApplyNo="+cmisApplyNo+",FlowStatus=1");
			}
		}
		// �ύ
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"updateMutilEva","SerialNo="+serialNo+",ApplyStatus=<%=applyStatus%>,ApproveStatus=<%=approveStatus%>,OpinionFlag="+sReturn);
		alert(sReturn);
		
		reloadSelf();
	}
	
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
