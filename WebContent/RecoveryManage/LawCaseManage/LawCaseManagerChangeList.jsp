<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("LawCaseManagerChangeList");
	
	//doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	String role [] = {"PLBS0052"};
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.ManageOrgID) ");
	}else{
		doTemp.appendJboWhere(" and O.ManageUserID='"+CurUser.getUserID()+"' ");
	}
	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.MultiSelect = true; //��ѡ���
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","��������","�鿴������ϸ��Ϣ","viewAndEdit()","","","",""},
			{"true","","Button","���������","//�����������Ϣ","my_ChangeUser()","","","",""},
			{"true","","Button","�鿴�����¼","�鿴�����������ʷ","my_history()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
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
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType+"&RightType=ReadOnly");	
			reloadSelf();	
		}
	}
	
	/*~[Describe=�����������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_ChangeUser()
	{   
		var sSerialNoList = "";		// ��ˮ�� 	�� ��~�ָ�
		var sManagerUserIdList = "";	 //�ֹ�����id 	�� ��~�ָ�
		var sManagerUserNameList = "";	 //�ֹ��������� 	�� ��~�ָ�
		var sManagerOrgIdList = "";		 //�ֹ������id 	�� ��~�ָ�
		var sManagerOrgNameList = "";	 //�ֹ���������� 	�� ��~�ָ�
		
		var sSerialNo = "";		// ��ˮ�� 
		var sManagerUserId = "";	 //�ֹ�����id 
		var sManagerUserName = "";	 //�ֹ��������� 
		var sManagerOrgId = "";		 //�ֹ������id 
		var sManagerOrgName = "";	 //�ֹ���������� 
		

		var sManageUrl = "/RecoveryManage/LawCaseManage/ChangeTheManagerInfo.jsp";
		var sPara = "";
		var sStyle = "";
		var dialogArgs = "";
		
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else{
			for(var i=0;i<arr.length;i++){
				sSerialNo = getItemValue(0,arr[i],'SERIALNO');
				if(sSerialNo == null) sSerialNo = "";
				sSerialNoList += sSerialNo + "~";
				
				sManagerUserId = getItemValue(0,arr[i],'ManageUserID');
				//if(sManagerUserId == "")sManagerUserId == null; 
				if(sManagerUserId == null||sManagerUserId == "") sManagerUserId = "��";
				sManagerUserIdList += sManagerUserId + "~";
				sManagerUserName = getItemValue(0,arr[i],'ManageUserName');
				if(sManagerUserName == null||sManagerUserName == "") sManagerUserName = "��";
				sManagerUserNameList += sManagerUserName + "~";
				sManagerOrgId = getItemValue(0,arr[i],'ManageOrgID');
				//if(sManagerOrgId == "")sManagerOrgId == null; 
				if(sManagerOrgId == null||sManagerOrgId == "") sManagerOrgId = "��";
				sManagerOrgIdList += sManagerOrgId + "~";
				sManagerOrgName = getItemValue(0,arr[i],'ManageOrgName');
				if(sManagerOrgName == null||sManagerOrgName == "") sManagerOrgName = "��";
				sManagerOrgNameList += sManagerOrgName + "~";
			}
			sPara = "RelativeSerialNoList="+sSerialNoList+"&ManagerUserIdList="+sManagerUserIdList+"&ManagerOrgIdList="+sManagerOrgIdList;
			AsControl.PopComp(sManageUrl, sPara, sStyle, dialogArgs);
		 }
		 reloadSelf();
	 }
	
	/*~[Describe=�鿴�����������ʷ;InputParam=��;OutPutParam=SerialNo;]~*/	
	function my_history()
	{
		sLawCaseNo=getItemValue(0,getRow(),"SerialNo"); //�������		
	    if (typeof(sLawCaseNo)=="undefined" || sLawCaseNo.length==0)
		{
			alert(getHtmlMessage(1));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			//�������ͣ�LIChangeManager ���������˱����DAChangeManager ��ծ�ʲ������˱����PDAChangeManager �Ѻ����ʲ������˱��
			AsControl.PopComp("/RecoveryManage/Public/ChangeManagerList.jsp","ObjectNo="+sLawCaseNo+"&GoBackType=1","");
		}
		 
	}	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
