<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("AssetManageUserList");
	doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = " 
		+ CurUser.getOrgID() + " and  OB.BelongOrgID = O.INPUTORGID) ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //������ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","�ʲ�����","�鿴��ծ�ʲ�����","viewAndEdit()","","","",""},
			{"true","","Button","���������","���������","Change_Manager()","","","",""},
			{"true","","Button","�鿴�����¼","�鿴�����¼","Change_History()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		var sAssetType = getItemValue(0,getRow(),"AssetType");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var sFunctionID="PDAInfoList";
		var sDAStatus = getItemValue(0,getRow(),"Status");
		AsCredit.openFunction(sFunctionID,"SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType + "&AssetStatus=" + sDAStatus + "&RightType=ReadOnly")
		//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sDASerialNo+"&AssetSerialNo="+sAISerialNo,"");
		reloadSelf();
	}
	
	/*~[Describe=�����������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function Change_Manager()
	{
		var sSerialNoList = "";		// ��ˮ�� 	�� ��~�ָ�
		var sManagerUserIdList = "";	 //�ֹ�����id 	�� ��~�ָ�
		var sManagerUserNameList = "";	 //�ֹ��������� 	�� ��~�ָ�
		var sManagerOrgIdList = "";		 //�ֹ�������id 	�� ��~�ָ�
		var sManagerOrgNameList = "";	 //�ֹ����������� 	�� ��~�ָ�
		
		var sSerialNo = "";		// ��ˮ�� 
		var sManagerUserId = "";	 //�ֹ�����id 
		var sManagerUserName = "";	 //�ֹ��������� 
		var sManagerOrgId = "";		 //�ֹ�������id 
		var sManagerOrgName = "";	 //�ֹ����������� 
		
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
	function Change_History()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //��õ�ծ�ʲ���ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��			
		}else
		{ 
			//�������ͣ�LIChangeManager ���������˱����DAChangeManager ��ծ�ʲ������˱����PDAChangeManager �Ѻ����ʲ������˱��
			AsControl.PopComp("/RecoveryManage/Public/ChangeManagerList.jsp","ObjectNo="+sSerialNo+"&GoBackType=2","");
			//OpenPage("/RecoveryManage/Public/ChangeManagerList.jsp","ObjectNo="+sSerialNo+"&GoBackType=2","right");
		}
	}	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>