<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//���ղ���
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//ģ���
	String ObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//��������
	if(ObjectType==null) ObjectType="";
	String  ObjectNo= DataConvert.toString(CurPage.getParameter("ObjectNo"));//������
	if(ObjectNo==null) ObjectNo="";
	String RightType=DataConvert.toString(CurPage.getParameter("RightType"));//����Ȩ��
	if(RightType==null) RightType="All";
	tempNo="LoanBillCheckReport";
	String sColString="";
	String sql=" SELECT CR.OBJECTNO FROM CONTRACT_RELATIVE CR "+
			" where CR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' AND CR.CONTRACTSERIALNO ='"+ObjectNo+"' "+
			" and CR.RELATIVETYPE in('07') UNION SELECT CR.CONTRACTSERIALNO  "+
			" FROM CONTRACT_RELATIVE CR  "+
			" where CR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' AND CR.OBJECTNO ='"+ObjectNo+"' "+
			" and CR.RELATIVETYPE in('07') ";
	ASResultSet rs=Sqlca.getASResultSet(sql);
	while(rs.next()){
		sColString+="'"+rs.getString(1)+"',";
	}
	rs.getStatement().close();
	sColString="".equals(sColString)?"''":sColString.substring(0, sColString.length()-1);

	ASObjectModel doTemp = new ASObjectModel(tempNo);
	String sWhereSql="";
	if("jbo.app.CONTRACT_RELATIVE".equals(ObjectType)){
		sWhereSql=" and BC.SERIALNO IN ( "+sColString+") ";
		doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=1 ");//	
	}else{
		doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");//	
		//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");//	
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql );
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","view()","","","","",""},
			{"true","","Button","����","����Excel","Export()","","","",""},
			//{"true","","Button","��ʷǩ�����","��ʷǩ�����","opinionLast()","","","","",""},
		};
%> 

<script type="text/javascript">
<%-- function opinionLast(){
	var serialNo = getItemValue(0,getRow(0),'SerialNo');
	if(typeof(serialNo) == "undefined" || serialNo.length == 0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	} 
	var BusinessType = getItemValue(0,getRow(0),'BusinessType');
	var ApplySerialNo = getItemValue(0,getRow(0),'ApplySerialNo');
	var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.QueryFlowSerialNo","queryFlowSerialNo","ApplySerialNo="+ApplySerialNo);
	var returnValue = AsControl.RunASMethod("BusinessManage","QueryBusinessInfo","<%=CurUser.getUserID()%>");
	var productType3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType","ProductID="+BusinessType);
	if(productType3 == '02' && returnValue == "false"){
		alert("��û��Ȩ�޲鿴��Ӫ��������ʷǩ�������");
		return;
	}else{
		AsControl.PopView("/CreditManage/CreditApprove/CreditApproveList.jsp", "FlowSerialNo="+flowSerialNo);
	}
} --%>

function Export(){
	if(s_r_c[0] > 1000){
		alert("���������������������1000���ڡ�");
		return;
	}
	as_defaultExport();
}

function view(){
	 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
	 if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
	 }
	 var ApplySerialNo = getItemValue(0,getRow(0),'ApplySerialNo');
	 AsCredit.openFunction("LoanCheckInfoTab","SerialNo="+serialNo+"&ApplySerialNo="+ApplySerialNo,"");
}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
