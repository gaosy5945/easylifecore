<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
        Author: undefined 2016-01-07
        Tester:
        Content: 
        Input Param:
        Output param:
        History Log: 
    */
	ASObjectModel doTemp = new ASObjectModel("MerchandiseList");
	String merchandiseType = CurPage.getParameter("MerchandiseType");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.MultiSelect = true;	 //��ѡ
	//dwTemp.ShowSummary="1";	 	 //����
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(merchandiseType);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "/MerchandiseManage/MerchandiseInfo.jsp";
		 AsControl.OpenView(sUrl,'MerchandiseType='+"<%=merchandiseType%>",'_self','');
	}
	function edit(){
		 var sUrl = "/MerchandiseManage/MerchandiseInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'MERCHANDISEID');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenView(sUrl,'MERCHANDISEID=' +sPara ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>