<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ProjectMergeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","��ȡ����ҵ����ϸ","��ȡ����ҵ����ϸ","getChecked()","","","",""},
			{"true","","Button","ȷ��","ȷ��","confirm()","","","",""},
			{"true","","Button","ȡ��","ȡ��","cancel()","","","",""},
			{"true","","Button","�ύ","�ύ","submit()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function getChecked(){
		var arr = getCheckedRows(0);
		var SerialNos = "''";
		for(var i=0;i<arr.length;i++){
			SerialNos = "'"+getItemValue(0,i,"SERIALNO")+"'"+","+SerialNos;
		}
		//չʾ����ҳ����ϸ
		AsControl.OpenView("/ProjectManage/ProjectAlterNewApply/ProjectMergeCreditList.jsp", "SerialNos="+SerialNos, "rightdown", "");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
