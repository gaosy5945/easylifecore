<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String CreditInspectType = DataConvert.toString(CurPage.getParameter("CreditInspectType"));
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	String orgID = CurUser.getOrgID();
	String operateUserID = CurUser.getUserID();
	ASObjectModel doTemp = new ASObjectModel("PrjCusCheckList");
	if("1,2,6".equals(status)){
		doTemp.setJboWhere("O.OBJECTTYPE='jbo.prj.PRJ_BASIC_INFO' and O.OBJECTNO=CL.SERIALNO and STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and O.OPERATEORGID=:OPERATORGRID and O.OPERATEUSERID=:OPERATEUSERID");
	}else{
		doTemp.setJboWhere("O.OBJECTTYPE='jbo.prj.PRJ_BASIC_INFO' and O.OBJECTNO=CL.SERIALNO and STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = :OrgID and OB.BelongOrgID = O.OPERATEORGID)");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("INSPECTTYPE", CreditInspectType);
	dwTemp.setParameter("OPERATEUSERID", operateUserID);
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.genHTMLObjectWindow(CreditInspectType+","+orgID+","+operateUserID);
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{("1,2,6".equals(status) ? "true" : "false"),"All","Button","�������","����","add()","","","","",""},
			{"true","","Button","�������","����","edit()","","","","",""},
			{("1,2,6".equals(status) ? "true" : "false"),"All","Button","ȡ�����","ȡ�����","del()","","","","",""},
			{("1,2,6".equals(status) ? "true" : "false"),"All","Button","���","���","finish()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sStyle = "dialogWidth:800px;dialogHeight:640px;resizable:yes;scrollbars:no;status:no;help:no";
	    var returnValue = AsDialog.SelectGridValue('SelectCustomer',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle);
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
			alert("��������Ϊ�գ�");
			return ;
		}
		if(!confirm("ȷ��ȡ�������?")) return;
		as_delete(0);
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var objectNo = getItemValue(0,getRow(0),'ObjectNo');
		 var objectType = getItemValue(0,getRow(0),'ObjectType');
		 var customerID = getItemValue(0, getRow(0), 'CustomerID');
		 var creditInspectType = "<%=CreditInspectType%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 var status="<%=status%>";
		 if(status=="1,2,6"||status=="1,2"){
			 sRightType="All";
		 }else{
			 sRightType="ReadOnly";
		 }
		AsCredit.openFunction("PrjCusCheckList","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&RightType="+sRightType);
		reloadSelf();
	}
	function finish(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var status = getItemValue(0, getRow(0), "Status");
		 var inspectAction = getItemValue(0, getRow(0),"InspectAction");
		 var creditInspectType = "<%=CreditInspectType%>";
		 var ObjectNo = getItemValue(0,getRow(0),"OBJECTNO");
		 var orgID = "<%=CurUser.getOrgID()%>";
		 var userID = "<%=CurUser.getUserID()%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 )
		 {
			alert("��������Ϊ�գ�");
			return ;
		 }
		 if(typeof(inspectAction)=="undefined" || inspectAction.length==0 )
		 {
			alert("����д�����ۣ�");
			return ;
		 }
		 var isUp = "";
		 if(creditInspectType=="02" || creditInspectType=="05" || creditInspectType=="06"){
			isUp = AsControl.RunASMethod("AfterBusiness","CheckOperateLoanRelative",ObjectNo+","+creditInspectType);
		 }
		 if(isUp=="true"){
				if(!confirm('�����͵ĺ�����Ŀ��飬���ύ�ϼ���飡'))return;
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
						top.close();
					}
				}
				return;
			}else{
				 if(confirm('ȷʵҪ��ɼ����?')){
					 AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertInspectRecord","finishInspectRecord","SerialNo="+serialNo+",Status="+status);
				 }
			}
			reloadSelf();
	}
	function reloadSelf(){
		var creditInspectType = "<%=CreditInspectType%>";
		var status = "<%=status%>";
		AsControl.OpenComp("/CreditManage/AfterBusiness/PrjCusCheckList.jsp","CreditInspectType="+creditInspectType+"&Status="+status,"_self");
	} 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
