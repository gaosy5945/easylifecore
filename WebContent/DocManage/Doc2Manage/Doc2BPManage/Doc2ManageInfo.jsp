<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
/**  1������ҵ������Ԥ�鵵�ύ������
*/

	String serialNo = (String)CurPage.getParameter("SerialNo");

	String sApplyType = (String)CurPage.getParameter("ApplyType");
    String sObjectType = (String)CurPage.getParameter("ObjectType"); 
	String sTransactionCode = (String)CurPage.getParameter("TransactionCode"); 	
	if(sTransactionCode==null){sTransactionCode="";}
	String sObjectNo = "";
	String sTempletNo = "";
	if(!"".equals(sObjectType)&&sObjectType!=null&&"jbo.prj.PRJ_BASIC_INFO".equals(sObjectType)){
		sTempletNo ="CooperAtionObject";//��ҵ�����Ϲ�������Ϊ"������Ŀ"ʱ��ʾ��ģ��
	}else{
		sTempletNo = "Doc2ManageInfo";//��ҵ�����Ϲ�������Ϊ"���"��"����"ʱ��ʾ��ģ��
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//���������Ͳ���"Ԥ�鵵����"ʱ������ʾ"��λ"Ҫ�صĺ�׺��ʾ��Ϣ
	if(!"".equals(sTransactionCode)&&!"0000".equals(sTransactionCode)){
		doTemp.setUnit("POSITION", "");
		doTemp.setHeader("SERIALNO", "�����");
	}else{
		doTemp.setHeader("SERIALNO", "Ԥ�鵵���");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//ֻ��ģʽ
	//dwTemp.replaceColumn("ADDRESSINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/DocManage/Doc2Manage/Doc2BPManage/DocFileList.jsp?DOSerialNo="+serialNo+"&DOObjectType="+sObjectType+"&DOObjectNo="+sObjectNo+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","�ύ","Ԥ�鵵�ύ","submitRecord()","","","",""},
	};

	sButtonPosition = "north";
	//�����ʱ ���ذ�ť
	if("03".equals(sApplyType)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
	}
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	//Ԥ�鵵
	function submitRecord(){
		if(as_isPageChanged()){
			alert("�ύǰ���ȱ��棡");
			return;
		}
		var serialNo = "<%=serialNo%>"; 
		var transactionCode = getItemValue(0,getRow(),"TransactionCode");
		var opStatus = getItemValue(0,getRow(),"STATUS");
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","commit","SerialNo="+serialNo+",TransactionCode="+transactionCode+",Status="+opStatus);
		alert(returnValue);
		top.close();
	}
	
</script>
		
<%@ include file="/Frame/resources/include/include_end.jspf"%>
