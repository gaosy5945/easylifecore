<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>

<%
	//���ղ���
	String tempNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//ģ���
	String InspectType = DataConvert.toString(CurPage.getParameter("InspectType"));//�������
	if(InspectType==null) InspectType="";
	//tempNo="LoanBillCheckReport";
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	
	String objectType = "";
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(" select CL.ITEMDESCRIBE from CODE_LIBRARY CL where CL.CODENO = 'InspectObjectType' AND CL.ITEMNO =:ITEMNO").setParameter("ITEMNO", InspectType));
    
	if(rs.next())
    {
		objectType = rs.getString("ITEMDESCRIBE");
    }
    rs.close();
    
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setParameter("InspectType", InspectType);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("ObjectType", objectType);
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

function Export(){
	if(s_r_c[0] > 1000){
		alert("���������������������1000���ڡ�");
		return;
	}
	as_defaultExport();
}

function view(){
	 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
	 var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
	 var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
	 var putOutDate = getItemValue(0,getRow(0),'PUTOUTDATE');
	 var creditInspectType = "<%=InspectType%>";
	
	 var sRightType="ReadOnly";
	 
	 var customerID = getItemValue(0, getRow(0), 'CustomerID');

	 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("��������Ϊ�գ�");
		return ;
	 }
	 if(creditInspectType == "02"){
		 AsCredit.openFunction("FundPurposeInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }else if(creditInspectType == "03"){
		 AsCredit.openFunction("RunDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }else if(creditInspectType == "05"){
		 var projectType = getItemValue(0, getRow(0), 'ProjectType');
		 var objectType = "jbo.prj.PRJ_BASIC_INFO";
		 AsCredit.openFunction("HandDirectionInfo","ProjectType="+projectType+"&CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&ObjectNo="+duebillSerialNo+"&ObjectType="+objectType+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }else {
		 var objectType = "jbo.prj.PRJ_BASIC_INFO";
		 AsCredit.openFunction("PrjCusCheckList","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&ObjectNo="+duebillSerialNo+"&ObjectType="+objectType+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }
}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
