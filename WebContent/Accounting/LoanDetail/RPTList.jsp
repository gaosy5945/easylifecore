<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%	
	/*
        Author: undefined 2015-11-19
        Content: 
        History Log: 
    */
    String objectType = CurPage.getParameter("ObjectType");//��������
    String objectno = CurPage.getParameter("ObjectNo");//������
    String status = CurPage.getParameter("Status");//����״̬
	ASObjectModel doTemp = new ASObjectModel("RPTList");
	doTemp.appendJboWhere(" and Status ="+status);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.MultiSelect = true;	 //��ѡ
	//dwTemp.ShowSummary="1";	 	 //����
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectno+","+objectType);
	

	//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
	String sButtons[][] = {
		{"false","All","Button","����","����","newRecord()","","","","btn_icon_add",""},
		{"false","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
		{"false","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		 var sUrl = "";
		 AsControl.OpenView(sUrl,'','_self','');
	}
	function viewAndEdit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenView(sUrl,'SerialNo=' +sPara ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>