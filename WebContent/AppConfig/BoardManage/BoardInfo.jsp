<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		ҳ��˵��: ��������
	 */
	//���ҳ�����
	String sBoardNo = CurPage.getParameter("BoardNo");
	if(sBoardNo==null) sBoardNo="";
	String sDocNo = CurPage.getParameter("DocNo");
	if(sDocNo==null) sDocNo="";

	ASObjectModel doTemp = new ASObjectModel("BoardInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow(sBoardNo);
	
	/* dwTemp.replaceColumn("DOCFILE","<iframe type='iframe' id=\"docFile\" name=\"frame_list\" width=\"100%\" height=\"500\" frameborder=\"0\" src=\""+sWebRootPath+"/AppConfig/Document/AttachmentFrame.jsp?DocNo="+sDocNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	 */
	String orgId = CurUser.getOrgID();
	String userId = CurUser.getUserID();
	String inputTime = DateHelper.getBusinessDate();
	String orgname = CurUser.getOrgName();
	

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		//{"true","","Button","�ϴ��ļ�","�ϴ��ļ�","fileadd()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	initRow();

	function saveRecord(){
		as_save(0,"reloadPage()");
	}
	
	function reloadPage(){
		var docNo = getItemValue(0,0,"DocNo");
		parent.OpenInfo(docNo);
	}
	
	/* function fileadd(){

		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert("�ȱ�����Ϣ���ϴ��ļ�!");
			return ;
		}else{
			AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    }
	} */
	
	function initSerialNo(){
		
		var sTableName = "BOARD_LIST";//����
		var sColumnName = "boardno";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);		
		return sSerialNo;
	}
	
	function initRow(){
		//if(getRow()==0){
			hideItem("myiframe0","docFile");
		//}
	}

</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>