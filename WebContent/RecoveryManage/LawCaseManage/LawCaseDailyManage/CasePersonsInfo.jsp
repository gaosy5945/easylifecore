<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zqliu
		Tester:
		Content: ���������Ա��Ϣ
		Input Param:
			        SerialNo:��¼��ˮ��
			        ObjectNo:�������
			        PersonsType �����������Ա���
		Output param:
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������Ա��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sOrgNo = "";
	String sOrgName = "";
	String sDepartType = "";
	String sTakePartPhase = "";
	String sTakePartRole = "";
	String sCourtNo = "";//������Ժ���
	String sAcceptedCourt = "";//������Ժ����
		
	//���ҳ�����(������š���¼��ˮ�š���Ա���)
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sLPSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LPSerialNo"));
	String sPersonType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PersonType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sLPSerialNo == null) sLPSerialNo = "";
	if(sPersonType == null) sPersonType = "";

	String sObjectType = "LawcaseInfo";
	//��ð���������������Ա�������Ϣ������Ϊ�´���Ϣ�����Ĭ��ֵ
	if(sPersonType.equals("02")){
		sSql =  " select OrgNo,OrgName,DepartType,TakePartPhase,TakePartRole "+
		        " from LAWCASE_PERSONS "+
		        " where LawCaseSerialNo = :ObjectNo1 "+ 
		    	" and PersonType = :PersonType1 "+ 
		    	" and SerialNo=(select max(SerialNo) from LAWCASE_PERSONS "+
		    	" where LawCaseSerialNo = :ObjectNo2 "+
		    	" and PersonType = :PersonType2) ";
		so = new SqlObject(sSql).setParameter("ObjectNo1",sObjectNo).setParameter("PersonType1",sPersonType)
		.setParameter("ObjectNo2",sObjectNo).setParameter("PersonType2",sPersonType);
	   	rs = Sqlca.getASResultSet(so); 	   	
	   	if(rs.next()){
			//������ر�š�����������ء�����������͡�����׶Ρ������ɫ
			sOrgNo = DataConvert.toString(rs.getString("OrgNo"));
			sOrgName = DataConvert.toString(rs.getString("OrgName"));
			sDepartType = DataConvert.toString(rs.getString("DepartType"));			
			sTakePartPhase = DataConvert.toString(rs.getString("TakePartPhase"));
			sTakePartRole = DataConvert.toString(rs.getString("TakePartRole"));
		 }		 
		 rs.getStatement().close();
		 
		 //add by jqliang ��ȡ�����Ǽ�ʱ��¼��ķ�Ժ��Ϣ
		 sSql = "select nvl(CourtNo,' ') as CourtNo,nvl(AcceptedCourt,' ') as AcceptedCourt from lawcase_book "+
   			  " where LawCaseSerialNo =:LawCaseSerialNo";
	     so = new SqlObject(sSql).setParameter("LawCaseSerialNo", sObjectNo);
	     rs = Sqlca.getASResultSet(so);
	     if(rs.next()){
	    	sCourtNo = rs.getString("CourtNo");
	    	sAcceptedCourt = rs.getString("AcceptedCourt");
	     }
	    rs.getStatement().close();
	}
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//���ݲ�ͬ�İ��������Ա���ͣ���ʾ��ͬ����ϸ��Ϣģ��
	if (sPersonType.equals("01"))
		sTempletNo="CasePartyInfo";	//������������Ϣ
	else if (sPersonType.equals("02"))
		sTempletNo="CaseCourtInfo";	 //������������Ϣ
	else if (sPersonType.equals("03"))
		sTempletNo="CaseAgentInfo";	//������������Ϣ
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
				
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sLPSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql);
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
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		/* if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}	 */
		//if(!checkOrgNo()) return;
		as_save("myiframe0");					
	}
	
	//У�� �������Ӧ�������ϰ���������Ժ��ͬ
	function checkOrgNo(){
		if("<%=sPersonType%>"=="02"){
			var sOrgNo = getItemValue(0,0,"OrgNo");
			var sCourtNo = "<%=sCourtNo%>";
			var sAcceptedCourt = "<%=sAcceptedCourt%>";
			if(sCourtNo!=" "&&sCourtNo.length>0&&sOrgNo!=sCourtNo){
					alert("�����������Ӧ�������Ǽ�ʱ¼������߷�Ժ��ͬ");
					return false;
			}
			return true;
		}else{
			return true;
		}
		
		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		sPersonType = "<%=sPersonType%>";			
		if (sPersonType == "01")	//������������Ϣ
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CasePartyList.jsp?SerialNo=<%=sObjectNo%>","_self","");
		else if (sPersonType == "02")	//������Ժ����Ա��Ϣ
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CaseCourtList.jsp","_self","");
		else if (sPersonType == "03")	//������������Ϣ
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CaseAgentList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=ѡ������������;InputParam=��;OutPutParam=��;]~*/
	function getPersonName()
	{				
		sPersonType = "<%=sPersonType%>";			
		
		if (sPersonType == "01")	//������������Ϣ
		{
			//ChoosePersonerList
			//setObjectValue("SelectAgent","","@OtherAttorneyName@1",0,0,"");
			AsDialog.SetGridValue("ChoosePersonerList", "", "AgentType=CUSTOMERTYPE@PersonID=CUSTOMERID@PersonNo=CERTID@PersonName=CUSTOMERNAME@DailyPerson=NORPERSONER@LegalPerson=ENTPERSONER@ContactTel=NORTEL@OrgAddress=NORADDRE@PostalCode=NORZIP", "");
		}else if (sPersonType == "02")	//������Ժ����Ա��Ϣ
		{
			setObjectValue("SelectAcceptor","","@PersonNo@0@PersonName@1@OrgNo@2@OrgName@3@DepartType@4@Duty@5@ContactTel@6@OrgAddress@7@PostalCode@8",0,0,"");	
		}else if (sPersonType == "03")	//������������Ϣ
		{	
			var sReturn = setObjectValue("SelectAgent","","@PersonNo@0@PersonName@1@OrgNo@2@OrgName@3@AgentType@4@Duty@5@PersistNo@6@PRACTITIONERTIME@7@Specialty@8@ContactTel@9@PostalCode@10@OrgAddress@11@TypicalCase@12",0,0,"");
		}
	}
		
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		sParaString = "RecoveryOrgID"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectImportCustomer",sParaString,"@PersonID@0@PersonNo@3@PersonName@1@LegalPerson@4@ContactTel@5@OrgAddress@6@PostalCode@7",0,0,"");	
	}
	
	/*~[Describe=ִ����������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�		
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");		
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;	

			setItemValue(0,0,"SerialNo","<%=DBKeyHelp.getSerialNo("lawcase_persons","SerialNo",Sqlca)%>");	
			setItemValue(0,0,"PersonType","<%=sPersonType%>");			
			setItemValue(0,0,"LawCaseSerialNo","<%=sObjectNo%>");			
			if("<%=sPersonType%>"=="02")
			{
				//������ر�š�����������ء�����������͡�����׶Ρ������ɫ
				setItemValue(0,0,"OrgNo","<%=sOrgNo%>");
				setItemValue(0,0,"OrgName","<%=sOrgName%>");
				setItemValue(0,0,"DepartType","<%=sDepartType%>");			
				setItemValue(0,0,"TakePartPhase","<%=sTakePartPhase%>");
				setItemValue(0,0,"TakePartRole","<%=sTakePartRole%>");
			}								
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");			
			//�Ǽ�����						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//�����ˡ����������ơ����»��������»�������
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UpdateOrgName","<%=CurOrg.getOrgName()%>");			
			//��������						
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");	
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{		
		var sTableName = "LAWCASE_PERSONS";//����
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

