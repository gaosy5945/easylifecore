<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>
 <style>
 /*ҳ��С����ʽ*/
.list_div_pagecount{
	font-weight:bold;
}
/*�ܼ���ʽ*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%
	//���ղ���
	String serialNo = DataConvert.toString(CurComp.getParameter("SerialNo"));//��Ŀ��ˮ��
	if(serialNo == null) serialNo = "";
	String taskSerialNo = DataConvert.toString(CurComp.getParameter("TaskSerialNo"));//���ܷ���������ˮ�ţ�������ز�һ��
	String agreementNo = Sqlca.getString(new SqlObject("select AgreementNo from prj_basic_info where serialno = :SerialNo").setParameter("SerialNo", serialNo));
	if(agreementNo == null) agreementNo = "";
	String showExportButton = DataConvert.toString(CurComp.getParameter("ShowExportButton"));//����������ͨ������չʾ��һ��
	ASObjectModel doTemp = new ASObjectModel("ProjectAssetCountList");
	doTemp.appendJboWhere(" and O.PROJECTSERIALNO = '"+serialNo+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ShowSummary = "1";
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("serialNo");
	
	String sButtons[][] = {
		{"true","All","Button","�ʲ�����","�ʲ�����","assetImport()","","","","",""},
		{"true","","Button","�ʲ���ϸ","�ʲ���ϸ","assetDetail()","","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	/* //�ʲ����� */
	function assetImport(){
		if('<%=agreementNo%>' == ""){
			alert("���ȱ�����Ŀ������Ϣ��");
			return;
		}
	    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "clazz=jbo.import.excel.ASSET_IMPORT&ProjectSerialno="+'<%=serialNo%>';
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	
	//�ʲ���ϸ
	function assetDetail(){
		var serialNo = '<%=serialNo%>';
		var belongOrgID = getItemValue(0,getRow(),"BELONGORGID");
		var sUrl = "/AssetTransfer/ProjectAssetRelaSonList.jsp";
		AsControl.OpenPage(sUrl,"SerialNo="+serialNo+"&BelongOrgID="+belongOrgID,"_self");
	}
	
</script>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
