<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	//�������
	String sSql = "";	//--���sql���
	String sItemAttribute = "",sItemDescribe = "",sAttribute3 = "";//--�ͻ�����	
	String sCustomerType = "";//--�ͻ�����	
	String sTreeViewTemplet = "";//--���custmerviewҳ����ͼ��CodeNo
	ASResultSet rs = null;//--��Ž����
	int iCount = 0;//��¼��
	String sBelongGroupID = "";//�������ſͻ�ID
	//����������	,�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//ÿ���ͻ�����鿴���ԵĿͻ�ʱ�������������CUSTOMER_INFO��CUSTOMER_BELONG��CustomerID,�Լ�CUSTOMER_BELONG��UserID�����пͻ������ɫ����Աֻ���������׶ο��Բ鿴��ǰ�ͻ�����Ϣ��������������ǲ����Բ鿴�ġ�
	//�ǿͻ������λ����Ա���ӿͻ�������Ϣ���в�ѯ�����������������������е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��		
	sSql =  " select sortno||'%' from ORG_INFO where orgid=:orgid ";
	String sSortNo = Sqlca.getString(new SqlObject(sSql).setParameter("orgid",CurUser.getOrgID()));
	sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
			" where CustomerID = :CustomerID "+
			" and OrgID in (select orgid from ORG_INFO where sortno like :SortNo) "+
			" and (BelongAttribute1 = '1' "+
			" or BelongAttribute2 = '1')";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("SortNo",sSortNo));
	if(rs.next())
		iCount = rs.getInt(1);
	//�رս����
	rs.getStatement().close();
	
	//����û�û���������Ȩ�ޣ��������Ӧ����ʾ
	if( iCount  <= 0){
%>
		<script type="text/javascript">
			//�û����߱���ǰ�ͻ��鿴Ȩ
			alert( getHtmlMessage("15"));				
			top.close();
		</script>
<%
	return;//tabҳ���޷�ʹ��self.close()�رգ�����return��
	}
	
	//ȡ�ÿͻ�����
	sSql = "select CustomerType,BelongGroupID from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		//����Ǽ��ų�Ա����ȡ���������ſͻ�ID add by jgao1 2009-11-03
		sBelongGroupID  = rs.getString("BelongGroupID");
	}
	rs.getStatement().close();
	
	if(sCustomerType == null) sCustomerType = "";
	if(sBelongGroupID == null) sBelongGroupID = "";

	//ȡ����ͼģ������	
	sSql = " select ItemDescribe,ItemAttribute,Attribute2,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	if(rs.next()){
		sItemDescribe = DataConvert.toString(rs.getString("ItemDescribe"));		//�ͻ�������ͼ����
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));//�ͻ������е���ʾģ��(���ͻ�Ⱥ����)
	}
	rs.getStatement().close(); 
%>
<script type="text/javascript"> 
	AsControl.OpenView("/AppMain/resources/widget/FunctionView.jsp","FunctionID=<%=sItemDescribe%>&CustomerID=<%=sCustomerID%>","_self");
</script>
<%@ include file="/IncludeEnd.jsp"%>