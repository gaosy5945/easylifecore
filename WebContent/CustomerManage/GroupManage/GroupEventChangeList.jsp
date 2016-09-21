<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
    String PG_TITLE = "集团客户变更记录"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    //定义变量
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));//集团客户编号
    String sEventType = CurComp.getParameter("EventType"); //树图子节点序号
	String sDisplayTemplet = CurComp.getParameter("DisplayTemplet");//显示模板编号
	if(sGroupID == null) sGroupID = "";
	if(sEventType == null) sEventType = "";
	if(sDisplayTemplet == null) sDisplayTemplet = "";

    //取得模板号
    String sTempletNo = "GroupEventChange2";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//增加过滤器 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //产生DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

    String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//自动选中第一条记录
    my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>