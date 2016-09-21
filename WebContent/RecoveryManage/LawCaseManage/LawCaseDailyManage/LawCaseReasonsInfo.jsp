<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
	Author: zqliu 2014-11-18
	Tester:
	Describe: ȡ���ָ�������Ϣ;
	Input Param:
		sObjectType����ť���ͣ�01��ȡ�����ϣ�02���ָ����ϣ�03���鿴ȡ�����ϣ�
		SerialNo: ���ϰ�����ˮ��
		//BookType��ȡ�����ǻָ� ��Cancel��Recover��
			
	Output Param:

	HistoryLog:
					 
 */
%>
<%
	//����������	
	String sTitle="";
	//��������������ť���͡�������ˮ�š���Ϣ���ͣ�
	String sObjectType = (String)CurComp.getParameter("ObjectType");
	String sBookType="";
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	//����ֵת��Ϊ���ַ���
	if(sObjectType==null || "Null".equalsIgnoreCase(sObjectType)) sObjectType="";
	if(sSerialNo==null || "Null".equalsIgnoreCase(sSerialNo)) sBookType="";

	if ("02".equals(sObjectType) || "02"==sObjectType)
	{
		sTitle = "�ָ�������Ϣ";
		 sBookType="Recover";
	}
	
	if ("01".equals(sObjectType) || "02"==sObjectType ||"03".equals(sObjectType) || "03"==sObjectType)
	{
		sTitle = "ȡ��������Ϣ";
		 sBookType="Cancel";
	}
	

	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "LawCaseReasons";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	if ("02".equals(sObjectType) || "02"==sObjectType){
		doTemp.setVisible("EvidenceCatalog", true);//�ָ���������
		doTemp.setRequired("EvidenceCatalog", true);
	}
	if ("01".equals(sObjectType) || "01"==sObjectType ||"03".equals(sObjectType) || "03"==sObjectType){
		doTemp.setVisible("RefusedReason", true);//ȡ����������
		doTemp.setRequired("RefusedReason", true);//
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","goBack()","","","",""}
	};
	
	if ("03".equals(sObjectType) || "03"==sObjectType){
		sButtons[0][0]="false";
	}
	sButtonPosition = "south";
	
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sLawcaseName = "";
	String sCasePhase = "";
	String sCasePhaseName = "";
	String sLawcaseType = "";
	String sLawcaseTypeName = "";
	String sOldCasePhase = "";
	sSql =  " select LawcaseName,CasePhase,getItemName('CasePhase',CasePhase) as CasePhaseName,LawcaseType,getItemName('LawCaseType',LawcaseType) as LawcaseTypeName , OldCasePhase "+
	        " from LAWCASE_INFO  where SerialNo =:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
   	rs = Sqlca.getASResultSet(so); 	   	
   	if(rs.next()){
		sLawcaseName = rs.getString("LawcaseName");
		sCasePhase = rs.getString("CasePhase");
		sCasePhaseName = rs.getString("CasePhaseName");			
		sLawcaseType = rs.getString("LawcaseType");
		sLawcaseTypeName = rs.getString("LawcaseTypeName");
		sOldCasePhase = rs.getString("OldCasePhase");
	 }		 
	 rs.getStatement().close();
	 if(sLawcaseName==null)sLawcaseName="";
	 if(sCasePhase==null)sCasePhase="";
	 if(sCasePhaseName==null)sCasePhaseName="";
	 if(sLawcaseType==null)sLawcaseType="";
	 if(sLawcaseTypeName==null)sLawcaseTypeName="";
	 if(sOldCasePhase==null)sOldCasePhase="";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert=false;
	var sSaveFlag="FALSE";
	my_load(2,0,'myiframe0');
	initRow();
	//---------------------���尴ť�¼�------------------------------------
		
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{

		setItemValue(0,0,"BookType","<%=sBookType%>");					
		setItemValue(0,0,"LawCaseSerialNo","<%=sSerialNo%>");
		var sDate="<%=StringFunction.getToday()%>";
		setItemValue(0,0,"UpdateDate", sDate);
		setItemValue(0,0,"LIUpdateDate",sDate);
		var sReasons = "";
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		var sObjectType = "<%=sObjectType%>";
		var sCasePhase="";
		var sMsg = "";
		//ȡ������ʱ����ԭ���Ľ׶α���
		if ( "01"==sObjectType || "03"==sObjectType){
			sCasePhase=getItemValue(0,getRow(),"CASEPHASE");
			setItemValue(0,0,"OLDCASEPHASE",sCasePhase);
			setItemValue(0,0,"CASEPHASE","110");
			sCasePhase="110";
			sReasons = getItemValue(0,getRow(),"REFUSEDREASON");
			sMsg = "������ȡ���������ɣ�";
		}
		//�ָ�����ʱ�����׶λָ�
		if ("02"==sObjectType){
			sCasePhase=getItemValue(0,getRow(),"OLDCASEPHASE");
			if(sCasePhase=="" || sCasePhase=="Null" || sCasePhase=="null") sCasePhase="010"
			setItemValue(0,0,"CASEPHASE",sCasePhase);
			sReasons = getItemValue(0,getRow(),"EVIDENCECATALOG");
			sMsg = "������ָ��������ɣ�";
		}
		if(sReasons=="" || sReasons=="undefined" || sReasons=="null" || sReasons==null){
			alert(sMsg);
			return;
		}
		beforeUpdate();
		as_save("myiframe0",setSaveFlag());	
		if(sSaveFlag=="TRUE"){
			var sRetrunValue1 =  RunMethod("PublicMethod","UpdateColValue","String@CasePhase@"+sCasePhase+",LAWCASE_INFO,String@SerialNo@"+"<%=sSerialNo%>");
			if(sRetrunValue1=="TRUE"){
				self.returnValue="TRUE";
				self.close();
			}
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
	
	/*~[Describe=ִ����������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�		
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//������¼
			bIsInsert = true;	

			//̨������
			setItemValue(0,0,"BookType","<%=sBookType%>");					
			setItemValue(0,0,"LawCaseSerialNo","<%=sSerialNo%>");
			
			setItemValue(0,0,"LawcaseName","<%=sLawcaseName%>");					
			setItemValue(0,0,"CasePhase","<%=sCasePhase%>");
			setItemValue(0,0,"CasePhaseName","<%=sCasePhaseName%>");					
			setItemValue(0,0,"LawcaseType","<%=sLawcaseType%>");
			setItemValue(0,0,"LawcaseTypeName","<%=sLawcaseTypeName%>");					
			setItemValue(0,0,"OldCasePhase","<%=sOldCasePhase%>");
								
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//�Ǽ�����	��������					
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"LIUpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "LAWCASE_Book";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
