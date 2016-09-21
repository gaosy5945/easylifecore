<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sShelvesType = CurPage.getParameter("ShelvesType");
	if(sShelvesType == null) sShelvesType = "";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2PullOfShelvesList");
	
	if("0010".equals(sShelvesType) || "0010" == sShelvesType){
		sWhereSql = " and O.PACKAGETYPE='02' and O.POSITION is not null";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}else 	if("0020".equals(sShelvesType) || "0020" == sShelvesType){
		doTemp.setJboWhere(doTemp.getJboWhere() + " and O.POSITION is null");
	}
		
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","�¼�","�¼�","PullOfShelves()","","","","btn_icon_detail",""},
			{"true","","Button","ǿ���ϼ�","ǿ���ϼ�","EntryOfShelves()","","","","btn_icon_detail",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};

	if("0010".equals(sShelvesType) || "0010" == sShelvesType){
		sButtons[2][0] = "false";
	}else 	if("0020".equals(sShelvesType) || "0020" == sShelvesType){
		sButtons[1][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	
	function PullOfShelves(){
		if(confirm('ȷʵҪ�¼���?')) {//��λ����Ϊ��
			var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
			if(sDOObjectType == null) sObjesDOObjectTypectType = "";
			var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
			if(sObjectNo == null) sObjectNo = "";
			var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
			if(sDOSerialNo == null) sDOSerialNo = "";
			var sUserId = "<%=CurUser.getUserID()%>";
			var sOrgId = "<%=CurUser.getOrgID()%>";
			var sDate = "<%=StringFunction.getToday()%>";
			var sOperationType = "";//Ԥ�鵵
			var sRemark = "";
			var sPosition = "";//ȡ��ר�б���  ר�м�λ
			var sMsg = "";
			var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition;
			//����һ����������
			var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2specialKeepingAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
			if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					sMsg = "�¼ܳɹ�";
			} else {
				sMsg = "�¼�ʧ��";
			}
			alert(sMsg);
		}
		reloadSelf();
	}
	//ǿ���ϼ�
	function EntryOfShelves(){
		if(confirm('ȷʵҪǿ���ϼ���?')) {//
			var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
			if(sSerialNo == null) sSerialNo = "";
			var sObjectType = getItemValue(0,getRow(0),'ObjectType');
			if(sObjectType == null) sObjectType = "";
			var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
			if(sObjectNo == null) sObjectNo = "";
			var sParaValue = "SerialNo="+sSerialNo + "&ObjectType=" + sObjectType + "&ObjectNo=" + sObjectNo + "&sShelvesType=01" ;
			var returnValue = PopPage("/DocManage/Doc2Manage/Doc2BPManage/DocWarehouseAddDialog.jsp?"+sParaValue,"","resizable=yes;dialogWidth=500;dialogHeight=200;center:yes;status:no;statusbar:no");
			returnValue = returnValue.split("@");
			var returnSerialNo = returnValue[1];
			if(returnSerialNo == null || returnSerialNo == "undefine" || returnSerialNo == "null"){
				returnSerialNo = "";
			}
			if(returnValue[0] == "TRUE"){
				alert(returnSerialNo+"ǿ���ϼܳɹ���");
			}else {
				alert(returnSerialNo+"ǿ���ϼ�ʧ�ܣ�");
			}
		}
		reloadSelf();
	}	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
