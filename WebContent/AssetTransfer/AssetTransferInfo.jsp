<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>
<%
	//����
	String sProjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//��Ŀ���
	String sAssetProjectType = DataConvert.toString(CurPage.getParameter("AssetProjectType"));//��Ŀ����

	String viewID = CurPage.getParameter("ViewID");
	if(viewID == null) viewID = "001";
	
	String sTempletNo = "AssetTransferInfo";//��Ŀת����Ϣģ���
	if(AssetProjectCodeConstant.AssetProjectType_020.equals(sAssetProjectType)){
		sTempletNo = "AssetTransfereeInfo";//��Ŀ������Ϣģ���
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	if(viewID.equals("002"))
		dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sProjectNo);
	dwTemp.replaceColumn("AcctFee", "<iframe type='iframe' name=\"frame_list1\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("Accounts", "<iframe type='iframe' name=\"frame_list2\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("Orgs", "<iframe type='iframe' name=\"frame_list3\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{viewID.equals("002")?"false":"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"false","All","Button","����","�����б�","returnList()","","","",""}
	};
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	$(document).ready(function(){
		var objectNo = '<%=sProjectNo%>';
		var objectType = "AssetProject";
		
		AsControl.OpenView("/AssetTransfer/AcctFeeList.jsp","ObjectNo="+objectNo+"&ObjectType="+objectType,"frame_list1","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
		AsControl.OpenView("/AssetTransfer/AcctAccountsList.jsp","ObjectNo="+objectNo+"&ObjectType="+objectType,"frame_list2","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
		AsControl.OpenView("/AssetTransfer/JoinOrgsList.jsp","ObjectNo="+objectNo+"&ObjectType="+objectType,"frame_list3","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	});

	function add(){
		as_save(0);
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
