<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		ҳ��˵��: �����б�
	 */
	String rightType = CurPage.getParameter("RightType");
 	if(rightType == null) rightType = "";
 	ASObjectModel doTemp = new ASObjectModel("BoardList");
 	if("ReadOnly".equals(rightType)){
	 	doTemp.setJboWhere("IsPublish = '1'");
 	}
 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
 	
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","��������","��������","my_add()","","","",""},
		{"true","All","Button","ɾ������","ɾ������","my_del()","","","",""},
		{"true","","Button","��������","�鿴��������","my_detail()","","","",""},
		//{"true","","Button","���渽��","�鿴���渽��","DocDetail()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function my_add(){
		//AsControl.PopComp("/AppConfig/BoardManage/BoardUpDown.jsp","","dialogWidth=700px;dialogHeight=700px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		AsControl.PopComp("/AppConfig/BoardManage/BoardDetailInfo.jsp","", "dialogWidth=700px;dialogHeight=700px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	function my_detail(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sDocNo = getItemValue(0,getRow(),"docNo");
		//AsControl.PopComp("/AppConfig/BoardManage/BoardDetailInfo.jsp","BoardNo="+sBoardNo,"rightdown","");
		AsControl.PopComp("/AppConfig/BoardManage/BoardDetailInfo.jsp","RightType=<%=rightType%>&BoardNo="+sBoardNo+"&DocNo="+sDocNo, "dialogWidth=700px;dialogHeight=700px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	
	}
	
	<%/*[Describe=�鿴���渽��;]*/%>
	/* function DocDetail(){
		
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//AsControl.OpenView("/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo,"rightdown","");
		AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	} */
	
	function my_del(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			as_delete('myiframe0');
		}
	}

	<%/*~[Describe=�����¼�;]~*/%>
	
</script>
<%@	include file="/Frame/resources/include/include_end.jspf"%>