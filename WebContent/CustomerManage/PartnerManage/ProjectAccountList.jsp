<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("SerialNo");
	if(objectNo == null) objectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectAccountList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectNo);
	
	String sButtons[][] = {
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*~������¼~*/
	function add(){
		 var sUrl = "/CustomerManage/PartnerManage/ProjectAccountInfo.jsp";
		 OpenPage(sUrl + "?ObjectNo=<%=objectNo%>",'_self','');
	}
	/*~�鿴�޸ļ�¼~*/
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.lentgh == 0){
			alert("��ѡ��һ����¼");
			return;
		}
		 var sUrl = "/CustomerManage/PartnerManage/ProjectAccountInfo.jsp";
		 OpenPage(sUrl+"?SerialNoAcc=" + serialNo +"&ObjectNo=<%=objectNo%>","_self","");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
