<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("OutSourcCollMonitorList");

	doTemp.setJboWhere(doTemp.getJboWhere() + " and tasktype ='�������' and INPUTORGID='"+CurUser.getOrgID()+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","�鿴����������ϸ","�鿴����������ϸ","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		 //sUrl = "/CreditManage/Collection/CollTaskList.jsp";
		 //OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
		
		 var sUrl = "/CreditManage/Collection/CollTaskList.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		
		AsControl.PopComp(sUrl,'SerialNo=' +sPara + '&CollType=3','');
		reloadSelf();
		//AsControl.popComp(sUrl,'SerialNo=' +sPara + '&CollType=3','_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
