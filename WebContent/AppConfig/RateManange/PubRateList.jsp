<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PubRateList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	

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
		OpenPage("/AppConfig/RateManange/PubRateInfo.jsp","_self","");
	}
	function edit(){
		 var sCurrency = getItemValue(0,getRow(0),"CURRENCY");
		 var sEffectDate = getItemValue(0,getRow(0),"EFFECTDATE");
		 var sRateType = getItemValue(0,getRow(0),"RATETYPE");
		 var sRateUnit = getItemValue(0,getRow(0),"RATEUNIT");
		 var sTerm = getItemValue(0,getRow(0),"TERM");
		 var sTermUnit = getItemValue(0,getRow(0),"TERMUNIT");
		 var sUrl = "/AppConfig/RateManange/PubRateInfo.jsp";
		 var sPara = "Currency="+sCurrency + "&" + "EffectDate="+sEffectDate + "&" + "RateType="+sRateType + "&" + "RateUnit="+sRateUnit + "&" + "Term="+sTerm + "&" + "TermUnit="+sTermUnit;
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,sPara ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
