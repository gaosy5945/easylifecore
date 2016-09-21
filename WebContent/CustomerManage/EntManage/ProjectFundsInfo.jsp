<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��Ŀ�ʽ���Դ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql = "";
	ASResultSet rs ;
	String sPlanTotalCast = "";
	String sProjectCapitalScale = "";
	//����������
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFundSource  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FundSource"));
	if(sFundSource == null ) sFundSource = "";
	if(sSerialNo == null ) sSerialNo = "";

	if(sFundSource.equals("01")){
		sSql = "select PlanTotalCast,CapitalScale from PROJECT_INFO "+
		   " where ProjectNo= :ProjectNo";
		rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ProjectNo",sProjectNo));
		if(rs.next()){
			sPlanTotalCast = rs.getString("PlanTotalCast");
			sProjectCapitalScale = rs.getString("CapitalScale");
		}
		rs.getStatement().close();
	}

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ProjectFundsInfo";	
	String sTempletFilter = "  ColAttribute like '%"+sFundSource+"%' ";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		setObjectValue("SelectInvest","","@INVESTORCODE@0@INVESTORNAME@1",0,0,"");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/ProjectFundsList.jsp?","_self","");
	}
	
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		setItemValue(0,0,"PROJECTNO","<%=sProjectNo%>");
		setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		return true;
	}

	//ѡ�����
	function getRegionCode(){
		sParaString = "CodeNo"+",AreaCode";			
		setObjectValue("SelectCode",sParaString,"@LOCATIONOFINVESTOR@0@LOCATIONOFINVESTORNAME@1",0,0,"");
	}	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			if("<%=sFundSource%>"=="010"){	//hxli Ͷ��ռ��Ϊ�գ��ÿհ�
				if("<%=sPlanTotalCast%>" != "null" ){
					setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					//setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
				
				if("<%=sProjectCapitalScale%>" != "null"){
					//setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
			}
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() {
		var sTableName = "PROJECT_FUNDS";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>