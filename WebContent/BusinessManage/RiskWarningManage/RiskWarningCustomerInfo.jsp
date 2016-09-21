<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//<!---------预警客户列表-------------->
	String cstrisklevel = DataConvert.toString(CurPage.getParameter("cstrisklevel"));
	
	String inputorgid = CurPage.getParameter("inputorgid");
	String industrytype = CurPage.getParameter("industrytype");
		
	String sIndustrytype = "";
	String sInputorgid = "";
	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningCustomerInfo");
	if(inputorgid == null){
		sIndustrytype  = DataConvert.toString(CurPage.getParameter("industrytype"));
		//通过行业类型查询
		doTemp.appendJboWhere(" and ind.INDUSTRYTYPE = :INDUSTRYTYPE");
	}else if(industrytype == null){
		sInputorgid = DataConvert.toString(CurPage.getParameter("inputorgid"));
		//通过办理机构查询
		doTemp.appendJboWhere(" and O.inputorgid = :inputorgid");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	if(inputorgid == null){
		//通过行业类型查询
		dwTemp.genHTMLObjectWindow(cstrisklevel+","+sIndustrytype);
	}else if(industrytype == null){
		//通过办理机构查询
		dwTemp.genHTMLObjectWindow(cstrisklevel+","+sInputorgid);
	}
	
	
	/* dwTemp.setParameter("inputorgid",inputorgid);
	dwTemp.setParameter("cstrisklevel", cstrisklevel); */

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","预警详情","预警详情","detail()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	
	function detail(){
		var sUrl = "BusinessManage/RiskWarningManage/CustomerRiskWarning.jsp";
		var sPara = getItemValue(0,getRow(0),'CUSTOMERID');
		if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopComp(sUrl,"sCustomerId="+sPara, "resizable=yes;dialogWidth=1200px;dialogHeight=1200px;center:yes;status:no;statusbar:no");				
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
