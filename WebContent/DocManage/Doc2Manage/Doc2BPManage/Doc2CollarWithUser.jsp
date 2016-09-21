<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<!-- 

    author: yjhou 2015.03.04 
    description:用于客户 二类业务资料领用相关操作 

 -->
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sSerialNo = CurPage.getParameter("DOSerialNo"); //当前业务资料出库申请流水号
	if(sSerialNo == null) sSerialNo = ""; 
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	String sTempletNo = "Doc2OutOfWarehouseApplyInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("TRANSACTIONCODE", "0020");
	doTemp.setHtmlEvent("TRANSACTIONCODE", "onClick", "transactionCodeChange");
	//在做业务资料领用时不显示申请流水号
	doTemp.setVisible("SERIALNO", false);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	if("ReadOnly".equals(sRightType)){
		dwTemp.ReadOnly = "-2";
		doTemp.setColInnerBtEvent("*", "");
	}
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			{"true","All","Button","确认","确认领用","submit()","","","",""},
			{"true","All","Button","取消返回","取消领用","self.close()","","","",""},
		//{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "");
	}
	//出库后领用
	function submit(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//出库方式
		//插入一条操作数据DocOutApproveAction
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutApproveAction", "updateOperation", "DOSerialNo="+sDOSerialNo+",UserID=<%=CurUser.getUserID()%>");
		if((typeof(sReturn)!="undefined" && sReturn=="true")&&sReturn.length>0){
				alert("申请提交成功！");
				self.close();
		}else{
			alert("申请提交失败！");
		}
		
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
 	
 	 
 	/* 
 	 * 根据出库方式的不同显示不同的要素： yjhou  2015.03.03
 	 * 当出库方式为"出借"时，显示"借用日期"、"计划归还"、"实际归还日期"、"出库内容"要素
 	 * 当出库方式为"出库"时，隐藏上述四个要素
 	 */
 	function transactionCodeChange(){
 		var sTransactionCode=getItemValue(0,getRow(),"TRANSACTIONCODE");
 		if(sTransactionCode=="0020"){
 			hideItem(0,'BORROWDATE'); 
 			hideItem(0,'PLANRETURNDATE'); 
 			hideItem(0,'ACTUALRETURNDATE'); 
 		}else if(sTransactionCode=="0030"){
 			showItem(0,"BORROWDATE");
 			showItem(0,"PLANRETURNDATE");
 			showItem(0,"ACTUALRETURNDATE");
 			
 		}
 		operateDescription();//调用联动显示不同出库原因的函数
 	}
 	
 	//出库方式要素的联动事件：根据出库方式的不同显示不同的出库原因
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
 	
 	transactionCodeChange();
 	
 	//获取当前机构的领用人：可以选择当前机构下的任意用户
 	function  selectUser(){
 		 setObjectValue("SelectRoleUser","OrgID,<%=CurOrg.orgID%>","@USEUSERID@0@USEUSERNAME@1@USEORGID@2@USEORGNAME@3",0,0,"");
 	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
