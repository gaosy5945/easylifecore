<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PubMessageConfigList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","saveRecord()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0);","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function add(){
		as_add("myiframe0");
		bIsInsert=true;
	}
	function saveRecord(){
		if(bIsInsert){
			var checkresult = ChageMessageID();
			if(!checkresult)return;
		}
		as_save("myiframe0","selfRefresh()");
	}
	function ChageMessageID(){
		var messageID = getItemValue(0, getRow(0), "MESSAGEID");
		if(typeof(messageID)=="undefined"||messageID.length==0){
			return;
		}
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckMessageID",messageID);
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return false;
		}
		
		return true;
	}

	function selfRefresh()
	{
		AsControl.OpenPage("/Common/Configurator/FlowManage/PubMessageConfigList.jsp", "", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
