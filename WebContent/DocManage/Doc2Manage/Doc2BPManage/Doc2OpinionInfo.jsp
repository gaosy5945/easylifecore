<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";
	String sOpinionViewType = CurPage.getParameter("OpinionViewType");
	if(sOpinionViewType == null) sOpinionViewType = "";
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "Doc2OpinionInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
			{"false","All","Button","����ͨ��","����ͨ��","submitRecord()","","","",""},
			{"false","All","Button","�˻�","�˻�","submitBack()","","","",""},
			{"true","All","Button","����","�����б�","returnList()","","","",""}
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
	function submitRecord(){//������������ͨ��
		as_save(0);
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');
		if( getOpinion(sDOSerialNo)){
			var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status=03"+"&ApproveSubmitStatus=01";
			//����һ����������
			var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseSubmitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
			if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					alert("�����ɹ���");
					reloadSelf();
			}else{
				alert("����ʧ�ܣ�");
			}
		}else{
			alert("�����������");
		}
		reloadSelf();
	}
	function submitBack(){//������������ �˻�
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		if( getOpinion(sDOSerialNo)){
			//����һ����������
			var sSql = "update doc_operation set status='05' where serialno='" +sDOSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue >0){
					alert("�˻سɹ���");
			}else{
					alert("�˻�ʧ�ܣ�");
			}
		}else{
			alert("�����������");
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
