<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//定义变量
	String sContext = CurOrg.getOrgID() + "," + CurUser.getUserID();
	String sWhereClause = ""; //Where条件
	
	//获得参数	：案件大阶段：诉讼前010，已诉讼020，取消诉讼030	
	String sItemID =  (String)CurPage.getParameter("ItemID");
	if(sItemID == null) sItemID="";
	//案件阶段	
	String sCasePhase = sItemID;	

	ASObjectModel doTemp = new ASObjectModel("LawCaseManageList");
	
	//诉讼前 列表信息
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
	dwTemp.Style="1";      	 //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow( "");

	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
			{"true","","Button","案件详情","查看/修改案件详情","viewAndEdit()","","","",""},
			{"true","","Button","立案登记","转入转入已诉讼阶段","doPigeonhole()","","","",""},
			{"true","","Button","转入下阶段","转入下阶段","my_NextPhase()","","","",""},
			{"true","","Button","取消诉讼","取消转入诉讼终结案件","my_CancelPigeonhole()","","","",""},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
			{"false","","Button","恢复诉讼","转入诉讼终结案件","recoverCancelPigeon()","","","",""},
			{"true","","Button","查看取消诉讼详情","查看取消诉讼详情","viewCancelPigeon()", "", "", "", "" } };

	//如果为诉前案件，则对应列表不显示：转入下阶段、恢复诉讼、查看取消诉讼详情 等按钮
	if (sCasePhase.equals("010")) {
			sButtons[3][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
	}

	//如果为已诉讼，则对应列表不显示：新增、立案、删除、恢复诉讼、查看取消诉讼详情  等按钮
	if (sCasePhase.equals("020")) {
			sButtons[0][0] = "false";
			sButtons[2][0] = "false";
			//sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
	}

	//如果为取消 ，则对应列表显示：案件详情、恢复诉讼、查看取消诉讼详情 等按钮
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
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{				
		//获得选择的案件类型
		var sLawCaseType = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sLawCaseType) == "undefined" && sLawCaseType.length == 0 && sLawCaseType == "" || sLawCaseType == "null" || sLawCaseType == "_CANCLE_")
		{	
		} else{
			//获取流水号
			var sTableName = "LAWCASE_INFO";//表名
			var sColumnName = "SerialNo";//字段名
			var sPrefix = "";//前缀
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
			//	alert("新增未成功！");
			//}
		}	
		reloadSelf();	
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			var sReturnFlag="";
			//sReturnFlag = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/deleteLawCaseAction.jsp?SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType ,"","");
			
			sReturnFlag = RunMethod("BusinessManage","DeleteLawCaseInfo", sSerialNo);
			if(typeof(sReturnFlag)!="undefined" &&(sReturnFlag=="1" || "1".equals(sReturnFlag))){
				alert("删除成功！");
			}
		}
		//删除案件后删除关联信息
	    //dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(LawcaseInfo,#SerialNo,DeleteBusiness)");
		
		reloadSelf();
	}
	
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得案件流水号
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
			alert(getHtmlMessage(1));  //请选择一条记录！
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


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	
	/*~[Describe=转入下阶段;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_NextPhase()
	{		
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			//获得选择阶段
			var sLawCasePhase = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCasePhaseDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sLawCasePhase) != "undefined" && sLawCasePhase.length != 0 && sLawCasePhase != '')
			{			
				if(sLawCasePhase == '<%=sCasePhase%>')
				{
					alert(getBusinessMessage("779"));  //转入阶段与当前阶段相同！
					return;
				}else if(confirm(getBusinessMessage("777"))) //您真的想将该案件转到下阶段吗？
				{
					sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@CasePhase@"+sLawCasePhase+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
					if(sReturnValue == "TRUE")
					{
						alert(getBusinessMessage("772"));//转入下阶段成功！
						reloadSelf();
					}else
					{
						alert(getBusinessMessage("773")); //转入下阶段失败！
						return;
					}						
				}
			}
	    }    
	}
	
	/*~[Describe=立案登记;InputParam=无;OutPutParam=SerialNo;]~*/	
	function doPigeonhole(sCasePhase){
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
				var sReturnValue="";
				var sReturnValue1="";
				var sTableName = "LAWCASE_BOOK";//表名
				var sColumnName = "SerialNo";//字段名
				var sPrefix = "";//前缀
				//获取流水号
				var sSerialNo2 = getSerialNo(sTableName,sColumnName,sPrefix);
				//插入一条立案台账信息
				 sReturnValue1 = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseRegistrationInfo.jsp?ObjectNo="+sSerialNo+"&LawCaseType="+sLawCaseType+"&BookType=030&SerialNo="+sSerialNo2+"","","");
				if(sReturnValue1=="TRUE" || "TRUE".equals(sReturnValue1))
				{
					alert("立案登记成功！");//立案登记成功
					reloadSelf();
				}else
				{
					alert("立案登记失败！"); //立案登记失败！
					return;
				}			
	    }
	}
			
	/*~[Describe=取消诉讼信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_CancelPigeonhole()
	{		
		//获得案件流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm("您真的想将该诉讼取消吗？")) //您真的想将该诉讼取消吗？
			{				
				var sReturnValue1 = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseReasonsInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=01","","resizable=yes;dialogWidth=50;dialogHeight=20;center:yes;status:no;statusbar:no");
				if(sReturnValue1 == "TRUE")
				{
					var sUpdateDate="<%=StringFunction.getToday()%>";
					sRetrunValue1 =  RunMethod("PublicMethod","UpdateColValue","String@UpdateDate@"+sUpdateDate+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				}
				if(sReturnValue1 == "TRUE")
				{
					alert("取消诉讼成功！");//归档成功！
					reloadSelf();
				}else
				{
					alert("取消诉讼失败");//归档失败！
					return;
				}
			}
	    }   
	}
	
	/*~[Describe=恢复诉讼信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function recoverCancelPigeon()
	{		
		//获得案件流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm("您真的想将该诉讼恢复吗？")) //您真的想将该诉讼恢复吗？
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
					alert("恢复取消诉讼成功！");//
					reloadSelf();
				}else
				{
					alert("恢复取消诉讼失败");//
					return;
				}
			}
	    }   
	}
	/*~[Describe=查看取消诉讼信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewCancelPigeon(){
		//获得案件流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			var sReturnValue1 = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseReasonsInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=03","","resizable=yes;dialogWidth=50;dialogHeight=20;center:yes;status:no;statusbar:no");
	    }  	
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
