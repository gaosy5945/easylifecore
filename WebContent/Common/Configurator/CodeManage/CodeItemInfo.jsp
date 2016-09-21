<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content: ���������
	 */
	//�������
	String sDiaLogTitle = "";
	String sCodeNo =  CurPage.getParameter("CodeNo"); //������
	String sItemNo =  CurPage.getParameter("ItemNo"); //��Ŀ���
	String sCodeName =  CurPage.getParameter("CodeName");
	//����ֵת��Ϊ���ַ���
	if(sCodeNo == null) sCodeNo = "";
	if(sItemNo == null) sItemNo = "";
	if(sCodeName == null) sCodeName = "";
	
	if(sCodeNo.equals("")){
		sDiaLogTitle = "�� ������������� ��";
	}else{
		if(sItemNo==null || sItemNo.equals("")){
			sItemNo="";
			sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"����������";
		}else{
			sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"���鿴�޸�����";
		}
	}

	ASObjectModel doTemp = new ASObjectModel("CodeItemInfo");
	if(!sCodeNo.equals("")){
		doTemp.setVisible("CodeNo",false); 
	}else{
		doTemp.setRequired("CodeNo",true);
	} 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow(sCodeNo+","+sItemNo);
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()","","","",""},
		{"true","","Button","���沢����","���������","saveAndNew()","","","",""}			
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
		if(bIsInsert){
			if(!validate()) return;
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndNew(){
		saveRecord("newRecord()");
	}
   
	function newRecord(){
        OpenComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","_self");
	}
	setDialogTitle("<%=sDiaLogTitle%>");
	
	function validate(){
    	var sCodeNo = getItemValue(0, getRow(0), "CodeNo");
    	var sItemNo = getItemValue(0, getRow(0), "ItemNo");
    	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.sys.bizlet.CodeCreditAction", "checkCodeLibrary", "CodeNo="+sCodeNo+",ItemNo="+sItemNo);
    	//var sResult = AsControl.RunJavaMethodSqlca("com.amarsoft.app.configurator.bizlets.CodeCatalogAction", "validate", "CodeNo="+sCodeNo+",OldCodeNo="+sOldCodeNo);
    	if(result != "true"){
    		alert(result.split("@")[1]);
    		return false;
    	}
    	return true;
    }
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
    
    function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		initRow();
	});
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>