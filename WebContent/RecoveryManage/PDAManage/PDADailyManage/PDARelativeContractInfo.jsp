<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zqliu
		Tester:
		Content: ��ծ�ʲ�������ͬ��ϸ��Ϣ_info
		Input Param:
		Content: ��ծ�ʲ�������ͬ��ϸ��ϢPDABasicInfo.jsp
		Input Param:
			        SerialNo:��ծ�ʲ���ˮ��
			        ContractSerialNo����ͬ��ˮ��						
		Output param:
		
		History Log: 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�������ͬ��ծ��ϸ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";		
	String sCustomerName = "";//�ͻ�����
	String sBusinessCurrency = "";//����
	String sBusinessSum = "";//��ͬ���
	String sBalance = "";//��ͬ���
	String sBusinessType = "";//ҵ��Ʒ��
	String sAssetName = "";//�ʲ�����
	String sContractArtificialNo = "";
	ASResultSet rs = null;
	
	//����������
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sDASerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DASerialNo"));//��ծ�ʲ���ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));//��ծ�ʲ���ծ��Ϣ��ˮ��
	String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));//Ҫ�����ĺ�ͬ��			
	if(sDASerialNo == null ) sDASerialNo = "";		
	if(sSerialNo == null ) sSerialNo = "";
	if(sContractSerialNo == null ) sContractSerialNo = "";
	if(sAssetStatus == null ) sAssetStatus = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	//��ú�ͬ�����Ϣ	
	sSql = 	" select CONTRACTARTIFICIALNO,CustomerName,BusinessSum,(select bt.typeName from business_type bt where bt.typeno=businesstype)  as BusinessTypeName, "+
			" Balance,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName "+
			" from BUSINESS_CONTRACT  "+
			" where SerialNo=:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sContractSerialNo));
	if (rs.next()){
		sContractArtificialNo = rs.getString("CONTRACTARTIFICIALNO");	
		sBusinessType = rs.getString("BusinessTypeName");	
		sCustomerName = rs.getString("CustomerName");	
		sBusinessCurrency = rs.getString("BusinessCurrencyname");			
		sBusinessSum = rs.getString("BusinessSum");		
	  	sBalance=rs.getString("Balance");			
	  	if (sContractArtificialNo == null)  sContractArtificialNo = "";	
	  	if (sBusinessType == null)  sBusinessType = "";	
	  	if (sCustomerName == null)  sCustomerName = "";	
	  	if (sBusinessCurrency == null)  sBusinessCurrency = "";	
	  	if ((sBusinessSum == null) || (sBusinessSum.equals(""))) sBusinessSum="0.00";	
		if ((sBalance == null) || (sBalance.equals(""))) sBalance="0.00";
	}
	rs.getStatement().close(); 
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDAAssetContract";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+','+sContractSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","All","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","","Button","����","���ص�����ҳ��","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save(0);		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function goBack()
	{
		top.close();
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
			sSerialNo="<%=sSerialNo%>";
			sContractSerialNo="<%=sContractSerialNo%>";
			setItemValue(0,0,"SerialNo",sSerialNo);
			setItemValue(0,0,"OBJECTNO",sContractSerialNo);
			setItemValue(0,0,"OBJECTTYPE","Business_Contract");
			setItemValue(0,0,"EXPIATEAMOUNT","0.00");
			setItemValue(0,0,"PRINCIPALAMOUNT","0.00");
			setItemValue(0,0,"INTERESTAMOUNT","0.00");
			setItemValue(0,0,"OTHERAMOUNT","0.00");
			setItemValue(0,0,"UnDisposalSum","0.00");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");		
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		};

		//sContractArtificialNo = rs.getString("CONTRACTARTIFICIALNO");
		setItemValue(0,0,"ContractArtificialNo","<%=sContractArtificialNo%>");
		setItemValue(0,0,"BusinessType","<%=sBusinessType%>");
		setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
		setItemValue(0,0,"BusinessCurrency","<%=sBusinessCurrency%>");
		setItemValue(0,0,"BusinessSum","<%=sBusinessSum%>");
		setItemValue(0,0,"Balance","<%=sBalance%>");
		setItemValue(0,getRow(),"AssetName","<%=sAssetName%>");		
	    getSum();			
    }

	/*~[Describe=�����ͬ���������ϼƻ��;InputParam=��;OutPutParam=��;]~*/
    function getSum()
    {
 		fPrincipal = getItemValue(0,getRow(),"PRINCIPALAMOUNT");//����
 		fIndebtInterest = getItemValue(0,getRow(),"INTERESTAMOUNT");//��Ϣ
 		fOutdebtInterest = getItemValue(0,getRow(),"OTHERAMOUNT");//����
 		fBalance = getItemValue(0,getRow(),"Balance");//��ͬ���
     		
 		if(typeof(fPrincipal)=="undefined" || fPrincipal.length==0) fPrincipal=0; 
 		if(typeof(fIndebtInterest)=="undefined" || fIndebtInterest.length==0) fIndebtInterest=0; 
 		if(typeof(fOutdebtInterest)=="undefined" || fOutdebtInterest.length==0) fOutdebtInterest=0; 
     		
 		 var fSum = fPrincipal+fIndebtInterest+fOutdebtInterest;
 		 var sUnDSum = fBalance - fSum;
        setItemValue(0,getRow(),"EXPIATEAMOUNT",fSum);//
        setItemValue(0,getRow(),"UnDisposalSum",sUnDSum);//
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

