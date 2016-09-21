
 <%@page import="com.amarsoft.awe.util.json.JSONValue"%>
<%@page import="com.amarsoft.app.als.cl.calmethod.impl.CreditLineUseHtml"%>
<%@page import="com.amarsoft.app.als.cl.model.CreditLine"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.app.als.businessobject.DefaultBusinessObjectManager"%>
<%@page import="com.amarsoft.app.als.businessobject.AbstractBusinessObjectManager"%>
<%@page import="com.amarsoft.app.als.cl.service.CreditLineService"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%
 
 	String objectType=CurPage.getParameter("ObjectType");
 	String objectNo=CurPage.getParameter("ObjectNo");
 	//out.print(objectType+" "+objectNo);
 	
 	AbstractBusinessObjectManager clm=new DefaultBusinessObjectManager(Sqlca);
 	CreditLineService cls=new CreditLineService(objectType,objectNo,clm);
 	List<BusinessObject> lst=cls.getAvailableBusinessSum();
 	 
 	
 	// clm.updateDB();
 	
 	cls.getAvaiableExposureSum();
 	CreditLine cl=cls.getCreditLine();
 	List<BusinessObject> biz=cl.getRootCL();
	StringBuffer temp=new StringBuffer();
	String[][] header={
					{"",""},
 					{"SerialNo","额度流水"},
 					{"ApproveBusinessSum","审批金额"},
 					{"UseBusinessSum","使用金额"},
 					{"BusinessSum","可用金额"},
 					{"ApproveExposureSum","审批敞口"},
 					{"UseExposureSum","使用金额"}, 
 					{"ExposureSum","可用敞口金额"}, 
 					{"btn",""}
	};
	String btn="<a>详情</a> <a>删除</a> <a>分配</a>";
	Map<String,String> dMap=new HashMap<String,String>();
	dMap.put("btn", "<a href='#' onClick='viewBusinessList(this)'>使用明细</a> <a href='#' onClick='viewUseRule(this)'>串用情况</a>");
	CreditLineUseHtml clUse=new CreditLineUseHtml(cl,header);
	clUse.setValueMap(dMap);
	String sButtons[][] = { 
		 	};
 %>
 <%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
 <%
	String stemp=clUse.getHtml();
	out.print(stemp);
	List<BusinessObject> useRule=cl.getUseRuleList();
	List<Object> lst2=new ArrayList<Object>();
	for(BusinessObject brule:useRule){
		Map<String,Object> map=brule.getAttrubutes();
		lst2.add(map);
	}
	
%>
 <script type="text/javascript"> 
	$(document).ready(function() {
	    table = $("table.<%=clUse.getTableId()%>"); 
	    //生成treeTable
	    table.treeTable({initialState:"expanded"});
	    //给表绑定移入改变背景，单击高亮事件
	    table.tableLight();
	 
	    return;
	});
	
	function viewBusinessList(obj){
		serialNo="";//getValue(obj,"SerialNo"); 
	}
	
	
</script>
 
<%@ include file="/IncludeEnd.jsp"%>
 