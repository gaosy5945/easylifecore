<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "PTProjectBailInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
//	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	/**��������	 */
	function saveRecord(){
		as_save(0);
	}
	/**���Ƿ���Ҫ���ɱ�֤�����ж��Ƿ���Ҫ¼���˺���Ϣ*/
	function  selectFlag(){
		if(getItemValue(0,0,"BailFlag") == "1"){
			setItemRequired(0,"BailAccount",true);
			setItemRequired(0,"BailAccountOwner",true);
		}else{
			setItemRequired(0,"BailAccountOwner",false);
			setItemRequired(0,"BailAccount",false);
		}
	}
	//��ʼ���˻��Ƿ����
	selectFlag();
	AsControl.OpenView("/CustomerManage/PartnerManage/ProjectBailList.jsp","ProjectNo=<%=serialNo%>","rightdown","");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>