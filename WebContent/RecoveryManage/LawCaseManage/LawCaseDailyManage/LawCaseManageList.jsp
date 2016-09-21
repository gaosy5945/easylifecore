<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//�������
	String sContext = CurOrg.getOrgID() + "," + CurUser.getUserID();
	String sWhereClause = ""; //Where����
	
	//��ò���	��������׶Σ�����ǰ010��������020��ȡ������030	
	String sItemID =  (String)CurPage.getParameter("ItemID");
	if(sItemID == null) sItemID="";
	//�����׶�	
	String sCasePhase = sItemID;	

	ASObjectModel doTemp = new ASObjectModel("LawCaseManageList");
	
	//����ǰ �б���Ϣ
	String sRitghtType = "";
	if("010".equals(sItemID)){
			sWhereClause = " and CasePhase='"+sCasePhase+"'";	
	}else if("030".equals(sItemID)){
			sWhereClause = " and CasePhase='110'";	
			doTemp.setVisible("CaseStatusName", false);
			sRitghtType = "&RightType=ReadOnly";
	}else {
			sWhereClause = " and CasePhase not in ('010','110')";	
	}
	//doTemp.setJboWhere("MANAGEORGID = '"+ CurOrg.getOrgID()+"' AND MANAGEUSERID = '"+CurUser.getUserID()+"'"+ sWhereClause);
	String role = "PLBS0052";
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.ManageOrgID) " + sWhereClause);
	}else{
		doTemp.appendJboWhere(" and O.ManageUserID='"+CurUser.getUserID()+"' "+ sWhereClause);
	}
	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	 //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow( "");

	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()","","","",""},
			{"true","","Button","��������","�鿴/�޸İ�������","viewAndEdit()","","","",""},
			{"true","","Button","�����Ǽ�","ת��ת�������Ͻ׶�","doPigeonhole()","","","",""},
			{"true","","Button","ת���½׶�","ת���½׶�","my_NextPhase()","","","",""},
			{"true","","Button","ȡ������","ȡ��ת�������ս᰸��","my_CancelPigeonhole()","","","",""},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
			{"false","","Button","�ָ�����","ת�������ս᰸��","recoverCancelPigeon()","","","",""},
			{"true","","Button","�鿴ȡ����������","�鿴ȡ����������","viewCancelPigeon()", "", "", "", "" } };

	//���Ϊ��ǰ���������Ӧ�б���ʾ��ת���½׶Ρ��ָ����ϡ��鿴ȡ���������� �Ȱ�ť
	if (sCasePhase.equals("010")) {
			sButtons[3][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
	}

	//���Ϊ�����ϣ����Ӧ�б���ʾ��������������ɾ�����ָ����ϡ��鿴ȡ����������  �Ȱ�ť
	if (sCasePhase.equals("020")) {
			sButtons[0][0] = "false";
			sButtons[2][0] = "false";
			//sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
	}

	//���Ϊȡ�� �����Ӧ�б���ʾ���������顢�ָ����ϡ��鿴ȡ���������� �Ȱ�ť
	if (sCasePhase.equals("030")) {
			sButtons[0][0] = "false";
			sButtons[2][0] = "false";
			sButtons[3][0] = "false";
			sButtons[4][0] = "false";
			sButtons[5][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{				
		//���ѡ��İ�������
		var sLawCaseType = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sLawCaseType) == "undefined" && sLawCaseType.length == 0 && sLawCaseType == "" || sLawCaseType == "null" || sLawCaseType == "_CANCLE_")
		{	
		} else{
			//��ȡ��ˮ��
			var sTableName = "LAWCASE_INFO";//����
			var sColumnName = "SerialNo";//�ֶ���
			var sPrefix = "";//ǰ׺
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);		
			//var sReturn=PopPageAjax("/RecoveryManage/LawCaseManage/LawCaseDailyManage/AddLawCaseActionAjax.jsp?SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			//if(sReturn=="true"){
				var sFunctionID="";
				if(sLawCaseType == "01" ){
					sFunctionID = "CaseInfoList1";
				}else{
					sFunctionID = "CaseInfoList2";
				}
				AsCredit.openFunction(sFunctionID, "SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType);
			//}else{
			//	alert("����δ�ɹ���");
			//}
		}	
		reloadSelf();	
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			var sReturnFlag="";
			//sReturnFlag = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/deleteLawCaseAction.jsp?SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType ,"","");
			
			sReturnFlag = RunMethod("BusinessManage","DeleteLawCaseInfo", sSerialNo);
			if(typeof(sReturnFlag)!="undefined" &&(sReturnFlag=="1" || "1".equals(sReturnFlag))){
				alert("ɾ���ɹ���");
			}
		}
		//ɾ��������ɾ��������Ϣ
	    //dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(LawcaseInfo,#SerialNo,DeleteBusiness)");
		
		reloadSelf();
	}
	
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");
		var inputUserID=getItemValue(0,getRow(),"InputUserID");
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		if(inputUserID!="<%=CurUser.getUserID()%>"||"030"=="<%=sItemID%>"){
			rightType = "ReadOnly";
		}
		var sCasePhase = "<%=sCasePhase%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			var sFunctionID="";
			if(sLawCaseType == "01" ){
				sFunctionID = "CaseInfoList1";
			}else{
				sFunctionID = "CaseInfoList2";
			}
			
			
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType+"&RightType="+rightType);	
			reloadSelf();	
		}
	}


