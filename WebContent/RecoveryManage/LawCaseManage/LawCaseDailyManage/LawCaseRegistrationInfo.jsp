<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zqliu 2014.11.22
		Tester:
		Content: �����Ǽ�
		Input Param:
			        SerialNo:̨�ʱ��
			        ObjectNo:������Ż��������
			        ObjectType����������
			        BookType ��̨������
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "̨����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sLawsuitStatus = "";
	
	//���ҳ�����
	//̨�ʱ�š�̨������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sBookType == null) sBookType = "";
	
	//������Ż�����š��������͡���������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sLawCaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LawCaseType"));
	String sDate = StringFunction.getToday();
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sLawCaseType == null) sLawCaseType = "";
	
	//��ö�Ӧ���������ϵ�λ�����Ϊԭ�桢�����а���δ�������Զ�����
	sSql =  " select LawsuitStatus from LAWCASE_INFO where SerialNo =:SerialNo ";
	//���е����ϵ�λ
	sLawsuitStatus = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sLawsuitStatus == null) sLawsuitStatus = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sItemdescribe = "";
	String sItemdescribe1 = "";
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//���ݲ�ͬ�İ���������ʾ��ͬ����Ч�о���
	if (sLawCaseType.equals("01"))	//һ�㰸��
		sItemdescribe1="10";
	if (sLawCaseType.equals("02"))	//��֤�ٲð���
		sItemdescribe1="20";		
	
	sTempletNo="BeforeLawsuitInfo";
	sItemdescribe = "10";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д	
	
	if(sLawsuitStatus.equals("01"))   
	{
		doTemp.setReadOnly("JudgeNoPaySum",false);//����ֻ��
	}
	
	//���ݲ�ͬ��̨�����͹���������
	doTemp.setDDDWSql("CognizanceResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CognizanceResult' and Itemdescribe like '%"+sItemdescribe+"%' ");
	
	//���ݲ�ͬ�İ������͹�����Ч�о���
	doTemp.setDDDWSql("JudgementNo","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'JudgementNo' and Itemdescribe like '"+sItemdescribe1+"%' ");
	
	//����ʱ�����¼������밸����š�̨�����ͣ�
  	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");
	
	//���±���ʱ�����¼������밸����š�̨�����ͣ�
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);	
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
			{"true","","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var sSaveFlag="FALSE";
	//---------------------���尴ť�¼�------------------------------------
		
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{

		setItemValue(0,0,"BookType","<%=sBookType%>");					
		setItemValue(0,0,"LawCaseSerialNo","<%=sObjectNo%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		as_save("myiframe0","setSaveFlag()");
		if(sSaveFlag=="TRUE"){
			self.returnValue="TRUE";
			self.close();
		}
	}
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function setSaveFlag()
	{
		sSaveFlag="TRUE";
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=ִ����������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		//initSerialNo();//��ʼ����ˮ���ֶ�		
		bIsInsert = false;
	}

	/*~[Describe=ѡ��������� --��ͬ�������������;InputParam=��;OutPutParam=��;]~*/
	function getAgencyForDepartType(DepartType){
		var sDepartType = "";
		if(DepartType==1){
			sDepartType = "01";
		}else if(DepartType==2){
			sDepartType="02";
		}else if(DepartType=3){
			sDepartType="03";
		}
		sParaString = "AgencyType,01,DepartType,"+sDepartType;
		setObjectValue("SelectAgencyForDepartType",sParaString,"@AcceptedCourt@1",0,0,"");
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;	

			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");		
			//̨������
			setItemValue(0,0,"BookType","<%=sBookType%>");					
			setItemValue(0,0,"LawCaseSerialNo","<%=sObjectNo%>");
								
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//�Ǽ�����	��������					
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "LAWCASE_BOOK";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	
 	
	</script>
	
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	self.returnValue=sSaveFlag;	//���� 
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

