<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String prjSerialNo = CurComp.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

    String sTempSaveFlag = "" ;//�ݴ��־
	String sTempletNo = "ProjectInsuranceInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("OBJECTNO", prjSerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","as_save(0)","","","","btn_icon_save",""},
			{"0".equals(sTempSaveFlag)?"false":"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	function initRow(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"OBJECTTYPE","jbo.prj.PRJ_BASIC_INFO");
			setItemValue(0,0,"OBJECTNO","<%=prjSerialNo%>");
		}else{
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		}
	}
	initRow();

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
