<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zqliu
		Tester:
		Content:��ծ�ʲ������ܽ����
		Input Param:
			SerialNo����ծ�ʲ���ˮ��
			Type������
		Output param:	
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ���ֵ�����ܽ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������
	String  sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	
	String sAssetSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetSerialNo"));	
	//����ֵת��Ϊ���ַ���
	if (sType == null) sType = "";	
	if(sSerialNo == null ) sSerialNo = "";
	if(sAssetSerialNo == null ) sAssetSerialNo = "";
	
%>
<%/*~END~*/%>
	

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDADisposalEndInfo";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform

	if (sType.equals("1"))  //ִ�д����ս�,��д
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	else					//�鿴������Ϣֻ��
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	double JUDGEPAYSUM = 0;
	sSql = " select lb.JUDGEPAYSUM from LAWCASE_BOOK lb where lb.LAWCASESERIALNO=:SerialNo  and lb.BOOKTYPE='310'";
	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		JUDGEPAYSUM=rs.getDouble(1);	
	}
	rs.getStatement().close(); 
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
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
				{"true","All","Button","�������","���������޸�","saveRecord()","","","",""},
				{"true","","Button","�ر�","�رձ�ҳ��","goBack()","","","",""}
			};
		//����sType�Ĳ�ͬ,�����Ƿ���ʾbutton
		if (sType.equals("1"))  sButtons[0][0]="true";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sType = "<%=sType%>";
		//����Ǵ�AppDisposingList�е��ã�����ִ�д����ܽᣬ���һ��ܡ������ط����ö��ǲ쿴���ܣ�Ҳ�����޸�������������
		if (sType == "1")  
		{
			if (confirm("��ȷ��ִ�д����ս���"))
			{
				if("<%=JUDGEPAYSUM%>" == 0) {
					beforeUpdate();
					as_save("myiframe0");		
				}else {
					alert("ֻ�е���Ŀ���Ϊ0ʱ����ծ�ʲ��ſ��Ա������ս�");
				}
			}
		}else   //���Ѿ��ս���ʲ������ܣ����ܻ��޸�������������
		{
			beforeUpdate();
			as_save("myiframe0");		
		}
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{				
		var sType = "<%=sType%>";
		if (sType == "1")  		
			setItemValue(0,0,"Status","03");//�����ս�
	}	

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		var sType = "<%=sType%>";
		//if (sType == "1")  //�����ս�
		//	setItemValue(0,0,"PigeonholeDate","<%=StringFunction.getToday()%>");
		//ͳ�������Ϣ
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndStatisticsAjax.jsp?ObjectNo=<%=sSerialNo%>&ObjectType=AssetInfo&AssetSerialNo=<%=sAssetSerialNo%>","","");
		sReturn = sReturn.split("@");
		
		//�ʲ����˼�ֵ
		setItemValue(0,0,"EnterValue",amarMoney(sReturn[0],2));
		//ͳ���ۼƳ�����ս��
		setItemValue(0,0,"TotalRentValue",amarMoney(sReturn[1],2));
		//ͳ���ۼƳ��ۻ��ս��
		setItemValue(0,0,"TotalSaleValue",amarMoney(sReturn[2],2));
		//ͳ���ۼƷ���֧���ܶ�
		setItemValue(0,0,"TotalFeeValue",amarMoney(sReturn[3],2));
		//ͳ�ƴ�������
		setItemValue(0,0,"TotalNetValue",amarMoney(sReturn[4],2));
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

