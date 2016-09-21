<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String days = DataConvert.toString(CurPage.getParameter("Days"));
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	if (status == null) status = "";
	//String operateUserID = CurUser.getUserID();
	//ASObjectModel doTemp = new ASObjectModel("ALCollTaskList");
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
// 	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ALCollTaskList",inputParameter,CurPage);
// 	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectModel doTemp = new ASObjectModel("ALCollTaskList");
	
	String sRoleInfo []={"PLBS0014"};
	String sWhereClause="";
	String sWhereClause1="";
	String sWhereClause2="";
	String sWhereClause3="";
	if(CurUser.hasRole(sRoleInfo)){
		sWhereClause=" and exists (select 1 from v.org_belong where v.belongorgid=O.OperateOrgID and v.OrgID='"+CurUser.getOrgID()+"') ";
	}else{
		sWhereClause=" and O.OperateUserID='"+CurUser.getUserID()+"' ";
	}
	
	if("29".equals(days)){
		doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO  and AL.OVERDUEDAYS BETWEEN 1 AND 29 and (O.COLLECTIONMETHOD is null or O.COLLECTIONMETHOD<>'5')  ");
	}else if("59".equals(days)){
		doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO  and AL.OVERDUEDAYS BETWEEN 30 AND 59 and (O.COLLECTIONMETHOD is null or O.COLLECTIONMETHOD<>'5')  ");
	}else if("89".equals(days)){
		doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO  and AL.OVERDUEDAYS BETWEEN 60 AND 89 and (O.COLLECTIONMETHOD is null or O.COLLECTIONMETHOD<>'5')  ");
	}else if("90".equals(days)){
		doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO  and AL.OVERDUEDAYS >= 90 and (O.COLLECTIONMETHOD is null or O.COLLECTIONMETHOD<>'5')  ");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式                                                                      
	dwTemp.setPageSize(15);
	if("".equals(status)){
		dwTemp.MultiSelect = true;
	}
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{("".equals(status) ? "true" : "false"),"All","Button","催收登记","催收登记","edit()","","","","",""},
			{("".equals(status) ? "true" : "false"),"All","Button","批量打印催收函","批量打印催收函","print()","","","","",""},
			{("4".equals(status)||"3".equals(status) ? "true" : "false"),"","Button","催收详情","催收详情","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var days = "<%=days%>";
		var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
		var returnValue = "";
        if(days == "29"){
        	returnValue = AsDialog.SelectGridValue('AddBDlist29',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle);
        }else if(days == "59"){
        	returnValue = AsDialog.SelectGridValue('AddBDlist59',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle);
        }else if(days == "89"){
        	returnValue = AsDialog.SelectGridValue('AddBDlist89',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle);
        }else{
        	returnValue = AsDialog.SelectGridValue('AddBDlist90',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle);
        }
        if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_") return;
		returnValue = returnValue.split("~");
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				var parameter = returnValue[i];
        		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.colltask.action.InsertCollTask", "insertCollTask", "SerialNo="+parameter+",ObjectType=jbo.acct.ACCT_LOAN"+",InputUserID=<%=CurUser.getUserID()%>,InputOrgID=<%=CurUser.getOrgID()%>");
			}
		}
        reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
	 	var duebillSerialNo = getItemValue(0,getRow(0),'ObjectNo');
		var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
	 	var customerID = getItemValue(0, getRow(0), 'CustomerID');
	 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请先选择一条记录！");
			return ;
	 	}
		var returnValue = AsCredit.openFunction("CollTaskInfo","ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
		if(returnValue == "true"){
			reloadSelf();
			edit();
		}else reloadSelf();
	}
	function print(){
		var recordArray = getCheckedRows(0);//获取勾选的行
 		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
					AsControl.OpenView("/BillPrint/DunNoticePrint.jsp","SerialNo="+serialNo,"_blank");//逾期贷款催收通知书
				}
		}else{
			alert("请先选择一条记录");
		} 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
