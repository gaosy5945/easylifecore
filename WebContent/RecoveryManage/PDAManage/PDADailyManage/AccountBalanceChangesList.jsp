<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sDASerialNo = CurPage.getParameter("SerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
out.println("��Ŀ���䶯̨�ˣ�**�����������Ʋ��ſ�Ŀ����һ��**��");
	ASObjectModel doTemp = new ASObjectModel("AccountBalanceChangesList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sDASerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sDASerialNo = "<%=sDASerialNo%>";
		var sSql = "select count(1) as cnt from lawcase_book where LAWCASESERIALNO='"+sDASerialNo+"'   and BOOKTYPE='310'";
		var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
		if(sReturnValue<1){
			 var sUrl = "/RecoveryManage/PDAManage/PDADailyManage/AccountBalanceChangesInfo.jsp";
			 var sSerialNo = getSerialNo("LAWCASE_BOOK","SerialNo","");
			 var sBookType = "310";
			 AsControl.PopComp(sUrl,"DASerialNo=<%=sDASerialNo%>&SerialNo="+sSerialNo+"&BookType"+sBookType,"","");
		}else{
			alert("��̨�˽�֧������һ����¼");
		}	
		reloadSelf();
		
	}
	function edit(){
		 var sUrl = "/RecoveryManage/PDAManage/PDADailyManage/AccountBalanceChangesInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopComp(sUrl,"DASerialNo=<%=sDASerialNo%>&SerialNo=" +sPara ,"","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
