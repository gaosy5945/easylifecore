<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";
	String sOpinionViewType = CurPage.getParameter("OpinionViewType");
	if(sOpinionViewType == null) sOpinionViewType = "";
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "Doc2OpinionInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
			{"false","All","Button","审批通过","审批通过","submitRecord()","","","",""},
			{"false","All","Button","退回","退回","submitBack()","","","",""},
			{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	if("0010" == sOpinionViewType || "0010".equals(sOpinionViewType)){
		sButtons[0][0] = "true";
		sButtons[1][0] = "true";
		sButtons[2][0] = "true";
	}
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		//OpenPage("<%=sPrevUrl%>", "_self");
		self.close();
	}
	function submitRecord(){//出库申请审批通过
		as_save(0);
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');
		if( getOpinion(sDOSerialNo)){
			var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status=03"+"&ApproveSubmitStatus=01";
			//插入一条操作数据
			var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseSubmitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
			if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					alert("审批成功！");
					reloadSelf();
			}else{
				alert("审批失败！");
			}
		}else{
			alert("请输入意见！");
		}
		reloadSelf();
	}
	function submitBack(){//出库申请审批 退回
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		if( getOpinion(sDOSerialNo)){
			//插入一条操作数据
			var sSql = "update doc_operation set status='05' where serialno='" +sDOSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue >0){
					alert("退回成功！");
			}else{
					alert("退回失败！");
			}
		}else{
			alert("请输入意见！");
		}
		reloadSelf();
	}
	function getOpinion(sDOSerialNo){
		var sReturnMsg = false;
		var sSql = "select OPERATEDESCRIPTION from doc_operation where serialno='" +sDOSerialNo+"'";
		var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
		if(sReturnValue.length<=0 || sReturnValue == "" || sReturnValue == "null" || sReturnValue == null || sReturnValue == "undefine" ){
			sReturnMsg = false;
		}else{
			sReturnMsg = true;
		}
		return sReturnMsg;
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
