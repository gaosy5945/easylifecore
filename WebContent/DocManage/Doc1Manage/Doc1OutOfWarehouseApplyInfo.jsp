<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sAISerialNo = CurPage.getParameter("AISerialNo");
	if(sAISerialNo == null) sAISerialNo = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sApplyType = CurPage.getParameter("ApplyType");
	if(sApplyType == null) sApplyType = "";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	String sApproveType = CurPage.getParameter("ApproveType");
	if(sApproveType == null) sApproveType = ""; 
	String sDFPSerialNo = CurPage.getParameter("DFPSerialNo");
	if(null==sDFPSerialNo) sDFPSerialNo="";
	String sPkgId = CurPage.getParameter("PkgId");
	String sTempletNo = "Doc1OutOfWarehouseApplyInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo); 
	//出库方式的联动事件：根据出库不同的出库方式联动显示不同的出库原因
	doTemp.setHtmlEvent("TRANSACTIONCODE", "onClick", "tranSactionTypeChange");
	doTemp.setDDDWJbo("TRANSACTIONCODE","jbo.ui.system.CODE_LIBRARY,itemno,ItemName,Isinuse='1' and CodeNo='DocumentTransactionCode' and ItemNo in('0020','0030') order by sortno");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	//将出库方式默认设置为出库
	doTemp.setDefaultValue("TRANSACTIONCODE", "0020");
	dwTemp.Style = "2";//freeform 
	if("ReadOnly".equals(sRightType)){
		dwTemp.ReadOnly = "1";
		//doTemp.setColInnerBtEvent("*", "");
	}
	String sColumnUrl = "/DocManage/Doc1Manage/Doc1RightCertificateList.jsp";
	dwTemp.genHTMLObjectWindow(sDOSerialNo);
	String sButtons[][] = {
	//{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	{"true","All","Button","提交出库","提交","saveRecord()","","","",""},
	};
	sButtonPosition = "north";
	//一类业务资料清单，出库申请已处理阶段和出库审批阶段详情界面按钮不可见 
	if("0020".equals(sApplyType)||"0010".equals(sApproveType)||"0020".equals(sApproveType)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
	}
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function returnList(){
	OpenPage("<%=sPrevUrl%>", "_self");
}
 	function setTranCode(){
 		var sOperationReason = getItemValue(0,getRow(0),'OPERATEDESCRIPTION');
 		var sTranCode = "";
 		
 		if(sOperationReason > 0 && sOperationReason<=10){
 			sTranCode = "0030";
 		}else if(sOperationReason > 10 && sOperationReason<=18){
 			sTranCode = "0020";
 		}
		setItemValue(0,getRow(0),'TRANSACTIONCODE',sTranCode);
 	}
	function submit(){
		if(!iV_all(0)){
			alert("请先保存数据！");
			return;
		} 
		if(as_isPageChanged()){
			alert("提交前请先保存数据！");
			return;
		}
		    var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		    <%-- var sAISerialNo = getItemValue(0,getRow(0),'AISerialNo');
 			//首先判断当前申请对应的流水是否存在，存在则做提交操作，否则给出提示
 			var sSql = "select count(serialno) from doc_operation do where do.serialno='"+sDOSerialNo+"'";
 			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
 			if(sReturnValue>0){
 				var sPara = "DOSerialNo="+sDOSerialNo+",ApplyType=01,UserID=<%=CurUser.getUserID()%>";
 	 		    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "commit", sPara);
 	 			if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
 	 				alert("提交成功！");
 	 				self.close();
 	 			}else {
 	 				alert("提交失败!");
 	 				return;
 	 			}
 			}else{
 				alert("请先保存数据！");
 				return;
 			} --%>
 			//modify by lzq 20150331
		    var sDFPSerialNo = "<%=sDFPSerialNo%>";//getItemValue(0,getRow(0),'OBJECTNO');
		    var sAISerialNo =  "<%=sAISerialNo%>";
		    var sPkgId = "<%=sPkgId%>";
		    var sObjectNo =  getItemValue(0,getRow(0),'OBJECTNO');
 			var sPara = "DFPSerialNo="+sDFPSerialNo+",AISerialNo="+sAISerialNo+",PkgId="+sPkgId+",DOSerialNo="+sDOSerialNo+",OutType=01,TransCode=0020,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
 			var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "doOutWarehouse", sPara);
 			if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
 				alert("成功提交出库！");
 				self.close();
 				//reloadSelf();
 			} 
 			
 		
	}
	
	function saveRecord(){ 
		if(!iV_all(0))return; 
		
		if(confirm("是否提交出库？")){
			as_save(0,"submit()");	
		}
	}
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
	
	//出库方式联动事件
	function tranSactionTypeChange(){
		//获取选择的出库方式
		tranSactionType=getItemValue(0,getRow(),"TRANSACTIONCODE");
		if(tranSactionType=="0020"){
 			hideItem(0,'BORROWDATE'); 
 			hideItem(0,'PLANRETURNDATE'); 
 			hideItem(0,'ACTUALRETURNDATE'); 
 			//hideItem(0,'TRANSACTIONCONTEXT'); 
 		}else if(tranSactionType=="0030"){
 			showItem(0,"BORROWDATE");
 			showItem(0,"PLANRETURNDATE");
 			showItem(0,"ACTUALRETURNDATE");
 			//showItem(0,"TRANSACTIONCONTEXT");
 		}
 		//modify by lzq 20150331 
 		//setItemValue(0,getRow(0),'OPERATEDESCRIPTION','');
		operateDescription();
	}
	
	function operateDescription(){
		var tranSactionType=getItemValue(0,getRow(),"TRANSACTIONCODE");
		if(tranSactionType=="0020" ||tranSactionType=="0030"){
			showItem(0,'OPERATEDESCRIPTION');
			  $("[name=OPERATEDESCRIPTION]").each(function(){
			 	$(this).parent().hide();
			 	if(tranSactionType=="0020"){
					if(this.value=="11" || this.value=="12"|| this.value=="13"|| this.value=="14"
					  || this.value=="15"|| this.value=="16"|| this.value=="17"|| this.value=="18"){
						$(this).parent().show();
					}
			 	}else if(tranSactionType=="0030"){
			 		if(this.value=="1" || this.value=="2"|| this.value=="3"|| this.value=="4"|| this.value=="5"
					  || this.value=="6"|| this.value=="7"|| this.value=="8"|| this.value=="9"|| this.value=="10"){
							$(this).parent().show();
					}
			 	} 
		 	 });  
		}
	}  
	
	tranSactionTypeChange();
	//获取当前机构的领用人：可以选择当前机构下的任意用户
 	function  selectUser(){
 		 setObjectValue("SelectRoleUser","OrgID,<%=CurOrg.orgID%>","@USEUSERID@0@USEUSERNAME@1@USEORGID@2@USEORGNAME@3",0,0,"");
 	}
	
	<%-- function initRow(){
		if(getRow()==0){
			setItemValue(0, getRow(), "TRANSACTIONCODE", "0020");
			tranSactionTypeChange();
			setItemValue(0, getRow(), "OPERATEUSERNAME", "<%=CurUser.getUserName()%>");
			setItemValue(0, getRow(), "INPUTORGID", "<%=CurUser.getOrgID()%>");
			setItemValue(0, getRow(), "INPUTORGIDName", "<%=CurUser.getOrgName()%>");
		}
	}
	initRow(); --%>
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
