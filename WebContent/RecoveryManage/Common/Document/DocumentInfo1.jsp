<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�ĵ�������Ϣ
		Input Param:
		     ObjectNo: ������
             ObjectType: ��������
             DocNo: �ĵ����
	 */
	String PG_TITLE = "�ĵ�������Ϣ";
	//�������
	String sObjectNo = "";//--������
	//����������
	String sObjectType = CurPage.getParameter("ObjectType");
	String sRightType = CurPage.getParameter("RightType");//Ȩ��
	if(sRightType == null) sRightType = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = CurPage.getParameter("CustomerID");
	else
		sObjectNo=  CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	//���ҳ��������ĵ���ź��ĵ�¼����ID
	String sDocNo = CurPage.getParameter("DocNo");
	String sUserID = CurPage.getParameter("UserID");
	if(sDocNo == null) sDocNo = "";
	if(sUserID == null) sUserID = "";

	ASDataObject doTemp = new ASDataObject("DocumentInfo",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//dwTemp.setEvent("AfterInsert","!DocumentManage.InsertDocRelative(#DocNo,"+sObjectType+","+sObjectNo+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(CurUser.getUserID().equals(sUserID)?"true":"false"),"","Button","����","���������޸�","saveRecord()","","","",""},
		{(CurUser.getUserID().equals(sUserID)?"true":"false"),"","Button","�鿴/�޸ĸ���","�鿴/�޸�ѡ���ĵ���ص����и���","viewAndEdit_attachment()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	function saveRecord(sPostEvents){
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	<%/*~[Describe=�鿴��������;]~*/%>
	function viewAndEdit_attachment(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		var sUserID = getItemValue(0,getRow(),"UserID");//ȡ¼����ID
		var sRightType="<%=sRightType%>";
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
        	alert("���ȱ����ĵ����ݣ����ϴ�������");  //��ѡ��һ����¼��
			return;
    	}else{
    		//popComp("AttachmentList","/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
			AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    		reloadSelf();
		}
	}

	function goBack(){
		OpenPage("/RecoveryManage/Common/Document/DocumentList.jsp","_self","");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"DocNo",getSerialNo("DOC_LIBRARY","DocNo"));
		bIsInsert = false;
	}

	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=��Ч�Լ��;ͨ��true,����false;]~*/
	function ValidityCheck(){
		//У����������Ƿ���ڵ�ǰ����
		var sDocDate = getItemValue(0,0,"DocDate");//��������
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����
		if(typeof(sDocDate) != "undefined" && sDocDate != "" ){
			if(sDocDate > sToday){
				alert(getBusinessMessage('161'));//�������ڱ������ڵ�ǰ���ڣ�
				return false;
			}
		}
		return true;
	}

	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"DocImportance","01");
			setItemValue(0,0,"DocDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>