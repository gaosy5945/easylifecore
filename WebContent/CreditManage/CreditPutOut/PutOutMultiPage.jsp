<%@page import="com.amarsoft.app.bizmethod.BizSort"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_multi.jspf"%>
<iframe name="frame_info" width="100%" height="270" frameborder="0"></iframe>
<hr class="list_hr">
<iframe name="frame_list" width="100%" height="350" frameborder="0"></iframe>
<%@include file="/Frame/resources/include/ui/include_multi.jspf"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: gftang 2013/11/30
		Tester:
		Content:  �������� ���·�ҳ
		Input Param:
		Output param:
		History Log:  
	 */
	%>
<%/*~END~*/%>
<%
//�������������������ͺͶ�����
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo =  CurPage.getParameter("ObjectNo");
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	//���������SQL��䡢����ҵ��Ʒ�֡�������ʾģ�桢���������ݴ��־
	String sSql = "",sBusinessType = "",sDisplayTemplet = "",sMainTable = "",sTempSaveFlag="";
	//����������������͡���ͬ��ʼ�ա���ͬ�����ա���ͬҵ��Ʒ��
	String sBCOccurType = "",sBCPutOutDate = "",sBCMaturity = "",sBCBusinessType = "",sBCPaymentMode = "";
	String sContractSerialNo = "";
	//�����������ͬ���
	double dBCBusinessSum = 0.0;	
	//�����������ѯ�����
	ASResultSet rs = null;
	//���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
	sSql = 	" select ObjectTable from OBJECTTYPE_CATALOG "+
			" where ObjectType =:ObjectType ";
	sMainTable = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType));	
	
	//��ȡ����ҵ��Ʒ��
	sSql = 	" select BusinessType,ContractSerialNo from "+sMainTable+" "+
			" where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
		sContractSerialNo = rs.getString("ContractSerialNo");
	}
	rs.getStatement().close();

	//���ҵ��Ʒ��Ϊ��,����ʾ���������ʽ����
	if (sBusinessType.equals("")) sBusinessType = "1010010";
	if(sContractSerialNo.equals("")) sContractSerialNo="";
	
	//add by sjchuan 2009-10-21
	//��ҵ������Ϊ���гжһ�Ʊ��2010
	//           ���гжһ�Ʊ���֣�1020010
	//           ���гжһ�Ʊ����: 1020020
	//           Э�鸶ϢƱ������: 1020020
	//ʱ��������ϢTabҳ��Ϊ���·�ҳ��ʾ 
	String Flag = ""; //Ʊ��ҵ��ı�־����Flag = "1"ʱΪƱ��ҵ�񣬷�����Ʊ��ҵ��
	if(sBusinessType.equals("1020010") ||sBusinessType.equals("1020020")||sBusinessType.equals("1020030")|| sBusinessType.equals("2010"))
	{
		Flag = "1";
	}
	
	//��ȡ�ó�����Ϣ�ķ�������
		sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.PaymentMode "+
				" from BUSINESS_CONTRACT BC "+
				" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
				" where BP.SerialNo =:SerialNo "+
				" and BP.ContractSerialNo = BC.SerialNo) ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sBCOccurType = rs.getString("OccurType");
			sBCPutOutDate = rs.getString("PutOutDate");
			sBCMaturity = rs.getString("Maturity");
			sBCBusinessType = rs.getString("BusinessType");
			sBCPaymentMode = rs.getString("PaymentMode");
			dBCBusinessSum = rs.getDouble("BusinessSum");
			//����ֵת��Ϊ���ַ���
			if(sBCOccurType == null) sBCOccurType = "";
			if(sBCPutOutDate == null) sBCPutOutDate = "";
			if(sBCMaturity == null) sBCMaturity = "";
			if(sBCBusinessType == null) sBCBusinessType = "";
		}
		rs.getStatement().close();
	%>
<script>
//������ϢTabҳ�����·�ҳ��ʾ ���������ҵ������ΪƱ��ҵ��
if("<%=Flag%>" == "1" )
{
	var sUrl = "/CreditManage/CreditPutOut/PutOutInfo.jsp";
	AsControl.OpenView(sUrl,"ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&ApproveNeed=<%=sApproveNeed%>","frame_info","");
	if(<%=sBusinessType%>=="2010"){
		sUrl = "/CreditManage/CreditApply/BillList.jsp";
	}else{
		sUrl = "/CreditManage/CreditApply/RelativeBillList.jsp";
	}
	AsControl.OpenView(sUrl,"ObjectNo=<%=sObjectNo%>&ContractSerialNo=<%=sContractSerialNo%>&BusinessType=<%=sBusinessType%>","frame_list","");
}

//�Ŵ�����ҳ������ҳ��ʾ
else{
	var sUrl = "/CreditManage/CreditPutOut/PutOutInfo.jsp";
	AsControl.OpenView(sUrl,"ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&ApproveNeed=<%=sApproveNeed%>","_self","");
}

</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>