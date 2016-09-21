<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String CreditInspectType = DataConvert.toString(CurPage.getParameter("CreditInspectType"));
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	String orgID = CurUser.getOrgID();
	String operateUserID = CurUser.getUserID();
	if(CreditInspectType==null) CreditInspectType="";
	//ASObjectModel doTemp = new ASObjectModel("PrjCheckList");

	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
		BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("PrjCheckList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	if("1,2,6".equals(status)){//未完成
		doTemp.setJboWhere("O.OBJECTTYPE='jbo.prj.PRJ_BASIC_INFO' and O.OBJECTNO=PBI.SERIALNO "+
				" and O.STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and O.OPERATEORGID=:OPERATORGRID and O.OPERATEUSERID=:OPERATEUSERID and PBI.CUSTOMERID = CL.CUSTOMERID");
	}else{//已完成
		doTemp.setJboWhere("PBI.CUSTOMERID = CL.CUSTOMERID and O.OBJECTTYPE='jbo.prj.PRJ_BASIC_INFO' and O.OBJECTNO=PBI.SERIALNO "+
	            " and O.STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = :OrgID and OB.BelongOrgID = O.OPERATEORGID)");
	}
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("INSPECTTYPE", CreditInspectType);
	dwTemp.setParameter("OPERATEUSERID", operateUserID);
	dwTemp.setParameter("OPERATORGRID", orgID);
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{("1,2,6".equals(status) ? "true" : "false"),"All","Button","新增检查","新增","add()","","","","",""},
			{"true","","Button","检查详情","详情","edit()","","","","",""},
			{("1,2,6".equals(status) ? "true" : "false"),"All","Button","取消检查","取消检查","del()","","","","",""},
			{("1,2,6".equals(status) ? "true" : "false"),"All","Button","完成","完成","finish()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
	    var returnValue = AsDialog.SelectGridValue('SelectPrjBasicInfo',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle,'','1');
	    if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		returnValue = returnValue.split("~");
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				var parameter = returnValue[i];
	    AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertInspectRecord", "insertInspectRecord", "SerialNo="+parameter+",ObjectType=jbo.prj.PRJ_BASIC_INFO"+",InspectType=<%=CreditInspectType%>,OperateUserID=<%=CurUser.getUserID()%>,OperateOrgID=<%=CurUser.getOrgID()%>");
			}
		}
	    reloadSelf();
	}
	function del(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		}
		if(!confirm("确认取消检查吗?")) return;
		as_delete(0);
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var objectNo = getItemValue(0,getRow(0),'ObjectNo');
		 var objectType = getItemValue(0,getRow(0),'ObjectType');
		 var customerID = getItemValue(0, getRow(0), 'CustomerID');
		 var projectType = getItemValue(0, getRow(0), 'ProjectType');
		 var creditInspectType = "<%=CreditInspectType%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 var status="<%=status%>";
		 if(status=="1,2,6"||status=="1,2"){
			 sRightType="All";
		 }else{
			 sRightType="ReadOnly";
		 }
		AsCredit.openFunction("HandDirectionInfo","ProjectType="+projectType+"&CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&RightType="+sRightType);
		reloadSelf();
	}
	function finish(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var status = getItemValue(0, getRow(0), "Status");
		 var inspectAction = getItemValue(0, getRow(0),"InspectAction");
		 var projectType = getItemValue(0, getRow(0), "ProjectType");
		 var ObjectNo = getItemValue(0,getRow(0),"OBJECTNO");
		 var creditInspectType = "<%=CreditInspectType%>";
		 var orgID = "<%=CurUser.getOrgID()%>";
		 var userID = "<%=CurUser.getUserID()%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 )
		 {
			alert("参数不能为空！");
			return ;
		 }
		 if(typeof(inspectAction)=="undefined" || inspectAction.length==0 )
		 {
			alert("请填写检查结论！");
			return ;
		 }
		 var isUp = "";
		 if(creditInspectType=="02" || creditInspectType=="05" || creditInspectType=="06"){
			isUp = AsControl.RunASMethod("AfterBusiness","CheckOperateLoanRelative",ObjectNo+","+creditInspectType);
		 }
		 if(isUp=="true"){
					if(!confirm('该类型的合作项目检查，需提交上级审查！'))return;
					//var returnValue = AsControl.RunASMethod("AfterBusiness","AfterBusinessCheckInfo",serialNo+","+creditInspectType+","+userID+","+orgID);
					var returnValue = AsControl.RunASMethod("AfterBusiness","AfterBusinessCheckInfo","Apply65"+creditInspectType+","+serialNo+","+creditInspectType+","+userID+","+orgID);

					if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue.indexOf("@") == -1){
						return;
					}else{
						if(returnValue.split("@")[0] == "true"){
							var serialNo = returnValue.split("@")[1];
							var functionID = returnValue.split("@")[2];
							var flowSerialNo = returnValue.split("@")[3];
							var taskSerialNo = returnValue.split("@")[4];
							var phaseNo = returnValue.split("@")[5];
							var msg = returnValue.split("@")[6];
						}
					}
					var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
					if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
					{
						return;
					}
					else
					{
						if(returnValue.split("@")[0] == "true")
						{
							AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertInspectRecord","finishInspectRecord","SerialNo="+serialNo+",Status=0");
						}
					}
					return;
			}else{
				 if(confirm('确实要完成检查吗?')){
					 AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertInspectRecord","finishInspectRecord","SerialNo="+serialNo+",Status="+status);
				 }
			}
			reloadSelf();
	}
	
	function reloadSelf(){
		var creditInspectType = "<%=CreditInspectType%>";
		var status = "<%=status%>";
		AsControl.OpenComp("/CreditManage/AfterBusiness/PrjCheckList.jsp","CreditInspectType="+creditInspectType+"&Status="+status,"_self");
	} 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
