<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	String serialNo = CurPage.getParameter("SerialNo");

	ASObjectModel doTemp = new ASObjectModel("ProjectEquipmentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","ALL","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","ALL","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*����*/
	function add(){
		 var sUrl = "/CustomerManage/PartnerManage/ProjectEquipmentInfo.jsp";
		 OpenPage(sUrl,'_self','');
	}
	/*�༭��Ϣ*/
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		 var sUrl = "/CustomerManage/PartnerManage/ProjectEquipmentInfo.jsp";
		 OpenPage(sUrl+'?PSerialNo=' + serialNo,'_self','');
	}
	/*ɾ����¼*/
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm('ȷʵҪɾ����?'))as_delete(0,'');
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
