<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String projectNo = CurPage.getParameter("ProjectNo");
	if(projectNo == null) projectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectBailList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(projectNo);
	
	String sButtons[][] = {
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){

		popComp("","/CustomerManage/PartnerManage/ProjectBailInfo.jsp","SerialNo=&ProjectNo=<%=projectNo%>","dialogWidth=550px;dialogHeight=500px;");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.lentgh == 0){
			alert("��ѡ��һ����¼");
		}
		popComp("","/CustomerManage/PartnerManage/ProjectBailInfo.jsp","SerialNo=" + serialNo + "&ProjectNo=<%=projectNo%>","dialogWidth=550px;dialogHeight=500px;");
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>