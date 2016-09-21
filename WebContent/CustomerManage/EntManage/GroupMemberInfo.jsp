<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: �������ų�Ա��Ϣ;
		Input Param:
			CustomerID����ǰ�ͻ����
			RelativeID�������ͻ���֯��������
			Relationship��������ϵ
		Output Param:
			CustomerID����ǰ�ͻ����
		HistoryLog:
		    cbsu 2009/10/23 Ϊ��Ӧ�µļ��ſͻ��������󣬽����±���ΪGROUP_RELATIVE��
	 */
	String PG_TITLE = "�������ų�Ա��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql = "";
    String sCertType = "";
    String sCertID = "";
    String sCustomerName = "";
    ASResultSet rs = null;
	//����������
	//���ſͻ����
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//���ҳ�����
	//���ų�Ա���
	String sGroupMemberID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupMemberID"));
	//��������:"ʵ�弯��"��"���⼯��"
	String sGroupType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupType"));
	if(sRelativeID == null) sRelativeID = "";
	if(sGroupType == null) sGroupType = "";
	if(sGroupMemberID == null) {
		sGroupMemberID = "";
	} else {
	    //�õ����ų�Ա֤�����ͣ�֤����ţ�����
		sSql = " Select CertType, CertID, CustomerName from CUSTOMER_INFO Where CustomerID = :CustomerID";
		rs =  Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sGroupMemberID));
		if (rs.next()) {
			sCustomerName = rs.getString("CustomerName");
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
		}
		rs.getStatement().close();
	} 

	String sHeaders[][] = {
							{"CustomerName","���ų�Ա����"},
							{"CertType","���ų�Ա֤������"},
							{"CertID","�������ų�Ա֤������"},
							{"RelationShip","��Ա����"},
							{"Remark","��ע"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"}
						   };

	sSql =	" select '' as CustomerName,CustomerID,RelativeID," +
			" '' as CertType,'' as CertID,RelationShip," +
			" InputOrgId,getOrgName(InputOrgId) as OrgName,"+
			" InputUserId,getUserName(InputUserId) as UserName,InputDate,UpdateDate "+
			" from GROUP_RELATIVE " +
			" where CustomerID='"+sGroupMemberID+"' " +
			" and RelativeID='"+sRelativeID+"' ";

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GROUP_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID",true);
	doTemp.setRequired("RelationShip,CustomerName",true);
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,InputOrgId",false);
	doTemp.setUpdateable("UserName,OrgName,CustomerName,CertType,CertID",false);

	//�����ֶθ�ʽ
	doTemp.setEditStyle("Remark","3");
	doTemp.setLimit("Remark",400);
	doTemp.setHTMLStyle("Remark","style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	//����������
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CertType' and ItemNo like 'Ent%'");
    doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='GroupRelation' and ItemNo like '10%' and length(ItemNo)>2 ");
    doTemp.setDefaultValue("RelationShip","1020");
	doTemp.setReadOnly("CustomerName,CertType,CertID",true);
	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sGroupMemberID.equals("")){
		doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=... onclick=parent.selectCustomer()>");
	}
	//�������ݴ���
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform��ʽ

	////����CUSTOMER_INFO, ENT_INFO, GROUP_CHANGE���ű�
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddGroupInfo(#CustomerID,#RelativeID,"+CurUser.getUserID()+")");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		//����ǰ���м��,���ͨ�����������,���������ʾ
        if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate()
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/GroupMemberList.jsp?","_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		sRelativeID = "<%=sRelativeID%>";
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������		
		setObjectValue("SelectDisRelativeMember","RelativeID,"+sRelativeID,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
    }

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"RelativeID","<%=sRelativeID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		} else {
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CertType","<%=sCertType%>");
			setItemValue(0,0,"CertID","<%=sCertID%>");
		}
	}

	/*~[Describe=���¼��Ŀͻ��Ƿ�Ϊ�Ѿ��뼯�������;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		//�ͻ����
		sCustomerID   = getItemValue(0,0,"CustomerID");
		//���ſͻ����
		sRelativeID = getItemValue(0,0,"RelativeID");
		sRelationShip = getItemValue(0,0,"RelationShip");

		//����Ƿ�¼���˶��ĸ��˾��һ������ֻ����һ��ĸ��˾ add by cbsu 2009-11-02		
		if (sRelationShip == '1010') {
			var isMultiParent = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckMultiParent", "checkMultiParent", "relativeID="+sRelativeID);
			if (isMultiParent == "Failed") {
				alert("ĸ��˾�Ѿ����ڣ�һ�����Ų���������ĸ��˾��������ѡ���Ա���ͻ����ԭĸ��˾�ĳ�Ա����Ϊ�ӹ�˾��");
			    return false;
			}
		}

        //������ʱ���¼��Ŀͻ��Ƿ�Ϊ�Ѿ��뼯�������
		if(bIsInsert){			
			var isRelated = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckGroupRelative","checkGroupRelative","customerID="+sCustomerID + ",relativeID=" + sRelativeID);
			if (isRelated == "Failed"){
				alert("ѡ��Ŀͻ����뼯�Ź�������ѡ�������ͻ���");
				return false;
			}
		}
		return true;
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@	include file="/IncludeEnd.jsp"%>