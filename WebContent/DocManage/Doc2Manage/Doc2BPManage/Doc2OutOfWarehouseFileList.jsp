<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sDOSerialNo = (String)CurPage.getParameter("DOSerialNo");
	if(null==sDOSerialNo) sDOSerialNo="";
	String sDOObjectType = (String)CurPage.getParameter("DOObjectType");
	if(null==sDOObjectType) sDOObjectType="";
	String sDOObjectNo = (String)CurPage.getParameter("DOObjectNo");
	if(null==sDOObjectNo) sDOObjectNo="";
	String sOperationType = (String)CurPage.getParameter("OperationType");
	if(null==sOperationType) sOperationType="";
	
	ASObjectModel doTemp = new ASObjectModel("DocFileList");
	//doTemp.setJboWhere(doTemp.getJboWhere() + " and O.OPERATIONSERIALNO='" + sDOSerialNo + "'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("SERIALNO", sDOObjectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
	if(sOperationType == ""){
		sButtons[1][0] = "false";
	}
	if(sOperationType == "0010"){
		sButtons[1][0] = "false";
	}
	if(sOperationType == "0020"){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sReturn =  setObjectValue("SelectObjectFileGrid","OBJECTTYPE,<%=sDOObjectType%>,OBJECTNO,<%=sDOObjectNo%>","@SerialNo@0@FILEID@1",0,0,"");			
		 //var sReturn = setObjectValue("SelectObjectFileGrid","OBJECTTYPE,11,OBJECTNO,11","@SERIALNO@0@FILEID@1",0,0,"");			
		 sReturn = sReturn.split("@");
		 //��ȡ��ˮ��
		 //sSerialNo = getSerialNo("DOC_OPERATION_FILE","SerialNo","");
		//var sObjectNo = sObjectNo;//������ţ���ȱ�š������š�������Ŀ���
		var sPara = "";
		sPara = "OperateMemo="+""+"&DOSerialNo="+sReturn[0]+"&DFISerialNo="+sReturn[1]+"&OperationType=";
		alert(sPara);
		//����һ����������
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OperationFileAddAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sReturn)!="undefined" && sReturn=="true"){
				self.returnValue = "TRUE@" + sSerialNo + "@";
				self.close();
		} 
		 
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
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
