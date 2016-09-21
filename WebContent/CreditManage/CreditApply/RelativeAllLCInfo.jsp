<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Describe: �������֤��Ϣ,����鸶������Ϣ,���ó�׵�����Ϣ����ҳ��
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
			SerialNo:	��ˮ��
	 */
	String PG_TITLE = "�������֤��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
	String sObjectType = CurComp.getParameter("ObjectType");
	String sObjectNo = CurComp.getParameter("ObjectNo");
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	//���ҳ�����	
	String sSerialNo    = CurPage.getParameter("SerialNo");
	String sTemplet    = CurPage.getParameter("Templet");
	if(sSerialNo == null ) sSerialNo = "";
	if(sTemplet == null ) sTemplet = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sTemplet;
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		if("<%=sTemplet%>" == "CKLCInfo"){
		    OpenPage("/CreditManage/CreditApply/RelativeLC2List.jsp","_self","");
		}
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		//�ж�Զ���Ƿ�����
	    var slcterm = getItemValue(0,getRow(),"lcterm");
	    var sFlag1 = getItemValue(0,getRow(),"Flag1");
	    var sLCType = getItemValue(0,getRow(),"LCType");
	    if(sLCType != "01" && sLCType != "" && typeof(sLCType) != "undefined"){
		    if(typeof(slcterm) == "undefined" || slcterm == ""){
		       	alert(getBusinessMessage('492'));//ѡ��Զ������֤����ʱ��������Զ������֤��������(��)��
		        return false;
		    }
		    if(typeof(sFlag1) == "undefined" || sFlag1 == ""){
		        alert(getBusinessMessage('493'));//ѡ��Զ������֤����ʱ��������Զ������֤�Ƿ��ѳжң�
		        return false;
		    }
	    }
		return true;
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��������/����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		setObjectValue("SelectCode",sParaString,"@IssueState@0@IssueStateName@1",0,0,"");
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "LC_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	initRow();
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>