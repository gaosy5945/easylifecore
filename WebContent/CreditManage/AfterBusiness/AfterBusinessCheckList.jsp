<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String CreditInspectType = DataConvert.toString(CurPage.getParameter("CreditInspectType"));
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	String orgID = CurUser.getOrgID();
	String operateUserID = CurUser.getUserID();
	String sTempleNo="";
	if("01".equals(CreditInspectType)||"02".equals(CreditInspectType)){
		sTempleNo="AfterBusinessCheckList1";
	}else if("03".equals(CreditInspectType)||"04".equals(CreditInspectType)){
		sTempleNo="AfterBusinessCheckList";
	}
	ASObjectModel doTemp = new ASObjectModel(sTempleNo);
	if("01".equals(CreditInspectType)||"02".equals(CreditInspectType)){
		if("1,2".equals(status) || "1,2,6".equals(status)){
			doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and O.OPERATEORGID=:OPERATORGID and O.OPERATEUSERID=:OPERATEUSERID");
		}else{
			doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = :OrgID and OB.BelongOrgID = O.OPERATEORGID)");
		}
	}else if("03".equals(CreditInspectType)||"04".equals(CreditInspectType)){
		if("1,2".equals(status) || "1,2,6".equals(status)){//status:6 �˻��ؼ�
			doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and AL.CONTRACTSERIALNO=BC.SERIALNO and AL.CustomerID=CI.CustomerID and STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and O.OPERATEORGID=:OPERATORGID and O.OPERATEUSERID=:OPERATEUSERID");
		}else{
			doTemp.setJboWhere("O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and AL.CONTRACTSERIALNO=BC.SERIALNO and AL.CustomerID=CI.CustomerID and STATUS in ('"+status.replaceAll(",","','")+"') and O.INSPECTTYPE=:INSPECTTYPE and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = :OrgID and OB.BelongOrgID = O.OPERATEORGID)");
		}
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("INSPECTTYPE", CreditInspectType);
	dwTemp.setParameter("OPERATEUSERID", operateUserID);
	dwTemp.setParameter("OPERATORGID", orgID);
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.genHTMLObjectWindow(CreditInspectType+","+orgID+","+operateUserID);
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{("1,2".equals(status)||"1,2,6".equals(status) ? "true" : "false"),"All","Button","�������","����","add()","","","","",""},
			{"true","","Button","�������","����","edit()","","","","",""},
			{("1,2".equals(status)||"1,2,6".equals(status) ? "true" : "false"),"","Button","ȡ�����","ȡ�����","del()","","","","",""},
			{("1,2".equals(status)||"1,2,6".equals(status) ? "true" : "false"),"","Button","���","���","finish()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sStyle = "dialogWidth:950px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
		 var CreditInspectType = "<%=CreditInspectType%>";
		 var returnValue = "";
		 var ObjectType=""; 
		 if(CreditInspectType == "03"){
			 var ProductType3 = "02";
			 ObjectType="jbo.acct.ACCT_LOAN";
         	 returnValue = AsDialog.SelectGridValue('ALInspectSelectList2',"<%=CurUser.getOrgID()%>",'SERIALNO','',true,sStyle,'','1');
		 }else if(CreditInspectType == "04"){
			 var ProductType3 = "01";
			 ObjectType="jbo.acct.ACCT_LOAN";
			 returnValue = AsDialog.SelectGridValue('ALInspectSelectList2',"<%=CurUser.getOrgID()%>",'SERIALNO','',true,sStyle,'','1');
		 }else if(CreditInspectType == "01"){
			 ObjectType="jbo.acct.ACCT_LOAN";
			 returnValue = AsDialog.SelectGridValue('ALInspectSelectList01',"<%=CurUser.getOrgID()%>",'SERIALNO','',true,sStyle,'','1');
		 }else{
			 ObjectType="jbo.acct.ACCT_LOAN";
			 returnValue = AsDialog.SelectGridValue('ALInspectSelectList',"<%=CurUser.getOrgID()%>",'SERIALNO','',true,sStyle,'','1');
		 }
         if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
 			return ;
 		returnValue = returnValue.split("~");
 		for(var i in returnValue){
 			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
 				var parameter = returnValue[i];
        	 	AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertInspectRecord", "insertInspectRecord", "SerialNo="+parameter+",ObjectType="+ObjectType+",InspectType=<%=CreditInspectType%>,OperateUserID=<%=CurUser.getUserID()%>,OperateOrgID=<%=CurUser.getOrgID()%>");
 			}
 		}
         reloadSelf();
	}
	function del(){
		var serialNo = getItemValue(0,getRow(0),'SERIALNO');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(!confirm("ȷ��ȡ�������?")) return;
		as_delete(0);
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
		 var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
		 var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
		 var putOutDate = getItemValue(0,getRow(0),'PUTOUTDATE');
		 var creditInspectType = "<%=CreditInspectType%>";
		 var status="<%=status%>";
		 if(status=="1,2,6"||status=="1,2"){
			 sRightType="All";
		 }else{
			 sRightType="ReadOnly";
		 }
		 var customerID = getItemValue(0, getRow(0), 'CustomerID');

		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		 }
		 if(creditInspectType == "01"){
			AsCredit.openFunction("FundDirectionInfo","CreditInspectType="+creditInspectType+"&PutOutDate="+putOutDate+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
			reloadSelf();
			return;
		 }else if(creditInspectType == "02"){
			 AsCredit.openFunction("FundPurposeInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
			 reloadSelf();
			 return;
		 }else if(creditInspectType == "03"){
			 AsCredit.openFunction("RunDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
			 reloadSelf();
			 return;
		 }else {
			 AsCredit.openFunction("ConsumeDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
			 reloadSelf();
			 return;
		 }
	}
	function finish(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var status = getItemValue(0, getRow(0), "Status");
		 var inspectAction = getItemValue(0, getRow(0),"InspectAction");
		 var ObjectNo = getItemValue(0,getRow(0),"OBJECTNO");
		 var creditInspectType = "<%=CreditInspectType%>";
		 var orgID = "<%=CurUser.getOrgID()%>";
		 var userID = "<%=CurUser.getUserID()%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 )
		 {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		 }
		 if(typeof(inspectAction)=="undefined" || inspectAction.length==0 )
			{
				alert("����д�����ۣ�");
				return ;
			}
		 var isUp = "";
			if(creditInspectType=="02"||creditInspectType=="03"){
				isUp = AsControl.RunASMethod("AfterBusiness","CheckOperateLoanRelative",ObjectNo+","+creditInspectType+","+inspectAction );
			}
		 if(isUp=="true"){
				if(!confirm('�ô������ΥԼ��������ύ�ϼ���飡'))return;
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
				}else{
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
		AsControl.OpenComp("/CreditManage/AfterBusiness/AfterBusinessCheckList.jsp","CreditInspectType="+creditInspectType+"&Status="+status,"_self");
	} 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>