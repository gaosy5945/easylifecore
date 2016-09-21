<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%	
	//��ȡ�׶�����
	String sApplyType = CurPage.getParameter("ApplyType");
	if(sApplyType==null) sApplyType ="";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType==null) sRightType ="";  
	String sWhereSql = "";
	//������ʾģ���� 
	ASObjectModel doTemp = new ASObjectModel("Doc1OutOfWarehouseApplyList");
	//��������׶�  ֻ��ʾ��ǰ�û�������ύ��ҵ��
	if(sApplyType=="0010" || "0010".equals(sApplyType)){
		sWhereSql =  " and O.status='01' and O.inputuserid = '"+CurUser.getUserID()+"' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	//���������׶� ֻ��ʾ�������ǰ�û���������ҵ��
	}else if(sApplyType=="0020" || "0020".equals(sApplyType)){
		sWhereSql =  " and O.status in ('02','03','04') and O.inputuserid = '"+CurUser.getUserID()+"' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
	doTemp.setDDDWJbo("TRANSACTIONCODE","jbo.ui.system.CODE_LIBRARY,itemno,ItemName,Isinuse='1' and CodeNo='DocumentTransactionCode' and ItemNo in('0020','0030') order by sortno");
	//������ʾ��ͼ
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��������","����","add()","","","","btn_icon_add",""},
			{"true","","Button","��������","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ȡ������","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","�ύ","�ύ","submitRecord()","","","","btn_icon_detail",""},
		};
	if(sApplyType=="0010" || "0010".equals(sApplyType)){//���ύ
	}else	if(sApplyType=="0020" || "0020".equals(sApplyType)){//���ύ
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*************������������*************/
	function add(){ 
		 var sUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp";
		 var sDOSerialNo = getSerialNo("doc_operation","serialNo","");
		 AsControl.PopComp(sUrl,'DOSerialNo='+sDOSerialNo+"&ApplyType=<%=sApplyType%>",'','');
		 reloadSelf();
		 //AsCredit.openFunction("BusinessDoc1Info","DOSerialNo="+sDOSerialNo);
	}
	/*********�鿴��������**********/
	function edit(){
		 var sUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp";
		 var sPara = "";
		 var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sAISerialNo = getItemValue(0,getRow(0),'ASSETSERIALNO');
		 if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		if("0020"=="<%=sApplyType%>"){
			sRightType="ReadOnly";
		}else{
			sRightType="All";
		}
		 sPara = "DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType=<%=sApplyType%>&RightType="+sRightType;
		 AsControl.PopComp(sUrl,sPara,'','');
		 reloadSelf();
	}
	
	/*********ȡ����������*********/
	function deleteRecord(){
		//��ȡ����Ҫɾ���ĳ���������ˮ��
		 var sDOSerialNo = getItemValue(0,getRow(0),'SERIALNO'); 
		 if(confirm('ȷʵҪɾ����?')){
			 sSql = "delete from doc_operation where  serialno='"+sDOSerialNo+"'";
			 //ִ��ɾ������
			 var sReturn =  RunMethod("PublicMethod","RunSql",sSql);  
			 if( sReturn >= 0 || sReturn == "1" || sReturn =="0"){
				as_delete(0);
			 }else{
				alert("ɾ��ʧ�ܣ�");
			 }  
		 }  
	}
	
	/************�ύ�������뵽�����׶�*************/
	function submitRecord(){
		//��ȡ�ύ����������ˮ��
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sPara = "DOSerialNo="+sDOSerialNo+",ApplyType=01,UserID=<%=CurUser.getUserID()%>";
	 	var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "commit", sPara);
	 	if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
	 		alert("�ύ�ɹ���");
	 		self.reloadSelf();
	 	}else {
	 		alert("�ύʧ��!");
	 		return;
	 	} 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
