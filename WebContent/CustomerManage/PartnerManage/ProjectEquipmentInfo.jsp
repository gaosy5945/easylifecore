<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");//������Ŀ���
	String PSerialNo = CurPage.getParameter("PSerialNo");//�ʲ�������ˮ��
	
	String sTempletNo = "ProjectEquipmentInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(PSerialNo);
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
			{"false","All","Button","�ݴ�","�ݴ�","saveTemp()","","","",""},
			{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	/**��������	 */
	function saveRecord(){
			setItemValue(0,0,"TempSaveFlag","0");
			as_save(0);
	}
	/*�ݴ�*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	/*�����б�*/
	function returnList(){
		OpenPage("/CustomerManage/PartnerManage/ProjectEquipmentList.jsp", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
