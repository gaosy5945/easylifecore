<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sDOSerialNo = (String)CurPage.getParameter("DOSerialNo");
	if(null==sDOSerialNo) sDOSerialNo="";
	String sDOObjectType = (String)CurPage.getParameter("DOObjectType");
	if(null==sDOObjectType) sDOObjectType="";
	String sDOObjectNo = (String)CurPage.getParameter("DOObjectNo");
	if(null==sDOObjectNo) sDOObjectNo="";
	String sTransactionCode = (String)CurPage.getParameter("TransactionCode");
	if(null==sTransactionCode) sTransactionCode="";
	 
	ASObjectModel doTemp = new ASObjectModel("DocFileList");
	 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	  //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.MultiSelect=true;
	dwTemp.setParameter("SERIALNO", sDOObjectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
	if(sTransactionCode == ""){
		sButtons[1][0] = "false";
	}
	if(sTransactionCode == "0010"||sTransactionCode == "0040"){
		sButtons[1][0] = "false";
	}
	if(sTransactionCode == "0015"){
		sButtons[0][0] = "true";
		sButtons[2][0] = "false";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		  
		  //var sReturn =  setObjectValue("SelectObjectFileGrid","","@FILEID@0@FILENAME@1",0,0,"");			
		  var returnValue = AsCredit.selectMultipleTree("SelectDocFileConfig1", "", ",", "");
		  if(returnValue["ID"].length == 0) return;
			var fileID = returnValue["ID"];
			fileID = fileID.split(",");
			for(var i in fileID){
				if(typeof fileID[i] ==  "string" && fileID.length > 0 ){
					var ID = fileID[i];
					alert(ID);
	        	//AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "insertDFI", "ID="+ID+",ObjectNo="+objectNo);
				}
			} 
		/*  var sParaString = "UserID"+","+AsCredit.userId;	   
	     setObjectValue("SelectPartnerProject",sParaString,"@ProjectSerialNo@0@ProjectType@1@CustomerID@2@ProjectName@3@PartnerName@4",0,0,"");
		  */
		 if(typeof(sReturn) == "undefined" || sReturn=="null" || sReturn=="" || sReturn ==null){
			return;
		} 
		sReturn = sReturn.split("@");
		 //��ȡ��ˮ��
		 //sSerialNo = getSerialNo("DOC_OPERATION_FILE","SerialNo","");
		//var sObjectNo = sObjectNo;//������ţ���ȱ�š������š�������Ŀ���
		/* var sPara = "";
		sPara = "OperateMemo="+""+"&DOSerialNo="+sReturn[0]+"&DFISerialNo="+sReturn[1]+"&OperationType=";
		//alert(sPara);
		//����һ����������
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OperationFileAddAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sReturn)!="undefined" && sReturn=="true"){
				self.returnValue = "TRUE@" + sSerialNo + "@";
				self.close();
		}  */
		 
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
