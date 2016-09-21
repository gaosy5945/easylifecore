<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-10
        Content: 示例详情页面
        History Log: 
    */
	String baSerialNo = CurPage.getParameter("SerialNo");//业务流水
	if(baSerialNo == null) baSerialNo = "";
	String prjSerialno = "";
	//根据业务流水获取项目流水
	BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
	List <BizObject> boList =  bom.createQuery("select * from O,jbo.prj.PRJ_RELATIVE PR where O.serialno = PR.projectserialno and PR.objecttype in('jbo.app.BUSINESS_APPLY','jbo.app.BUSINESS_CONTRACT') and PR.ObjectNo=:SerialNo and PR.relativetype IN('01','02') ").setParameter("SerialNo", baSerialNo).getResultList(false);
	if(boList==null||boList.size()<1) prjSerialno="";
	else prjSerialno = boList.get(0).getKey().getAttribute(0).getString();
	String sTempletNo = "ProjectMerchandiseInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(prjSerialno);
	
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"false","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 AsControl.OpenView("", "","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>