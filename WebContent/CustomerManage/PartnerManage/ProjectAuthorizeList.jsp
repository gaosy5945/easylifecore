<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjecAuthorizeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		 var sUrl = "/CustomerManage/PartnerManage/ProjecAuthorizeInfo.jsp?ProjectNo=<%=serialNo%>";
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.lentgh == 0){
			alert("请选择一条记录");
			return;
		}
		 var sUrl = "/CustomerManage/PartnerManage/ProjecAuthorizeInfo.jsp?SerialNo=" + serialNo + "&ProjectNo=<%=serialNo%>";
		 OpenPage(sUrl,'_self','');
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
