<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "δ��������ҵ���б�";
	//���ҳ�����
	String whereCondition = "";
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	
	if(sCustomerID==null) sCustomerID="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CustomerLoanAfterList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String sWhere = "BC.PigeonholeDate is not null and BC.PigeonholeDate <> ' ' and (BC.FinishDate = ' ' or BC.FinishDate is null)"
			   +" and BC.BusinessType in (select BT.TypeNo from BUSINESS_TYPE BT where BT.OffSheetFlag in ('IndOn', 'IndOff', 'EntOn', 'EntOff') )";
	//add by wmzhu date:2014/04/22
	if("04".equals(sCustomerType)){//�ͻ�Ⱥʱ,��ʾ���ǿͻ�Ⱥ��Ա���ҵ����Ϣ
		doTemp.FromClause += ",GROUP_MEMBER_RELATIVE GM";
		sWhere = "where BC.CustomerID=GM.MemberCustomerID and GM.GROUPID='"+sCustomerID+"' and " + sWhere;
		doTemp.setVisible("CustomerName", true);//��Ա����
	}else{
		sWhere = "where BC.CustomerID='"+sCustomerID+"' and " + sWhere;
	}
	
	doTemp.WhereClause += sWhere;

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	dwTemp.ShowSummary = "1";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
 
	String sButtons[][] = {
		{"true","","Button","����","�鿴δ��������ҵ������","viewAndEdit()","","","",""}
    };
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=AfterLoan&ObjectNo="+sSerialNo+"&ViewID=002";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init_show();
	my_load_show(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
