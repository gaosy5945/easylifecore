<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004/12/7
		Tester:
		Content:  ��������
		Input Param:
		Output param:
		History Log:  fXie 2005-03-13   ����У���ϵ���˺Ų�ѯ
		              sjchuan 2009-10-21  Ʊ��ҵ��һ�γ���������Գ����Ʊ�ݣ�������ϢTabҳΪ���·�ҳ��ʾ
		              qfang 2011-6-8 ��������ҳ���ȣ��Լ�ҳ�洫�ݵĲ���
		              gftang 2013-11-30 DW��ΪOW,����ҳ���ܲ��
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
 	
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
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
	//�����������ͬ�����ʸ���ֵ
	double dBCBusinessSum = 0.0,dRateFloat = 0.0;
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
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�ó�����Ϣ�ķ�������
	sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.PaymentMode,BC.RateFloat "+
			" from BUSINESS_CONTRACT BC "+
			" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
			" where BP.SerialNo =:SerialNo "+
			" and BP.ContractSerialNo = BC.SerialNo) ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sBCOccurType = rs.getString("OccurType");
		dRateFloat = rs.getDouble("RateFloat");
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
	
	if(sBCOccurType.equals("015")) //չ��
		sDisplayTemplet = "PutOutInfo0";
	else{
		//���ݲ�Ʒ���ʹӲ�Ʒ��Ϣ��BUSINESS_TYPE�л����ʾģ������
		sSql = " select DisplayTemplet from BUSINESS_TYPE where TypeNo =:TypeNo ";
		sDisplayTemplet = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
		if(sDisplayTemplet==null)sDisplayTemplet="";
	}
	
	//�ӳ��˱����ݴ��־
	sSql = "select TempSaveFlag from " + sMainTable + " where SerialNo=:SerialNo";
	sTempSaveFlag = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel(sDisplayTemplet,"");
	//���ø�ʽ,����С����4λ
// 	doTemp.setCheckFormat("RateFloat,BackRate,RiskRate","14");
	//�������ʸ�ʽ,����С����6λ
