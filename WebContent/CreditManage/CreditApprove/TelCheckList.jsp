<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	
	ASObjectModel doTemp = new ASObjectModel("TelCheckList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","All","Button","����","����","saveRecord()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		as_add("myiframe0");
	 	var serialNo = getSerialNo("FLOW_CHECKLIST","SerialNo");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"SerialNo",serialNo);
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"CheckItem","0020");
		setItemValue(0,getRow(),"Status","1");
		setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"InputTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function saveRecord(){		
		for(var i = 0 ; i < getRowCount(0) ; i ++){	
			setItemValue(0,i,"UpdateTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessTime()%>");
			var remark =getItemValue(0, i, "REMARK");
			if (remark.indexOf("\\")>-1){
				alert("¼����Ϣ���������ַ������飡");
				return;
			}
		}
		as_save("myiframe0");
	}
	function del(){
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
    }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
