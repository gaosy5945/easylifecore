<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		ҳ��˵��:�ĵ���Ϣ�б�
		Input Param:
       		    ObjectNo: ������
       		    ObjectType: ��������           		
	 */
	String PG_TITLE = "�ĵ���Ϣ�б�";
	//�������                     
	String sObjectNo = "";//--������
	
	//����������
	String sObjectType = CurPage.getParameter("ObjectType");
	String sRightType = CurPage.getParameter("RightType");//Ȩ��
	if(sObjectType == null) sObjectType = "";
	if(sRightType == null) sRightType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = CurPage.getParameter("CustomerID");
	else
		sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";

	if(sObjectType.equals("Other")) //�����ĵ�
		sObjectType = "ClassifyCreditLineApplyPutOutApplyReserveSMEApplyTransformApply";
	
	ASObjectModel doTemp = new ASObjectModel("DocumentList");
	//���ݶ����Ž��в�ѯ
	//����ģ���п��ƣ��˴�����Ҫ�ظ�����
	//���ɲ�ѯ����

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);
	
	//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
	//dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo')");
	//dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","All","Button","����","�����ĵ���Ϣ","newRecord()","","","",""},
		{"true","All","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()","","","",""},
		{"true","","Button","�ĵ�����","�鿴�ĵ�����","viewAndEdit_doc()","","","",""},
		{"true","","Button","��������","�鿴��������","viewAndEdit_attachment()","","","",""},
		{"false","","Button","��������","���������ĵ���Ϣ","exportFile()","","","",""},
	};
	if(sObjectNo.equals("")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		OpenPage("/AppConfig/Document/DocumentInfo.jsp?UserID="+"<%=CurUser.getUserID()%>","_self","");
	}

	function deleteRecord(){
		var sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>'){
			if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
				as_del('myiframe0');
				as_save('myiframe0'); //�������ɾ������Ҫ���ô����             
			}
		}else{
			alert(getHtmlMessage('3'));
			return;
		}
	}

	<%/*~[Describe=�鿴���޸�����;]~*/%>
	function viewAndEdit_doc(){
		var sDocNo=getItemValue(0,getRow(),"DocNo");
		var sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����		     	
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}else{
    		OpenPage("/AppConfig/Document/DocumentInfo.jsp?DocNo="+sDocNo+"&UserID="+sUserID,"_self","");
        }
	}
	
	<%/*~[Describe=�鿴���޸ĸ�������;]~*/%>
	function viewAndEdit_attachment(){
    	var sDocNo=getItemValue(0,getRow(),"DocNo");
    	var sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����
    	var sRightType="<%=sRightType%>";
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;         
    	}else{
    		//popComp("AttachmentList","/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
    		AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    		reloadSelf();
      	}
	}
	
	<%/*~[Describe=��������;]~*/%>
	function exportFile(){
    	OpenPage("/AppConfig/Document/ExportFile.jsp","_self","");
	}

	my_load(2,0,'myiframe0');
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>