<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSIGNALID = CurPage.getParameter("SIGNALID");
	if(sSIGNALID == null) sSIGNALID = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	String sTempletNo = "";
	if("01".equals(sObjectType)){
		sTempletNo = "RiskWarningConfigInfo01";//--ģ���--
    }
	if("02".equals(sObjectType)){
		sTempletNo = "RiskWarningConfigInfo02";//--ģ���--
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSIGNALID);
	String sButtons[][] = {
			//{"true","","Button","���沢����","���汾���޸ĺ���ʾ����ҳ��","saveRecord(1)","","","",""},
			{"true","","Button","����","�����޸���Ϣ","saveRecord(2)","","","",""},
			{"true","","Button","����","���ز��������б�","goBack()","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		
		if("1"==sPostEvents)
		{
			as_save("myiframe0","newRecord();");	
		}
		else{
			as_save("myiframe0");	
		}
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/BusinessManage/RiskWarningManage/RiskWarningConfigList.jsp","_self","");
	}
	
	function newRecord(){
		OpenPage("/BusinessManage/RiskWarningManage/RiskWarningConfigInfo.jsp","_self","");
	}
	//SIGNALID�ֶθ�ֵ��
	function inertSignalNo(){
		var serialNo = "<%=serialNo%>";
		if(typeof(serialNo) != "undefined" && serialNo != ""){
			
			setItemValue(0,getRow(),"SIGNALID","<%=serialNo%>");
		}
	}
	
 	$(document).ready(function(){

 		inertSignalNo();
 	});
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
