<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		ҳ��˵��: ��������
	 */
	//���ҳ�����
	String sBoardNo = CurPage.getParameter("BoardNo");
 	String sDocNo = CurPage.getParameter("DocNo");
 	String stype = CurPage.getParameter("type");
	if(sBoardNo==null) sBoardNo="";
	if(stype == null) stype = "";
	if(sDocNo == null) sDocNo = "";
	String rightType = CurPage.getParameter("RightType");
 	if(rightType == null){
 		rightType = "";
 	}else if("ReadOnly".equals(rightType)){
 		stype = "1";
 	}
	ASObjectModel doTemp = new ASObjectModel("BoardInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow(sBoardNo);
		
	dwTemp.replaceColumn("DOCFILE","<iframe type='iframe' id=\"docFile\" name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/AppConfig/Document/AttachmentFrame.jsp?DocNo="+sDocNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	String orgId = CurUser.getOrgID();
	String userId = CurUser.getUserID();
	String inputTime = DateHelper.getBusinessDate();
	String orgname = CurUser.getOrgName();
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		//{"true","","Button","�ϴ��ļ�","�ϴ��ļ�","fileadd()","","","",""},
		
	};
	
	if("1".equals(stype)){
		sButtons[0][0] = "false";
		//sButtons[1][0] = "false";
	}
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
setDialogTitle("��������");
	function saveRecord(){	
		as_save("myiframe0");
	}
	
	/* function fileadd(){

		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert("�ȱ�����Ϣ���ϴ��ļ�!");
			return ;
		}else{
			AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    }
	}
	 */
	
	$(function(){
		var type= '<%=stype%>';
		if(type == "1"){
			hideItem("myiframe0","IsPublish");
			hideItem("myiframe0","isNew");
			hideItem("myiframe0","IsEject");			
		}
	})
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>