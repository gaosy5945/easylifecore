<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("BCStartLawRemindList");
	doTemp.setJboWhere(doTemp.getJboWhere() + " and  O.CONTRACTSTATUS ='03' and ((O.Maturitydate>=v.to_char(v.add_months(v.sysdate,-24),'yyyy/mm/dd') and O.Maturitydate<=v.to_char(v.sysdate,'yyyy/mm/dd')) or ( O.Maturitydate<v.to_char(v.sysdate,'yyyy/mm/dd') and O.Maturitydate>v.to_char(v.add_months(v.sysdate,-1),'yyyy/mm/dd'))) and not exists (select 1 from jbo.preservation.LAWCASE_RELATIVE lr where lr.objectno=O.serialno ) ");//
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"false","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
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
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
