<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	ASObjectModel doTemp = new ASObjectModel("RelativeProjectList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","��Ŀ����","��Ŀ����","edit()","","","","btn_icon_detail",""},
		};
%>
<HEAD>
<title>������Ŀ��ѯ</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
	    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+serialNo+"&RightType="+"ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
