<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sTaskBatchNo = CurPage.getParameter("PTISerialNo");
	if(StringX.isEmpty(sTaskBatchNo) || null == sTaskBatchNo ) sTaskBatchNo = "";
	String sCTSerialNo = CurPage.getParameter("CTSerialNo");
	if(StringX.isEmpty(sCTSerialNo) || null == sCTSerialNo) sCTSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("CollTaskProcessResultList");
	String sWhereSql = " and 1=2 ";
	if(sCTSerialNo != "" && sTaskBatchNo != ""){
		sWhereSql = " and O.TASKSERIALNO = '" + sCTSerialNo + "' and CT.TASKBATCHNO ='"+sTaskBatchNo+"'";
	}
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","���ս���Ǽ�","���ս���Ǽ�","add()","","","","btn_icon_add",""},
			{"true","","Button","���ս������","���ս������","edit()","","","","btn_icon_detail",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		var sResUrl = "/CreditManage/Collection/OutCollRegistrateInfo.jsp";
		var sPTISerialNo = "<%=sTaskBatchNo%>";
		var sCTSerialNo = "<%=sCTSerialNo%>";
		var sCTPSerialNo = getItemValue(0,getRow(0),'SERIALNO');
		//�ж���ˮ���Ƿ�Ϊ��
		if (typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sCTPSerialNo)=="undefined" || sCTPSerialNo.length==0){
			alert('��ѡ��һ����¼');
			return;
		}
		AsControl.PopComp(sResUrl,'PTISerialNo=' +sPTISerialNo+'&CTSerialNo=' +sCTSerialNo+'&CTPSerialNo=' +sCTPSerialNo+'&RightType=ReadOnly','');
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
