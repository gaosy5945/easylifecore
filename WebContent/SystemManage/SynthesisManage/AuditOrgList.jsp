<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�����Ͽ�������������";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AuditOrgList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo, Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request, iPostChange);
	CurPage.setAttribute("FilterHTML", doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for (int i = 0; i < vTemp.size(); i++) out.print((String) vTemp.get(i));

	String sButtons[][] = {
		{"true", "", "Button", "����", "����һ����¼", "newRecord()",	"","","",""},
		{"true", "", "Button", "����", "�鿴/�޸�����","viewAndEdit()", "","","",""},
		{"true", "", "Button", "ɾ��", "ɾ����ѡ�еļ�¼","deleteRecord()", "","","",""}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord() {
		OpenPage("/SystemManage/SynthesisManage/AuditOrgInfo.jsp", "_self", "");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord() {
		sSerialNo = getItemValue(0, getRow(), "SerialNo");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0"); //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit() {
		sSerialNo = getItemValue(0, getRow(), "SerialNo");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenPage("/SystemManage/SynthesisManage/AuditOrgInfo.jsp?SerialNo="+ sSerialNo, "_self", "");
	}

	AsOne.AsInit();
	init();
	my_load(2, 0, 'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>