</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	
	/*~[Describe=ת���½׶�;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_NextPhase()
	{		
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			//���ѡ��׶�
			var sLawCasePhase = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCasePhaseDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sLawCasePhase) != "undefined" && sLawCasePhase.length != 0 && sLawCasePhase != '')
			{			
				if(sLawCasePhase == '<%=sCasePhase%>')
				{
					alert(getBusinessMessage("779"));  //ת��׶��뵱ǰ�׶���ͬ��
					return;
				}else if(confirm(getBusinessMessage("777"))) //������뽫�ð���ת���½׶���
				{
					sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@CasePhase@"+sLawCasePhase+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
					if(sReturnValue == "TRUE")
					{
						alert(getBusinessMessage("772"));//ת���½׶γɹ���
						reloadSelf();
					}else
					{
						alert(getBusinessMessage("773")); //ת���½׶�ʧ�ܣ�
						return;
					}						
				}
			}
	    }    
	}
	
	/*~[Describe=�����Ǽ�;InputParam=��;OutPutParam=SerialNo;]~*/	
	function doPigeonhole(sCasePhase){
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
				var sReturnValue="";
				var sReturnValue1="";
				var sTableName = "LAWCASE_BOOK";//����
				var sColumnName = "SerialNo";//�ֶ���
				var sPrefix = "";//ǰ׺
				//��ȡ��ˮ��
				var sSerialNo2 = getSerialNo(sTableName,sColumnName,sPrefix);
				//����һ������̨����Ϣ
				 sReturnValue1 = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseRegistrationInfo.jsp?ObjectNo="+sSerialNo+"&LawCaseType="+sLawCaseType+"&BookType=030&SerialNo="+sSerialNo2+"","","");
				if(sReturnValue1=="TRUE" || "TRUE".equals(sReturnValue1))
				{
					alert("�����Ǽǳɹ���");//�����Ǽǳɹ�
					reloadSelf();
				}else
				{
					alert("�����Ǽ�ʧ�ܣ�"); //�����Ǽ�ʧ�ܣ�
					return;
				}			
	    }
	}
			
	/*~[Describe=ȡ��������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_CancelPigeonhole()
	{		
		//��ð�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm("������뽫������ȡ����")) //������뽫������ȡ����
			{				
				var sReturnValue1 = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseReasonsInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=01","","resizable=yes;dialogWidth=50;dialogHeight=20;center:yes;status:no;statusbar:no");
				if(sReturnValue1 == "TRUE")
				{
					var sUpdateDate="<%=StringFunction.getToday()%>";
					sRetrunValue1 =  RunMethod("PublicMethod","UpdateColValue","String@UpdateDate@"+sUpdateDate+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				}
				if(sReturnValue1 == "TRUE")
				{
					alert("ȡ�����ϳɹ���");//�鵵�ɹ���
					reloadSelf();
				}else
				{
					alert("ȡ������ʧ��");//�鵵ʧ�ܣ�
					return;
				}
			}
	    }   
	}
	
	/*~[Describe=�ָ�������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function recoverCancelPigeon()
	{		
		//��ð�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm("������뽫�����ϻָ���")) //������뽫�����ϻָ���
			{				
				var sReturnValue1 = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseReasonsInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=02","","resizable=yes;dialogWidth=50;dialogHeight=20;center:yes;status:no;statusbar:no");
				if(sReturnValue1 == "TRUE")
				{
					var sUpdateDate="<%=StringFunction.getToday()%>";
					sRetrunValue1 =  RunMethod("PublicMethod","UpdateColValue","String@UpdateDate@"+sUpdateDate+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
					if(sReturnValue1 == "TRUE"){
						sRetrunValue1 =  RunMethod("PublicMethod","DeleteLawCaseReason",""+sSerialNo+",LAWCASE_BOOK");
					}
				}
				if(sReturnValue1 == "TRUE")
				{
					alert("�ָ�ȡ�����ϳɹ���");//
					reloadSelf();
				}else
				{
					alert("�ָ�ȡ������ʧ��");//
					return;
				}
			}
	    }   
	}
	/*~[Describe=�鿴ȡ��������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewCancelPigeon(){
		//��ð�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturnValue1 = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseReasonsInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=03","","resizable=yes;dialogWidth=50;dialogHeight=20;center:yes;status:no;statusbar:no");
	    }  	
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
