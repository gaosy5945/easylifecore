<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//������������������ˮ�ţ�	BOOKTYPE='100' ͥ���¼
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("ImparRecordList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sObjectNo="<%=sSerialNo%>";
		AsControl.OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/ImparRecordInfo.jsp","ObjectNo="+sObjectNo,"right","");    

		 //var sUrl = "";
		// AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		/*  var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self',''); */
		//��ü�¼��ˮ�š��������
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");	
		var sObjectNo = getItemValue(0,getRow(),"LAWCASESERIALNO");
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		AsControl.OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/ImparRecordInfo.jsp","SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo ,"right","");
	
	}
	function del(){
		//if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))');
		if(confirm('ȷʵҪɾ����?'))as_delete(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
