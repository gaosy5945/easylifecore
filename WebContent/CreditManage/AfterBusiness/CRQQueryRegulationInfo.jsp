<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "CRQQueryRegulationInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("SerialNo", "001");
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","save()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		var USEROBJECT = getItemValue(0, getRow(), "USEROBJECT");
		var USEROBJECT1 = getItemValue(0, getRow(), "USEROBJECT1");
		var USEROBJECT2 = getItemValue(0, getRow(), "USEROBJECT2");
		if(USEROBJECT.indexOf("01") > -1 && USEROBJECT1.indexOf("01") > -1 && USEROBJECT2.indexOf("01") > -1){
		
		}else{
			alert("���Ų�ѯ�����н����Ϊ��ѡ�������ѡ��");
			return;
		}
		setItemValue(0, getRow(0), "SerialNo", "001");
		var MAXOVERDUEDAYS = getItemValue(0,getRow(),"MAXOVERDUEDAYS");
		var MINOVERDUEDAYS = getItemValue(0,getRow(),"MINOVERDUEDAYS");
		if(MAXOVERDUEDAYS<=MINOVERDUEDAYS && MAXOVERDUEDAYS != ""){
			alert("���Ѵ�������������ѯ����¼��ġ��������������������ڡ���С������������");
			return;
		}
		var MAXBALANCE1 = getItemValue(0,getRow(),"MAXBALANCE1");
		var MINBALANCE1 = getItemValue(0,getRow(),"MINBALANCE1");
		if(MAXBALANCE1<=MINBALANCE1 && MAXBALANCE1 != ""){
			alert("���Ѵ�������������ѯ����¼��ġ����ͻ��������Ǿ�Ӫ�ࣩ��������ڡ���С�ͻ��������Ǿ�Ӫ�ࣩ����");
			return;
		}
		var MAXBALANCE2 = getItemValue(0,getRow(),"MAXBALANCE2");
		var MINBALANCE2 = getItemValue(0,getRow(),"MINBALANCE2");
		if(MAXBALANCE2<=MINBALANCE2 && MAXBALANCE2 != ""){
			alert("���Ѵ�������������ѯ����¼��ġ����ͻ�����������Ӫ�ࣩ��������ڡ���С�ͻ�����������Ӫ�ࣩ����");
			return;
		}
		var MAXBALANCE3 = getItemValue(0,getRow(),"MAXBALANCE3");
		var MINBALANCE3 = getItemValue(0,getRow(),"MINBALANCE3");
		if(MAXBALANCE3<=MINBALANCE3 && MAXBALANCE3 != ""){
			alert("���Ѵ�������������ѯ����¼��ġ����ͻ������ô������Ǿ�Ӫ�ࣩ��������ڡ���С�ͻ������ô������Ǿ�Ӫ�ࣩ����");
			return;
		}
		var MAXOVERDUEDAYS1 = getItemValue(0,getRow(),"MAXOVERDUEDAYS1");
		var MINOVERDUEDAYS1 = getItemValue(0,getRow(),"MINOVERDUEDAYS1");
		if(MAXOVERDUEDAYS1<=MINOVERDUEDAYS1 && MAXOVERDUEDAYS1 != ""){
			alert("����ҵ������������ѯ����¼��ġ��������������������ڡ���С������������");
			return;
		}
		
		as_save(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
