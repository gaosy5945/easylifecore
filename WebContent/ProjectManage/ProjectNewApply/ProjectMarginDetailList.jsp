<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
 <style>
 /*页面小计样式*/
.list_div_pagecount{
	font-weight:bold;
}
/*总计样式*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%  
    String prjSerialNo = CurPage.getParameter("SerialNo");
    if(prjSerialNo == null)  prjSerialNo = "";
    //String MarginSerialNo = CurPage.getParameter("MarginSerialNo");
    //if(MarginSerialNo == null) MarginSerialNo = "";  
    String AccountNo = CurPage.getParameter("AccountNo");
    if(AccountNo == null) AccountNo = "";  
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	
	String MarginSerialNo = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select serialNo from clr_margin_info where objectno =:ProjectSerialNo and objecttype = 'jbo.prj.PRJ_BASIC_INFO'").setParameter("ProjectSerialNo",prjSerialNo));
	if(rs.next()){
		MarginSerialNo=rs.getString("serialNo");
			if(MarginSerialNo == null) {
				MarginSerialNo = "";
			}
		}
	rs.getStatement().close();
	
  ASObjectModel doTemp = new ASObjectModel("ProjectMarginDetailList");
  ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

  //dwTemp.Style="1";             //--设置为Grid风格--
  dwTemp.ReadOnly = "1";   //可编辑模式
  dwTemp.ShowSummary = "1";
  if(!"0107".equals(ProjectType)){
    doTemp.setVisible("CustomerName", false);
  }
  dwTemp.setParameter("MarginSerialNo", MarginSerialNo);
  dwTemp.genHTMLObjectWindow("");

  String sButtons[][] = {
      //0、是否展示 1、  权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码  6、  7、  8、  9、图标，CSS层叠样式 10、风格
      {"true","All","Button","新增","新增","add()","","","","",""},
      {"true","","Button","详情","详情","edit()","","","","",""},
      {"true","All","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
      };
%>
<HEAD>
<title>保证金缴纳明细</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
  function add(){
		var sReturn = ProjectManage.selectMarginInfo("<%=prjSerialNo%>");
		sReturn = sReturn.split("@");
		if(sReturn[0] == "MarginEmpty"){
		   alert("请先保存保证金信息！");
		   return;
		 }else{
		    AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo.jsp","WSerialNo=&AccountNo="+sReturn[1]+"&MarginSerialNo="+sReturn[0]+"&ProjectType="+"<%=ProjectType%>"+"&CustomerID="+"<%=CustomerID%>"+"&ProjectSerialNo="+"<%=prjSerialNo%>","_self","");
		    reloadSelf();		    	
		 }
  }
  
  function edit(){
    var SerialNo = getItemValue(0,getRow(0),"SerialNo");
    if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
      alert("请选择一条信息！");
    }
    AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo.jsp","WSerialNo="+SerialNo+"&MarginSerialNo="+"<%=MarginSerialNo%>"+"&ProjectSerialNo="+"<%=prjSerialNo%>"+"&ProjectType="+"<%=ProjectType%>","_self","");
    reloadSelf();
  }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
