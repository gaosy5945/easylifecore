<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��ĿͶ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql = "",sProjectType = "";//--���sql��䡢��Ŀ����
	
	//����������,��ǰ��Ŀ���
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	//�����Ŀ����
	sSql = " select ProjectType  from PROJECT_INFO where ProjectNo=:ProjectNo ";
	sProjectType = Sqlca.getString(new SqlObject(sSql).setParameter("ProjectNo",sProjectNo)); 
	if(sProjectType == null ) sProjectType = "";
	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	if(sProjectType.equals("02"))
		sTempletNo = "HouseProjectBudgetInfo";
	else
		sTempletNo = "FixProjectBudgetInfo";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"fasle","","Button","����","�����б�ҳ��","goBack()","","","",""}
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
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/ProjectFundsList.jsp","_self","");
	}
	
	/*~[Describe=�ϼƷ���;InputParam=��;OutPutParam=��;]~*/
	function getSum(iStart,iEnd,iDes){
		var Sum=0;
		if(iStart == '16' && iEnd == '26' && iDes == '27'){ //�ϼƣ���Ԫ��
			for(var i=iStart+1;i<iEnd+1;i=i+2){
			//alert(getItemValue(0,getRow(),"EXESSUM"+i));
			if(typeof(getItemValue(0,getRow(),"EXESSUM"+i))=="undefined" || getItemValue(0,getRow(),"EXESSUM"+i).length==0)
				continue;
			else
			Sum+=getItemValue(0,getRow(),"EXESSUM"+i);
			}
		}else{//�ܼ�(��Ԫ)
			for(var i=iStart;i<iEnd+1;i=i+1){
			//alert(getItemValue(0,getRow(),"EXESSUM"+i));
			if(typeof(getItemValue(0,getRow(),"EXESSUM"+i))=="undefined" || getItemValue(0,getRow(),"EXESSUM"+i).length==0)
				continue;
			else
			Sum+=getItemValue(0,getRow(),"EXESSUM"+i);
			}
		}
		//��Ŀ�ʱ������������
		setItemValue(0,getRow(),"EXESSUM"+iDes,Sum);
	}

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
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
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"PROJECTNO","<%=sProjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "PROJECT_BUDGET";//����
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