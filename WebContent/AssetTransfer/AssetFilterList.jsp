<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sourceType = CurPage.getParameter("SourceType");
	if(StringX.isSpace(sourceType)) sourceType = "";
	String OrgId = CurUser.getOrgID();
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel("AssetFilterList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow(OrgId);
	
	String sButtons[][] = {
			{"true","","Button","ȷ��","ȷ��","doSure()","","","","",""},
			{"true","","Button","ȡ��","ȡ��","top.close()","","","","",""},
		};
	if("SELECT".equals(sourceType)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
	}
%> 
<script type="text/javascript">
	function doSure(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		var relaSerialNos = "";
		if(typeof(recordArray) != "undefined" && recordArray.length >= 1) {
			for(var i = 1;i <= recordArray.length;i++){
				var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
				relaSerialNos += serialNo+"@";
			}
			top.returnValue = relaSerialNos;
			top.close();
		}else{
			alert("��ѡ���¼");
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>