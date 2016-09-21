  
<%@page import="com.amarsoft.app.als.cl.model.CLInfo"%>
<%@page import="com.amarsoft.app.als.cl.model.CLTools"%>
<%@page import="com.amarsoft.app.als.sys.widget.DWToTreeTable"%>
<%@page import="com.amarsoft.app.als.sys.widget.TreeTable"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>

<%@page import="com.amarsoft.awe.dw.ASObjectModel"%>
<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
<%@page import="com.amarsoft.app.als.sys.widget.MutilDWToTreeTable"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 

<%@page import="com.amarsoft.app.als.cl.calmethod.impl.CLUseRuleAction"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.awe.util.json.JSONValue"%><style>
	.div_detail{
		position:relative; 
		width:100%; 
		height:400px;
		z-index: 100;
		background-color: white; 
	}
	input{
		border: 1px solid #d9d9d9;
		text-align: right;
	}
 
</style>
 
 <%
 //OBJECTTYPE=CreditApply,OBJECTNO=2014031400000025
	 String objectType=CurPage.getParameter("ObjectType");
	 String objectNo=CurPage.getParameter("ObjectNo");
	 String clSerialNo=CurPage.getParameter("SerialNo");
	 String parentSerialNo=CurPage.getParameter("ParentSerialNo");
	 String rootSerialNo=CurPage.getParameter("RootSerialNo");
	ASObjectModel doTemp = new ASObjectModel("CLUseRuleList2");
	String rootlSerialNo="";
	String childSerialNo="";
	if(clSerialNo!=null){
		CLInfo clInfo=new CLInfo(null,clSerialNo);
		List<CLInfo> lst=clInfo.getChildCLInfo();
		List<CLInfo> flst=CLTools.getFatherCL(clSerialNo);
		lst.addAll(flst);
		for(CLInfo ci:lst){
			childSerialNo=childSerialNo+","+ci.getString("SerialNO");
		}
		
	}
	if(rootSerialNo!=null)doTemp.appendJboWhere(" and (ROOTSERIALNO='"+rootSerialNo+"'  or serialNo='"+rootSerialNo+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	 	MutilDWToTreeTable dwTree=new MutilDWToTreeTable(dwTemp,"PARENTSERIALNO","SERIALNO",objectNo);
	 if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_REAL)){
		 	dwTree.setDefaultValue("Button","<a href='#' onClick='javascript:viewBusiness(this)'>使用情况</a>");
	 }else{
		 
	 	dwTree.setDefaultValue("Button","<a href='#' onClick='javascript:viewAndEdit(this)'>详情</a> <a  href='#' onClick='javascript:deleteRecord(this)'>删除</a> <a  href='#' onClick='javascript:addClInfo(this)'>分配</a>");
	 }
	 dwTree.setDefaultValue("UseLimitSum","<input type='text' name='UseLimitSum2' id='UseLimitSum2_#SERIALNO'>");
	 dwTree.setDefaultValue("UseLimitExposureSum","<input type='text' name='UseLimitExposureSum2' id='UseLimitExposureSum2_#SERIALNO'>");
	 String[] iserialNo=dwTemp.getSerializedJBOs();
	 if(iserialNo!=null){
		 String select="<select name='UserLevel1'  id='UserLevel1_#SERIALNO'>";
		 for(int i=0;i<iserialNo.length;i++){
			 select+="<option value='"+(i+1)+"'>"+(i+1)+"</option>";
		 }
		 select+="</select>";
		 dwTree.setDefaultValue("UseLevel",select);
		 
	 }
	 	String sButtons[][] = {
	 		   {"false","","Button","保存","保存","saveRecord()","","","",""},
	 		   {"false","","Button","删除","删除","viewHistory()","","","",""}
	 };
 %>
 
<%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
<div style='width:90%;height:100%'>
 <%
 	out.print(dwTree.getHtml());
	 List<String>	lstTable=dwTree.getTreeTableId();
 %> 
 </div>
<script type="text/javascript">
	$(document).ready(function() {
	    <%
	    	for(String tableId:lstTable){
	    		out.print("initTreeTable('"+tableId+"')\n");
	    	}
	    %>
	    InitValue();
	});

	function saveRecord(clSerialNo){
		var userRule=[];
		var mapValue={};//
		mapValue["userRule"]={"rules":"","CLSerialNo":clSerialNo};
		$("[name=UseLimitSum2]").each(function(){
			 var userLimitSum=this.value;
			 if(userLimitSum!=""){
			 var serialNo=getValue(this,"SerialNo"); 
			 UseLimitExposureSum=$("#UseLimitExposureSum2_"+serialNo).val();
			 UseLevel=$("#UserLevel1_"+serialNo).val();
			 rule1={"USESERIALNO":serialNo,"UseLevel":UseLevel,"BusinessSum":userLimitSum,"EXPOSURESUM":UseLimitExposureSum};
			 userRule.push(rule1);
			}
		});
		mapValue["userRule"]["rules"]=userRule;
		sReturn=RunJavaMethod("com.amarsoft.app.als.cl.action.CLUseRuleAction","addCLUseRule",JSON.stringify(mapValue));
	}

	var childSerialNo="<%=childSerialNo%>";
	function   InitValue(){ 
		clUseRule=RunJavaMethod("com.amarsoft.app.als.cl.action.CLUseRuleAction","getCLUseRule","clSerialNo=<%=clSerialNo%>");
		$("[name=UseLimitSum2]").each(function(){
			 var userLimitSum=this;
			 var serialNo=getValue(this,"SerialNo"); 
			 var exposureSum=$("#UseLimitExposureSum2_"+serialNo);
			 if(serialNo=="<%=clSerialNo%>" || childSerialNo.indexOf(serialNo)>0){
						$(userLimitSum).attr("readOnly","true");
						$(userLimitSum).css("background-color","#FFCC00");
						$(exposureSum).attr("readOnly","true");
						$(exposureSum).css("background-color","#FFCC00");
						$("#UserLevel1_"+serialNo).hide();
				}
			 var rules=getCLUseRule(serialNo); 
			 
			 if(typeof(rules)!="undefined"){
				 this.value=rules["BusinessSum"];
				 $("#UseLimitExposureSum2_"+serialNo).val(rules["EXPOSURESUM"]);
			 }
		});
	 
	}
	var clUseRule="";
	function getCLUseRule(useSerialNo){
		var clSerialNo="<%=clSerialNo%>";
		if(clSerialNo=="") return ;
		if(clUseRule=="") clUseRule=RunJavaMethod("com.amarsoft.app.als.cl.action.CLUseRuleAction","getCLUseRule","clSerialNo=<%=clSerialNo%>");
 		if(typeof(clUseRule)=="string"){
 			clUseRule=JSON.parse(clUseRule);
 		}
		for(var o in clUseRule){
			rules=clUseRule[o]; 
			if(rules["USESERIALNO"]==useSerialNo) return rules;
		}
		return ;
	}
	 
</script>
<%@ include file="/IncludeEnd.jsp"%>
 