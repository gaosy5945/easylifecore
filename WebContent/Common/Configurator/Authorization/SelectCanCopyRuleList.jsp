<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "01";
	String orgID = CurUser.getOrgID();
	ASObjectModel doTemp = new ASObjectModel("RuleSceneGroupList");
	if("01".equals(authorizeType)){
		doTemp.setJboWhereWhenNoFilter("exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = O.InputOrgID and OB.BelongOrgID = :BELONGORG) and STATUS='1' and AuthorizeType = '01'");
	}else{
		doTemp.setJboWhereWhenNoFilter("exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = O.InputOrgID and OB.BelongOrgID = :BELONGORG) and STATUS='1' and AuthorizeType = '02'");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("AuthorizeType", authorizeType);
	dwTemp.setParameter("BELONGORG", orgID);
	dwTemp.genHTMLObjectWindow(authorizeType+","+orgID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","edit()","","","","",""},
			{"true","","Button","ȷ��","ȷ��","returnlist()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		if(typeof(recordArray) != 'undefined' && recordArray.length > 1){
			alert("�鿴����ʱֻ��ѡ��һ����¼�������������Ҫ�鿴�ļ�¼��");
			return;
		}
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		var authorizeType = "<%=authorizeType%>";
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		 }
		AsControl.PopView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthorizeType="+authorizeType+"&AuthSerialNo="+serialNo+"&RightType=ReadOnly","dialogWidth:800px;dialogHeight:620px;resizable:yes;scrollbars:no;status:no;help:no");
	}
	function returnlist(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1){
			if(!confirm('ȷʵҪ������?')) return;
			for(var i = 1;i <= recordArray.length;i++){
				var ID = getItemValue(0,recordArray[i-1],"SerialNo");
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","RuleCopy","SerialNo="+ID+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
			}
		}else{
			alert("��ѡ��Ҫ���Ƶ�ģ�壡�����������Ҫ���Ƶļ�¼ǰ��ķ���");
			return;
		}
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
