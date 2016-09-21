<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%  
    String prjSerialNo = CurPage.getParameter("SerialNo");
    if(prjSerialNo == null)  prjSerialNo = "";
    String MarginSerialNo = CurPage.getParameter("MarginSerialNo");
    if(MarginSerialNo == null) MarginSerialNo = "";  
    String AccountNo = CurPage.getParameter("AccountNo");
    if(AccountNo == null) AccountNo = "";  
  String ProjectType = CurPage.getParameter("ProjectType");
  if(ProjectType == null) ProjectType = "";
  String CustomerID = CurPage.getParameter("CustomerID");
  if(CustomerID == null) CustomerID = "";
  String ReadFlag = CurPage.getParameter("ReadFlag");
  if(ReadFlag == null) ReadFlag = "";
  String FlagType = CurPage.getParameter("FlagType");
  if(FlagType == null) FlagType = ""; 
    
  ASObjectModel doTemp = new ASObjectModel("ProjectMarginDetailList1");
  ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

  dwTemp.Style="1";             //--设置为Grid风格--
  dwTemp.ReadOnly = "1";   //可编辑模式
  if(!"0107".equals(ProjectType)){
    doTemp.setVisible("CustomerName", false);
  }
  dwTemp.setParameter("MarginSerialNo", MarginSerialNo);
  dwTemp.genHTMLObjectWindow("");

  String sButtons[][] = {
      //0、是否展示 1、  权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码  6、  7、  8、  9、图标，CSS层叠样式 10、风格
      {"ReadOnly".equals(ReadFlag)?"false":"true","All","Button","新增","新增","add()","","","","",""},
      {"true","","Button","详情","详情","edit()","","","","",""},
      {"ReadOnly".equals(ReadFlag)?"false":"true","All","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
      };
  //设置在档案管理阶段查看信息时，三个功能按钮都屏蔽
  if("DocType".equals(FlagType)){
	  sButtons[0][0]="false";
	  sButtons[1][0]="false";
	  sButtons[2][0]="false";
  }
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
  function add(){
	  
		 AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo1.jsp","SerialNo=&ProjectSerialNo="+"<%=prjSerialNo%>"+"&ProjectType="+"<%=ProjectType%>"+"&CustomerID="+"<%=CustomerID%>","_self","");
		 reloadSelf();
  }
  
  function edit(){
    var SerialNo = getItemValue(0,getRow(0),"SerialNo");
    if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
      alert("请选择一条信息！");
    }
    AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo1.jsp","SerialNo="+SerialNo+"&MarginSerialNo="+"<%=MarginSerialNo%>","_self","");
    reloadSelf();
  }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
