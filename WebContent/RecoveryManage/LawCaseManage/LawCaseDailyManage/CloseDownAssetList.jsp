<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
out.println("<b><font size='3'>- ����ʲ��б�</font></b>");
	//�������
	//������������������ˮ�š�̨�����ͣ�	
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	String sBookType = (String)CurComp.getParameter("BookType");
	//����ֵת��Ϊ���ַ���
	if(sBookType == null) sBookType = "";
	if(sSerialNo == null) sSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("CloseDownAssetList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
			{"true","All","Button","�˳����","�˳����","outEdit()","","","","btn_icon_detail",""},	
	};
	
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sUrl = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/CloseDownAssetInfo.jsp";
		AsControl.PopComp(sUrl,"LAWCASESERIALNO=<%=sSerialNo%>","");
		reloadSelf();
	}
	function edit(){
		 var sUrl = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/CloseDownAssetInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopComp(sUrl,'SerialNo=' +sPara ,'');
		reloadSelf();
	}
	function outEdit(){
		var sUrl = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/OutCloseDownAssetInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopComp(sUrl,'SerialNo=' +sPara ,'');
		reloadSelf();		
		AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/OutCloseDownAssetList.jsp","SerialNo=<%=sSerialNo%>&BookType=<%=sBookType%>","rightdown","");
	}
	
	function deleteRecord(){
		if(confirm('ȷʵҪɾ����?'))as_delete(0);//,'alert(getRowCount(0))'
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "LAWCASE_BOOK";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺
		//var sSerialNo = PopPageAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
