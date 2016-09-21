<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zqliu
		Tester:
		Content: 诉讼案件列表
		Input Param:
			   CasePhase：案件状态     
		Output param:
				 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "诉讼案件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sContext = CurOrg.getOrgID() + "," + CurUser.getUserID();
	String sWhereClause = ""; //Where条件
	
	//获得参数	：案件大阶段：诉讼前010，已诉讼020，取消诉讼030	
	String sItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sItemID == null) sItemID="";
	//案件阶段	
	String sCasePhase = sItemID;	
%>
<%/*~END~*/%>


<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LawCaseManageList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.setDDDWSql("CasePhase", "select ItemNo,ItemName from Code_Library where CodeNo='CasePhase' and isinuse='1'");
	doTemp.setDDDWSql("LawCaseType", "select ItemNo,ItemName from Code_Library where CodeNo='LawCaseType' and isinuse='1'");
	doTemp.setDDDWSql("CaseBrief", "select ItemNo,ItemName from Code_Library where CodeNo='CaseBrief' and isinuse='1'");
	doTemp.setDDDWSql("CaseStatus", "select ItemNo,ItemName from Code_Library where CodeNo='CaseStatus' and isinuse='1'");
	doTemp.setEditStyle("CaseBrief", "7");
	//doTemp.setColumnAttribute("CaseBrief","IsFilter","7");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//诉讼前 列表信息
	if(sItemID=="010" || "010".equals(sItemID)){
		doTemp.WhereClause= doTemp.WhereClause + " and CasePhase='"+sCasePhase+"'";	
	}	else if(sItemID=="030" || "030".equals(sItemID)){
		doTemp.WhereClause= doTemp.WhereClause + " and CasePhase='110'";	
	} else	{
		doTemp.WhereClause= doTemp.WhereClause + " and CasePhase not in('010','110')";	
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
    
    //删除案件后删除关联信息
    //dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(LawcaseInfo,#SerialNo,DeleteBusiness)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContext);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	
		//如果为诉前案件，则列表显示如下按钮
		String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
			{"true","","Button","案件详情","查看/修改案件详情","viewAndEdit()","","","",""},
			{"true","","Button","立案登记","转入转入已诉讼阶段","doPigeonhole()","","","",""},
			{"true","","Button","转入下阶段","转入下阶段","my_NextPhase()","","","",""},
			{"true","","Button","取消诉讼","取消转入诉讼终结案件","my_CancelPigeonhole()","","","",""},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
			{"true","","Button","恢复诉讼","转入诉讼终结案件","recoverCancelPigeon()","","","",""},
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
			sButtons[4][0] = "false";
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
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{				
		//获得选择的案件类型
		var sLawCaseType = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sLawCaseType) == "undefined" && sLawCaseType.length == 0 && sLawCaseType == "" || sLawCaseType == "null")
		{	
		} else{
			//获取流水号
			var sTableName = "LAWCASE_INFO";//表名
			var sColumnName = "SerialNo";//字段名
			var sPrefix = "";//前缀
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);		
			var sReturn=PopPageAjax("/RecoveryManage/LawCaseManage/LawCaseDailyManage/AddLawCaseActionAjax.jsp?SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(sReturn=="true"){
				var sFunctionID="";
				if(sLawCaseType == "01" ){
					sFunctionID = "CaseInfoList1";
				}else{
					sFunctionID = "CaseInfoList2";
				}
				AsCredit.openFunction(sFunctionID, "SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType);
			}else{
				alert("新增未成功！");
			}
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
		reloadSelf();
	}

	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
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
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType);	
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
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
