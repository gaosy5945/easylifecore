<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	/*
		ҳ��˵��: ����ɨ�������б�
	 */
	String PG_TITLE = "�����б�";
	
 	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel("ApplyDocList","");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function mySelectRow(){
		var fileID = getItemValue(0,getRow(),"FileID");
		if(typeof(fileID)=="undefined" || fileID.length==0) {
			AsControl.OpenView("/ImageManage/ImagePage.jsp","","frameleft","");
			//TextToShow=����ѡ����Ӧ����Ϣ!
		}else{
			AsControl.OpenView("/ImageManage/ImagePage.jsp","","frameleft","");
		}
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>