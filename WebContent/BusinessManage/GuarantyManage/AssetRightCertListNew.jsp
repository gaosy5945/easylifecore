 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	String PG_TITLE = "ѺƷȨ֤�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";
	String docFlag = CurPage.getParameter("DocFlag");
	if(docFlag == null)docFlag = "";
	String mode = CurPage.getParameter("Mode");
	if(mode == null)mode = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("AssetSerialNo", assetSerialNo);
	inputParameter.setAttributeValue("DocFlag", docFlag);
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("AssetRightCertList1Temp", inputParameter,CurPage);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
	//�����һ�����ϳ��������в鿴ѺƷ���鲻������,����ɾ�� ����Ȩ��
	if("DocType".equals(docFlag)){
			 sButtons[0][0] = "false";
			 sButtons[1][0] = "false";
			 sButtons[2][0] = "false";
	} 
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var clrSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.dwhandler.QueryAssetSerialNo", "queryAssetSerialNo", "AssetSerialNo="+"<%=assetSerialNo%>");
		if(clrSerialNo == "No"){
			alert("���ȱ���ѺƷ��Ϣ��");
			return;
		}
		AsControl.OpenView("/BusinessManage/GuarantyManage/AssetRightCertInfoNew.jsp","SerialNo=&AssetSerialNo=<%=assetSerialNo%>&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
	}
	function edit(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("��ѡ��һ��ѺƷ��Ϣ��");
			return;
		}
		AsControl.OpenView("/BusinessManage/GuarantyManage/AssetRightCertInfoNew.jsp","SerialNo="+SerialNo+"&AssetSerialNo=<%=assetSerialNo%>&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
	}
	function del(){
		var serialno = getItemValue(0,0,"SerialNo");
		if(typeof(serialno)=="undefined" || serialno.length == 0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
