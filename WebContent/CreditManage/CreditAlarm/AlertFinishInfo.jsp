<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��ʾ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����	
	String AlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID"));
	if(AlertID==null) AlertID="";

	String sSql = "select SerialNo,ObjectType,ObjectNo,GetObjectName(ObjectType,ObjectNo) as ObjectName,AlertType,AlertTip,AlertDescribe,OccurDate,OccurTime,UserID,OrgID,OccurReason,Treatment,EndTime,Remark,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime from ALERT_LOG where SerialNo='"+AlertID+"'";
	String[][] sHeaders = {
		{"Treatment","������"},
		{"EndTime","�����������"},
		};
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="ALERT_LOG";
	doTemp.setKey("SerialNo",true);
	doTemp.setUpdateable("ObjectName",false);

	doTemp.setDDDWSql("ObjectType","select ObjectType,ObjectName from OBJECTTYPE_CATALOG where ObjectType in('Customer','Individual','BusinessContract')");
	doTemp.setVisible("SerialNo,ObjectType,ObjectName,ObjectNo,AlertType,AlertTip,OccurDate,AlertDescribe,UserID,OrgID,OccurTime,OccurReason,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime,Remark",false);

	//doTemp.setDDDWCode("AlertType","AlertSignal");
	doTemp.setUnit("AlertTip"," <input type=button value=\"..\" class=inputDate onClick=\"javascript:parent.setObjectInfo(\\'Code\\',\\'CodeNo=AlertSignal@AlertType@0@AlertTip@1\\')\"> ");
	doTemp.setEditStyle("Treatment","3");
	doTemp.setCheckFormat("EndTime","3");
	doTemp.setReadOnly("AlertTip",true);
	doTemp.setRequired("EndTime,Treatment",true);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","saveAndGoBack()","","","",""},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=���������޸�,�������б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function saveAndGoBack(){
		if(!confirm("��ȷ��Ҫ���ñʾ�ʾ��Ϣ���Ϊ���Ѵ�����ɡ���\n����Ϣ����ʾ�ڡ��Ѵ����Ԥ����Ϣ�������С�")) return;
		saveRecord("goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		self.close();
	}

	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function saveAndNew(){
		saveRecord("newRecord()");
	}
	
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/CreditManage/CreditAlarm/AlertInfo.jsp?AlertID=new","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	function chooseObject(sValueString){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(sObjectType==null || sObjectType==""){
			alert("����ѡ����ض�������");
			return;
		}
		setObjectInfo(sObjectType,sValueString);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		if(getItemValue(0,0,"EndTime")=="") setItemValue(0,0,"EndTime","<%=StringFunction.getToday()%>");
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "ALERT_LOG";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "AL";//ǰ׺
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