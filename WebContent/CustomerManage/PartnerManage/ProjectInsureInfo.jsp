<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	String serialNo = CurPage.getParameter("SerialNo");//������Ŀ���
	String PSerialNo = CurPage.getParameter("PSerialNo");//�ʲ�������ˮ��

	String sTempletNo = "ProjectInsureInfo";//ģ���
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
			//setItemValue(0,0,"TempSaveFlag","0");
			as_save(0);
	}
	/*�ݴ�*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	/*�����б�*/
	function returnList(){
		OpenPage("/CustomerManage/PartnerManage/ProjectInsureList.jsp", "_self");
	}
	function selectOrg(){
		var returnValue = setObjectValue("SelectAllOrgMulti","","",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "_CLEAR_"){
			return;
		}
		returnValue = returnValue.split("~");
		var orgNo= "",orgName="";
		for(var i = 0 ; i < returnValue.length -1 ; i++){
			var orgValue = returnValue[i].split("@");
			orgNo += orgValue[0] +",";
			orgName += orgValue[1] +",";
		}
		//alert(orgNo+","+orgName);
		setItemValue(0,0,"OrgList",orgNo);
		setItemValue(0,0,"OrgListName",orgName);
	}
	
	/*��ʼ��*/
	function initRow(){
		var serialNo = getItemValue(0,0,"SerialNo");
		if(serialNo==""){
			setItemValue(0,0,"ProjectNo","<%=serialNo%>");
			setItemValue(0,0,"CustomerID","<%=customerID%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
