<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		ҳ��˵��:�ĵ�������Ϣ
		Input Param:
		     ObjectNo: ������
             ObjectType: ��������
             DocNo: �ĵ����
	 */
 	sASWizardHtml = "<div><font size=\"2pt\" color=\"#930055\">&nbsp;&nbsp;�ĵ�������Ϣ</font></div>";
	//����������
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");//--������
	String sRightType = CurPage.getParameter("RightType");//Ȩ��
	if(sRightType == null) sRightType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	//���ҳ��������ĵ���ź��ĵ�¼����ID
	String sDocNo = CurPage.getParameter("DocNo");
	if(sDocNo == null) sDocNo = "";

	ASObjectModel doTemp = new ASObjectModel("DocumentInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setParameter("DocNo", sDocNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","�鿴/�޸ĸ���","�鿴/�޸�ѡ���ĵ���ص����и���","viewAndEdit_attachment()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(sPostEvents){
		as_save("myiframe0",sPostEvents);
	}

	<%/*~[Describe=�鿴��������;]~*/%>
	function viewAndEdit_attachment(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(docNo)=="undefined" || docNo.length==0){
        	alert("���ȱ����ĵ����ݣ����ϴ�������");  //��ѡ��һ����¼��
			return;
    	}else{
			AsControl.OpenPage("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+docNo+"&RightType=<%=sRightType%>", "frameright");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>