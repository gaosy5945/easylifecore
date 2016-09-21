<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String projectNo = CurPage.getParameter("ProjectNo");
	if(projectNo == null) projectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectBailList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(projectNo);
	
	String sButtons[][] = {
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
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
			alert("请选择一条记录");
		}
		popComp("","/CustomerManage/PartnerManage/ProjectBailInfo.jsp","SerialNo=" + serialNo + "&ProjectNo=<%=projectNo%>","dialogWidth=550px;dialogHeight=500px;");
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
