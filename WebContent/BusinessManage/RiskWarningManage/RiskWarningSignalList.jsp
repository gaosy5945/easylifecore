<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//<!----------预警信号列表----------------->
    String sSignallevel = DataConvert.toString(CurPage.getParameter("signallevel"));
    String industrytype = CurPage.getParameter("industrytype");
    String inputorgid = CurPage.getParameter("inputorgid");
	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningSignalList");
   
	String sIndustrytype = "";
	String sInputorgid ="";
	
	
	if(inputorgid == null){
		sIndustrytype = DataConvert.toString(industrytype);
		//通过行业类型查询
		doTemp.appendJboWhere(" and ind.INDUSTRYTYPE = :industrytype");
	}else if(industrytype == null){
		sInputorgid = DataConvert.toString(inputorgid);
		//通过办理机构查询
		doTemp.appendJboWhere(" and O.INPUTORGID = :inputorgid");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	if(inputorgid == null){
		//参数为 行业类型
		//dwTemp.setParameter("industrytype",industrytype);
		dwTemp.genHTMLObjectWindow(sSignallevel+","+sIndustrytype);
	}else if(industrytype == null){
		//参数为办理机构
		//dwTemp.setParameter("inputorgid",inputorgid);
		dwTemp.genHTMLObjectWindow(sSignallevel+","+sInputorgid);
	}else{
		dwTemp.genHTMLObjectWindow("");
	}	
	

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
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	
	function detail(){
		var sUrl = "BusinessManage/RiskWarningManage/CustomerRiskWarning.jsp";
		var sPara = getItemValue(0,getRow(0),'CUSTOMERID');
		if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopComp(sUrl,"sCustomerId="+sPara,"");				
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
