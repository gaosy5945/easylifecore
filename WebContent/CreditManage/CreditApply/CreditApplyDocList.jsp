<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String PG_TITLE = "�ؼ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	��������ˮ�š��������͡������š�ҵ�����͡��ͻ����͡��ͻ�ID
	
	String templateNo = CurPage.getParameter("TemplateNo");
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String businessType = CurPage.getParameter("BusinessType");
	
	//����ֵת���ɿ��ַ���
	if(templateNo == null) templateNo = "";	
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	if(businessType == null) businessType = "";
	
	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","",""},	
		{"true","","Button","����","����","saveRecord()","","","",""},	
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
			as_save("myiframe0");
	}
	
	function add(){
		
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "";//����
		var sColumnName = "";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){

    }

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>