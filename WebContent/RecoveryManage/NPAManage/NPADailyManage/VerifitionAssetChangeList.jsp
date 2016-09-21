<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("VerifitionAssetChangeList");
	doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = " 
		+ CurUser.getOrgID() + " and  OB.BelongOrgID = O.INPUTORGID) ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","核销详情","核销详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","变更管理人","变更管理人","Change_Manager()","","","","btn_icon_add",""},
			{"true","","Button","查看变更记录","查看变更记录","Change_History()","","","","btn_icon_detail",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=查看合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		var sBDSerialNo =  getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sBDSerialNo)=="undefined" || sBDSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sBusinessStatus = getItemValue(0,getRow(0),"BUSINESSSTATUS");
		var inputUserID = getItemValue(0,getRow(),"InputUserID");
	    AsControl.PopComp("/RecoveryManage/NPAManage/NPADailyManage/VerificationAddInfo.jsp", "SerialNo="+sBDSerialNo+"&BusinessStatus="+sBusinessStatus+"&RightType=ReadOnly", "", "");
		reloadSelf();
	}	

	/*~[Describe=变更管理人信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function Change_Manager()
	{
		var sSerialNoList = "";		// 流水号 	串 以~分割
		var sManagerUserIdList = "";	 //现管理人id 	串 以~分割
		var sManagerUserNameList = "";	 //现管理人名称 	串 以~分割
		var sManagerOrgIdList = "";		 //现管理机构id 	串 以~分割
		var sManagerOrgNameList = "";	 //现管理机构名称 	串 以~分割
		
		var sSerialNo = "";		// 流水号 
		var sManagerUserId = "";	 //现管理人id 
		var sManagerUserName = "";	 //现管理人名称 
		var sManagerOrgId = "";		 //现管理机构id 
		var sManagerOrgName = "";	 //现管理机构名称 
		

		var sManageUrl = "/RecoveryManage/LawCaseManage/ChangeTheManagerInfo.jsp";
		var sPara = "";
		var sStyle = "";
		var dialogArgs = "";
		
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else{
			for(var i=0;i<arr.length;i++){
				sSerialNo = getItemValue(0,arr[i],'SERIALNO');
				if(sSerialNo == null) sSerialNo = "";
				sSerialNoList += sSerialNo + "~";
				
				sManagerUserId = getItemValue(0,arr[i],'INPUTUSERID');
				//if(sManagerUserId == "")sManagerUserId == null; 
				if(sManagerUserId == null||sManagerUserId == "") sManagerUserId = "空";
				sManagerUserIdList += sManagerUserId + "~";
				//sManagerUserName = getItemValue(0,arr[i],'ManageUserName');
				//if(sManagerUserName == null||sManagerUserName == "") sManagerUserName = "空";
				//sManagerUserNameList += sManagerUserName + "~";
				sManagerOrgId = getItemValue(0,arr[i],'INPUTORGID');
				//if(sManagerOrgId == "")sManagerOrgId == null; 
				if(sManagerOrgId == null||sManagerOrgId == "") sManagerOrgId = "空";
				sManagerOrgIdList += sManagerOrgId + "~";
				//sManagerOrgName = getItemValue(0,arr[i],'ManageOrgName');
				//if(sManagerOrgName == null||sManagerOrgName == "") sManagerOrgName = "空";
				//sManagerOrgNameList += sManagerOrgName + "~";
			}
			sPara = "RelativeSerialNoList="+sSerialNoList+"&ManagerUserIdList="+sManagerUserIdList+"&ManagerOrgIdList="+sManagerOrgIdList;
			AsControl.PopComp(sManageUrl, sPara, sStyle, dialogArgs);
		 }
		 reloadSelf();
	}

	/*~[Describe=查看变更管理人历史;InputParam=无;OutPutParam=SerialNo;]~*/	
	function Change_History()
	{
		var sSerialNo=getItemValue(0,getRow(),"SERIALNO");	  //
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！			
		}else
		{ 
			//关联类型：LIChangeManager 案件管理人变更、DAChangeManager 抵债资产管理人变更、PDAChangeManager 已核销资产管理人变更
			//OpenPage("/RecoveryManage/Public/ChangeManagerList.jsp?ObjectType=PDAChangeManager&ObjectNo="+sLawCaseNo+"&GoBackType=3","right");
			AsControl.PopComp("/RecoveryManage/Public/ChangeManagerList.jsp","ObjectNo="+sSerialNo+"&GoBackType=3","");

		}
		 reloadSelf();
	}	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