// 	doTemp.setCheckFormat("BaseRate,BusinessRate","16");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����ObjectWindow
	dwTemp.genHTMLObjectWindow(sObjectNo);
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","",""},		
			{"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""},
			{"true","All","Button","����ƻ���ѯ","����ƻ���ѯ","Simulation('"+sObjectType+"','"+sObjectNo+"')",""}
		};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
	if(sTempSaveFlag.equals("0"))
		sButtons[1][0] = "false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		setItemValue(0,getRow(),"TempSaveFlag","0"); //�ݴ��־��1���ǣ�0����			
		as_save("myiframe0");
	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp(){
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�0����
		as_saveTmp("myiframe0");   //�ݴ�
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		//��������
		sOccurType = "<%=sBCOccurType%>";
		//��ͬ�׶����ʸ���ֵ
		dRateFloat = "<%=dRateFloat%>";
		//������ʼ��
		sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		//���ʵ�����
		sMaturity = getItemValue(0,getRow(),"Maturity");	
		//ҵ��Ʒ��
		sBusinessType = getItemValue(0,getRow(),"BusinessType");		
		if(typeof(sPutOutDate) != "undefined" && sPutOutDate != "" && typeof(sMaturity) != "undefined" && sMaturity != ""){			
			//��ͬҵ��Ʒ��
			sBCBusinessType = "<%=sBCBusinessType%>";
			//��ͬ��ʼ��
			sBCPutOutDate = "<%=sBCPutOutDate%>";
			//��ͬ������
			sBCMaturity = "<%=sBCMaturity%>";	
			//У�������ʼ���Ƿ����ں�ͬ��ʼ��			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sBCPutOutDate) != "undefined" && sBCPutOutDate != "")
			{
				if(sPutOutDate < sBCPutOutDate)
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('592'));//���ʵ�չ����ʼ�ձ������ڻ���ں�ͬ��չ����ʼ�գ�
						return false;
					}else
					{
						if(sBusinessType == '1010010'
						|| sBusinessType == '1030020' || sBusinessType == '1030030'
						|| sBusinessType == '1010020'
						|| sBusinessType == '1030010' || sBusinessType == '1080010'
						|| sBusinessType == '1080060'
						|| sBusinessType == '1080040' || sBusinessType == '1010030'
						|| sBusinessType == '1050' || sBusinessType == '1080020'
						|| sBusinessType == '1080030' || sBusinessType == '1010040'
						|| sBusinessType == '2070' || sBusinessType == '1060'
						|| sBusinessType == '1040010' || sBusinessType == '1040020'
						|| sBusinessType == '1040030' || sBusinessType == '1040040') 
						//���������ʽ�������������Ŀ�����������Ŀ������������ʽ���
						//����������Ŀ�������֤���½���Ѻ�㡢����ͥ���������³���Ѻ��
						//�����ʻ�͸֧�����ز������������֤���³��ڴ���������֤���³���Ѻ�㡢������˰�ʻ��йܴ��
						//ί�д�����Ŵ�����˹�������������˰��ҡ��豸���˰��ҡ��������˰���
						{	
							alert(getBusinessMessage('593'));//���ʵ�����ձ������ڻ���ں�ͬ����ʼ�գ�
							return false;								
						}else if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '11406020'|| sBusinessType == '11404030' 
						|| sBusinessType == '3030020' || sBusinessType == '11406040'
						|| sBusinessType == '11406030' || sBusinessType == '11404010'
						|| sBusinessType == '11402030' || sBusinessType == '11404020'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '2090010'|| sBusinessType == '11406010'
						|| sBusinessType == '11405020' || sBusinessType == '11401010'
						|| sBusinessType == '2080010' || sBusinessType == '11405010'
						|| sBusinessType == '2060040'	 || sBusinessType == '11407010' 
						|| sBusinessType == '2060010' || sBusinessType == '11403020'
						|| sBusinessType == '1080005'
						|| sBusinessType == '11403010' || sBusinessType == '1080007'
						|| sBusinessType == '1080410' || sBusinessType == '11402020'
						|| sBusinessType == '11402010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1080320'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1080310') 
						//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
						//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
						//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
						//�ӹ�װ��ҵ����ڱ����������������Ա��������˽���������˹��̻�е������˾�Ӫ���
						//����ס��װ�޴��������ѧ����������������������ס����������
						//������������������뷵��ҵ���м�֤ȯ���е������������
						//����С������������Ѻ��������ŵ�������˾�Ӫѭ�����
						//ת�����Ŵ�������С�����ô������ί�д������Ͷ����ҵ����
						//ת���������������˶�����ҵ�÷������������֤��
						//����һ����ҵ�÷������������֤�����������ת�����ʽ�����֯���
						//������㴢��ת������˶���ס���������ծȯת�������ת���
						//����һ��ס��������������顢�����Ŵ�֤����
						//���ڱ������ڱ���
						{
							if(sBCBusinessType == '1080005') //��������֤
							{
								alert(getBusinessMessage('594'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ�Ŀ�֤�գ�
								return false;
							}else if(sBCBusinessType == '1080410' || sBCBusinessType == '1080007' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020') 
							//�����������������֤��������������Ŵ�֤��������������
							{
								alert(getBusinessMessage('595'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ�ķ����գ�
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
							//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
							//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
							//�ӹ�װ��ҵ����ڱ����������������Ա���
							{
								alert(getBusinessMessage('597'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ����Ч���ڣ�
								return false;
							}else
							{
								alert(getBusinessMessage('598'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ����ʼ�գ�
								return false;
							}
						}else if(sBusinessType == '1090010')//��������֤
						{
							alert(getBusinessMessage('600'));//���ʵ�ҵ�����ڱ������ڻ���ں�ͬ�Ŀ�֤�գ�
							return false;
						}else if(sBusinessType == '2010')//���гжһ�Ʊ
						{
							alert(getBusinessMessage('601'));//���ʵ�ǩ���ձ������ڻ���ں�ͬ�ĳ�Ʊ�գ�
							return false;
						}
					}
				}
			}
			
			//У����ʵ������Ƿ����ں�ͬ������
			if(typeof(sMaturity) != "undefined" && sMaturity != ""
			&& typeof(sBCMaturity) != "undefined" && sBCMaturity != "")
			{
				if(sMaturity > sBCMaturity)
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('602'));//���ʵ�չ�ڵ����ձ������ڻ���ں�ͬ��չ�ڵ����գ�
						return false;
					}else
					{
						if(sBusinessType == '1010010'
						|| sBusinessType == '1030020' || sBusinessType == '1030030'
						|| sBusinessType == '1010020'
						|| sBusinessType == '1030010' || sBusinessType == '1080010'
						|| sBusinessType == '1080060'
						|| sBusinessType == '1080040' || sBusinessType == '1010030'
						|| sBusinessType == '1050' || sBusinessType == '1080020'
						|| sBusinessType == '1080030' || sBusinessType == '1010040'
						|| sBusinessType == '2070' || sBusinessType == '1060'
						|| sBusinessType == '1040010' || sBusinessType == '1040020'
						|| sBusinessType == '1040030' || sBusinessType == '1040040') 
						//���������ʽ�������������Ŀ�����������Ŀ������������ʽ���
						//����������Ŀ�������֤���½���Ѻ�㡢����ͥ���������³���Ѻ��
						//�����ʻ�͸֧�����ز������������֤���³��ڴ���������֤���³���Ѻ�㡢������˰�ʻ��йܴ��
						//ί�д�����Ŵ�����˹�������������˰��ҡ��豸���˰��ҡ��������˰���
						{	
							alert(getBusinessMessage('603'));//���ʵĵ����ձ������ڻ���ں�ͬ�ĵ����գ�
							return false;								
						}else if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '11406020'|| sBusinessType == '11404030'
						|| sBusinessType == '3030020' || sBusinessType == '11406040'
						|| sBusinessType == '11406030' || sBusinessType == '11404010'
						|| sBusinessType == '11402030' || sBusinessType == '11404020'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '2090010'|| sBusinessType == '11406010'
						|| sBusinessType == '11405020' || sBusinessType == '11401010'
						|| sBusinessType == '2080010' || sBusinessType == '11405010'
						|| sBusinessType == '2060040'	 || sBusinessType == '11407010' 
						|| sBusinessType == '2060010' || sBusinessType == '11403020'
						|| sBusinessType == '1080005'
						|| sBusinessType == '11403010' || sBusinessType == '1080007'
						|| sBusinessType == '1080410' || sBusinessType == '11402020'
						|| sBusinessType == '11402010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1080320'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1080310') 
						//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
						//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
						//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
						//�ӹ�װ��ҵ����ڱ����������������Ա��������˹��̻�е������˽�������
						//����ס��װ�޴��������ѧ����������������������ס����������
						//������������������뷵��ҵ���м�֤ȯ���е������������
						//����С������������Ѻ��������ŵ�������˾�Ӫѭ�����
						//ת�����Ŵ�������С�����ô������ί�д������Ͷ����ҵ����
						//ת���������������˶�����ҵ�÷������������֤��
						//����һ����ҵ�÷������������֤�����������ת�����ʽ�����֯���
						//������㴢��ת������˶���ס���������ծȯת�������ת���
						//����һ��ס��������������顢�����Ŵ�֤����
						//���ڱ������ڱ���
						{
							if(sBCBusinessType == '1080410' || sBCBusinessType == '1080007' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020' || sBCBusinessType == '1080005') 
							//�����������������֤��������������Ŵ�֤�������������顢��������֤
							{
								alert(getBusinessMessage('604'));//���ʵ�ʧЧ���ڱ������ڻ���ں�ͬ�ĵ����գ�
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
							//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
							//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
							//�ӹ�װ��ҵ����ڱ����������������Ա���
							{
								alert(getBusinessMessage('606'));//���ʵ�ʧЧ���ڱ������ڻ���ں�ͬ��ʧЧ���ڣ�
								return false;
							}else
							{
								alert(getBusinessMessage('604'));//���ʵ�ʧЧ���ڱ������ڻ���ں�ͬ�ĵ����գ�
								return false;
							}
						}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
						|| sBusinessType == '1020030' || sBusinessType == '1020040')
						//���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡���ҵ�жһ�Ʊ����
						{
							alert(getBusinessMessage('603'));//���ʵĵ����ձ������ڻ���ں�ͬ�ĵ����գ�
							return false;
						}else if(sBusinessType == '1090010')//��������֤
						{
							alert(getBusinessMessage('607'));//���ʵ�����֤��Ч�ڱ������ڻ���ں�ͬ������֤��Ч�ڣ�
							return false;
						}else if(sBusinessType == '2010')//���гжһ�Ʊ
						{
							alert(getBusinessMessage('608'));//���ʵĵ��ڸ����ձ������ڻ���ں�ͬ�ĵ����գ�
							return false;
						}
					}
				}
			}							
		}
		//���ʸ���ֵ 
	      sDisplayTemplet= "<%=sDisplayTemplet%>";
		if(sDisplayTemplet=="PutOutInfo1"||sDisplayTemplet=="PutOutInfo0053"||sDisplayTemplet=="PutOutInfo0010"){
			   var	sRateFloat=getItemValue(0,getRow(),"RateFloat");	
			   //�������ʸ���ֵ>��ͬ���ʸ���ֵ
			   if(sRateFloat>=100){
				   alert("���ʸ���ֵ������[-100,100]��Χ�ڣ�");
					return false;
			   }
				if(sRateFloat<dRateFloat){
					alert("�������ʸ���ֵ������ڵ��ں�ͬ���ʸ���ֵ");
					return false;
				}    
		}
	    //���ʽ��
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");	
		//��ͬ���
		dBCBusinessSum = "<%=dBCBusinessSum%>";
		//���ʣ�Ĭ��Ϊ����ң�
		var curErate = 1;
		//�ж��ۼƳ��ʽ���Ƿ��ѳ����˺�ͬ���
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBCBusinessSum) >= 0)
		{
			//��ѯ��ǰ���ֶһ�����һ���
			var curCurrencyType = getItemValue(0,0,"BusinessCurrency");
			if(curCurrencyType != "undefined" && curCurrencyType != "" && curCurrencyType != "01"){
				var sCurrencyReturn = RunMethod("PublicMethod","GetERateToRMB",curCurrencyType+","); //��ѯ���»���
				if(sCurrencyReturn > 0){
					curErate = sCurrencyReturn;
				}
			}
			///��ȡ��ͬ���¿ɳ��ʵĽ��
			//������ˮ��
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			//��ͬ��ˮ��
			var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");	
			sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sContractSerialNo+","+sSerialNo);
			if(parseFloat(sSurplusPutOutSum) > 0)
			{
				if(curErate*parseFloat(dBusinessSum) > parseFloat(sSurplusPutOutSum))
				{
					alert(getBusinessMessage('572'));//������¼��Ľ�����С�ڻ���ں�ͬ�Ŀ��ý�
					return false;
				}
			}else
			{
				alert(getBusinessMessage('573'));//��ҵ���ͬ��û�п��ý����ܽ��зŴ����룡
				return false;
			}			 
		}
		
		
		return true;
	}
	
	/*~[Describe=�����������ʻ���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getPutOutOrg()
	{		
		sParaString = "OrgID"+","+"<%=CurUser.getOrgID()%>";
		setObjectValue("SelectBelongOrg",sParaString,"@AboutBankID3@0@AboutBankID3Name@1",0,0,"");		
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{							
		setItemValue(0,0,"PaymentMode","<%=sBCPaymentMode%>");//��ʼ��֧����ʽ
	}
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	}
	
	</SCRIPT>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">

/*------------------�������JS����---------------*/
afterLoad("<%=sObjectType%>","<%=sObjectNo%>"); 
/*------------------�������JS����---------------*/
 
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>