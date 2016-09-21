<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String EdocNo = DataConvert.toString(CurPage.getParameter("EdocNo"));//�ļ����
	String FullPathFmt = Sqlca.getString("select FULLPATHFMT from pub_edoc_config where EdocNo = '"+EdocNo+"'").toString();
	String sTempletNo = Sqlca.getString("select LISTTEMPLETNO from pub_edoc_config where EdocNo = '"+EdocNo+"'").toString();
	String ObjectType = Sqlca.getString(new SqlObject("select ad.Jboclass from awe_do_catalog ad where ad.dono = :DONO").setParameter("DONO", sTempletNo));
	String businessDate = com.amarsoft.app.base.util.DateHelper.getBusinessDate();
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	if(("3023".equals(EdocNo))){
		doTemp.setJboFrom("O,jbo.app.BUSINESS_APPROVE bap");
		doTemp.setJboWhere("O.serialno = bap.APPLYSERIALNO");
	}else if("3007".equals(EdocNo)){//����������
		doTemp.appendJboWhere(" and ats.transactioncode = '0020'");
	}else if("3021".equals(EdocNo)){//��ǰ����
		doTemp.appendJboWhere(" and ats.transactioncode = '0010'");
	}else if("3012".equals(EdocNo)){//ר��ת���ý�
		doTemp.appendJboWhere(" and ats.transactioncode = '0155'");
	}
	if("3024".equals(EdocNo)){
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.InputOrgID) ");
	}else if("3014".equals(EdocNo)){//�ſ������ֻ���Ϻ����м������������鿴
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
		+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.OperateOrgID and exists(select 1 from jbo.sys.ORG_BELONG OB1 "+
		" where OB1.ORGID = '9800' and OB1.BelongOrgID = O.OperateOrgID)) ");
	}else{
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
			+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.OperateOrgID) ");
	}
	doTemp.setJboWhereWhenNoFilter(" and 1=2"); 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "1";
	dwTemp.setParameter("BusinessDate", businessDate);
	dwTemp.genHTMLObjectWindow("");
	

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{!("3022".equals(EdocNo)||"3021".equals(EdocNo)||"3007".equals(EdocNo)||"3001".equals(EdocNo)||"3010".equals(EdocNo))?"true":"false","All","Button","��ӡ","��ӡ","print()","","","","",""},
			{("3022".equals(EdocNo))?"true":"false","All","Button","��ӡ","��ӡ","printBusinessApprove()","","","","",""},
			{("3021".equals(EdocNo)||"3007".equals(EdocNo))?"true":"false","All","Button","��ӡ","��ӡ","AdvRepay()","","","","",""},
			{("3001".equals(EdocNo)||"3010".equals(EdocNo))?"true":"false","All","Button","��ӡ","��ӡ","NDHKPrint()","","","","",""},
			{"true","All","Button","��ѯ��ӡ��¼","��ѯ��ӡ��¼","searchLog()","","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function print(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.AfterLoanPrintInsertRecord","insertPrintRecord",
				"SerialNo="+serialNo+",ObjectType="+objectType+",EdocNo="+'<%=EdocNo%>'+",UserId="+'<%=CurUser.getUserID()%>'+
				",OrgId="+'<%=CurOrg.getOrgID()%>');  
		AsControl.OpenView('<%=FullPathFmt%>',"SerialNo="+serialNo,"_blank");
	}
	
	function AdvRepay(){
		var serialNo = getItemValue(0,getRow(),"RELATIVEOBJECTNO");
		var transSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		if (typeof(transSerialNo)=="undefined" || transSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.AfterLoanPrintInsertRecord","insertPrintRecord",
				"SerialNo="+serialNo+",ObjectType="+objectType+",EdocNo="+'<%=EdocNo%>'+",UserId="+'<%=CurUser.getUserID()%>'+
				",OrgId="+'<%=CurOrg.getOrgID()%>');  
		AsControl.OpenView('<%=FullPathFmt%>',"SerialNo="+serialNo+"&TransSerialNo="+transSerialNo,"_blank");
	}
	
	function NDHKPrint(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		var edocNo = '<%=EdocNo%>';
		var fullPathFmt = '<%=FullPathFmt%>';
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.AfterLoanPrintInsertRecord","insertPrintRecord",
				"SerialNo="+serialNo+",ObjectType="+objectType+",EdocNo="+'<%=EdocNo%>'+",UserId="+'<%=CurUser.getUserID()%>'+
				",OrgId="+'<%=CurOrg.getOrgID()%>');  
		AsControl.PopPage("/CreditManage/CreditChange/NDHKImportDate.jsp","SerialNo="+serialNo+"&EdocNo="+edocNo+"&FullPathFmt="+fullPathFmt,"dialogWidth:25;dialogHeight:18;resizable:yes;scrollbars:no;status:no;help:no","");
	}
	
	function printBusinessApprove(){
		var BusinessType = getItemValue(0,getRow(0),'BUSINESSTYPE');
		var serialNo = getItemValue(0,getRow(0),'SERIALNO');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		if(typeof(BusinessType) == "undefined" || BusinessType.length == 0){
			alert("������ƷΪ�գ�");//������Ʒ����Ϊ�գ�
			return;
		} 
		var PRODUCTTYPE3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType"
				,"ProductID="+BusinessType);
		
		if(PRODUCTTYPE3 == "01" && BusinessType != "555" && BusinessType != "999"){ 
			AsCredit.openFunction("PrintConsumeLoanApprove","SerialNo="+serialNo);//������������������
		}else if(PRODUCTTYPE3 == "02"){
			AsControl.OpenView("/BillPrint/BusinessApprove.jsp","SerialNo="+serialNo,"_blank");//��Ӫ��������������
		}else if(BusinessType == "555" || BusinessType == "999"){
			AsControl.OpenView("/BillPrint/ApplyDtl1For555.jsp","SerialNo="+serialNo,"_blank");//�������Ŷ�ȴ������������
		}
	}
	
	function searchLog(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var objectType = '<%=ObjectType%>';
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/CreditManage/CreditChange/AfterLoanPrintDetail.jsp","ObjectNo="+serialNo+"&ObjectType="+objectType,"_blank");
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
