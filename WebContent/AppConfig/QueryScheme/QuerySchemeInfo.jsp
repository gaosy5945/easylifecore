<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String queryNo =  CurPage.getParameter("queryNo");
	if(queryNo == null) queryNo="";
	
	ASObjectModel doTemp = new ASObjectModel("AWEQueryInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.genHTMLObjectWindow(queryNo);
	sASWizardHtml = "<div><font size=\"2pt\" color=\"#930055\">查询方案详情</font></div>";

	String sButtons[][] = {
		{"true","All","Button","保存","保存修改","saveRecord()","","","",""},
		{"true","All","Button","查询","按配置情况查询","as_doAction(0,'doQuery()','genJBOQL')","","","",""},
		{"true","All","Button","查看查询语句","查看查询语句","as_doAction(0,'viewJBOQL()','genJBOQL')","","","",""},
  	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0");
	}
    
	function doQuery(){
		as_save("myiframe0"); //先保存查询条件
		viewJBOQL();
		//parent.reloadSelf();
	}
    
	/*~[Describe=查看查询语句;]~*/
	function viewJBOQL(){
		var sResultInfo = getResultInfo(0);//获得数据
		if(sResultInfo!=''){
			var sJBOQL = sResultInfo.split("@")[0];
			var sMajorObjClass = sResultInfo.split("@")[1];
			var exportFields = sResultInfo.split("@")[2];
			var sumFields = sResultInfo.split("@")[3];
			var sParas = "MajorObjClass="+sMajorObjClass+"&JBOQL="+sJBOQL+"&ExportFields="+exportFields+"&SumFields="+sumFields;
			AsControl.PopComp("/AppConfig/QueryScheme/GenerateJBOQLPage.jsp", sParas, "dialogWidth=800px;dialogHeight=470px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		}
	}
	
	/*~[Describe=选择主对象;InputParam=ObjName 对象名称字段;]~*/
	function selectMajorObjClass(){
		var sDefaultNode = getItemValue(0, 0, "BIZOBJCLASS");
		var sReturn = AsControl.PopComp("/AppConfig/QueryScheme/SelectBizObjectClass.jsp", "DefaultNode="+sDefaultNode, "");
		if(typeof(sReturn)!="undefined" && sReturn != "_CLEAR"){
			setItemValue(0,0,"BIZOBJCLASS",sReturn.split("@")[0]);
			setItemValue(0,0,"MajorClassName",sReturn.split("@")[1]);
		}else if(sReturn == "_CLEAR"){
			setItemValue(0,0,"BIZOBJCLASS","");
			setItemValue(0,0,"MajorClassName","");
		}
	}
	
	/*~[Describe=选择附加对象;InputParam=ObjName 对象名称字段,ObjAlias 对象别名字段;]~*/
	function selectRelatedClass(){
		var bizObjClass = getItemValue(0, 0, "BIZOBJCLASS");
		if(typeof(bizObjClass)=="undefined" || bizObjClass.length == 0){
			alert("请选择主对象！");
			return;
		}
		var style = "dialogWidth:500px;dialogHeight:600px;resizable:yes;maximize:yes;help:no;status:no;";
		var sReturn = AsControl.PopComp("/AppConfig/QueryScheme/SelectRelatedClasses.jsp", "BizObjClass="+bizObjClass, style);
		if(typeof(sReturn)!="undefined" && sReturn != "_CLEAR"){
			setItemValue(0,0,"RELATEDCLASS",sReturn.split("@@")[0]);
			setItemValue(0,0,"RelatedClassName",sReturn.split("@@")[1]);
		}else if(sReturn == "_CLEAR"){
			setItemValue(0,0,"RELATEDCLASS","");
			setItemValue(0,0,"RelatedClassName","");
		}
	}
	
	/*~[Describe=取得已选对象的属性;]~*/
	function getSelectedClassAttrs(attrCol,nameCol,selectType){
		var bizObjClass = getItemValue(0, getRow(), "BizObjClass"); //主对象
		var relatedClass = getItemValue(0, getRow(), "RELATEDCLASS"); //附加对象
		relatedClass = relatedClass.replace(/\"/g,"\\\""); //对 " 处理
		if(typeof(bizObjClass)=="undefined" || bizObjClass.length == 0){
			alert("请选择主对象！");
			return;
		}
		var selectedAttrs = getItemValue(0, getRow(), attrCol);
		var paraString = "MajorClass="+bizObjClass+"&RelatedClasses="+relatedClass+"&SelectType="+selectType+"&SelectedAttrs="+selectedAttrs;
		var sReturn = AsControl.PopComp("/AppConfig/QueryScheme/GetSelectedClassAttrs.jsp",paraString,"dialogWidth:550px;dialogHeight:600px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn) != "undefined" && sReturn !="_none_"){
			setItemValue(0,0,attrCol,sReturn.split("@")[0]);
			setItemValue(0,0,nameCol,sReturn.split("@")[1]);
		}
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>