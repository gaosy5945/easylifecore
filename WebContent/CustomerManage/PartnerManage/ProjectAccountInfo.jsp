<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNoAcc");//�˻�����ˮ��
	if(serialNo==null) serialNo = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo==null) objectNo ="";
	
	String sTempletNo = "ProjectAccountInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("ObjectNo", objectNo);
	doTemp.setDefaultValue("ObjectType", "Project");
	doTemp.setDefaultValue("Status", "1");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","All","Button","����","�����б�ҳ��","goback()","","","",""},
			{"false","All","Button","�ݴ�","�ݴ�","saveTemp()","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	/**��������	 */
	function saveRecord(){
			//setItemValue(0,0,"TempSaveFlag","0");
			as_save(0,"goback();");
	}
	/*�ݴ�*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	
	function goback(){
		OpenPage("/CustomerManage/PartnerManage/ProjectAccountList.jsp?ObjectNo=<%=objectNo%>",'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
