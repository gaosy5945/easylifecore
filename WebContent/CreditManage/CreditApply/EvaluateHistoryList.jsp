<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "ѺƷ��ֵ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	String AssetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(AssetSerialNo == null) AssetSerialNo = "";
	String rightType = CurPage.getParameter("RightType");
	if(rightType == null) rightType = "";
	
	ASObjectModel doTemp = new ASObjectModel("EvaluateHistory");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(AssetSerialNo);
	
	String sButtons[][] = {
			{"false","","Button","����","�鿴����","viewAndEdit()","","","",""},
	};
	
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function viewAndEdit(){
		var CMISApplyNo = getItemValue(0,getRow(),"CMISApplyNo");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var assetEvaParams = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "viewEvaMethod","SerialNo="+serialNo);
		
		if(assetEvaParams == "4") {
			alert("��ѺƷΪֱ���϶���ֵ�����ܲ�ѯ������Ϣ��");
			return ;
		}
		<%-- window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+CMISApplyNo+"&pstnType=3&viewMode=1&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;"); --%>
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 