<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下联动框架页面
 */
	String prjSerialNo = CurPage.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";
 
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	mytoptd.height=300;
	OpenList();
	
	function OpenList(){
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectGMGCList.jsp","SerialNo="+"<%=prjSerialNo%>","rightup");
	}
	
	function OpenInfo(ObjectType,divideType,clSerialNo){
		if(ObjectType == "jbo.prj.PRJ_BASIC_INFO"){
			if(divideType == "00"){
				AsControl.OpenView("/Blank.jsp","","rightdown");
			}else if(divideType == "10"){
				AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleCLDownListProduct.jsp","parentSerialNo="+clSerialNo+"&divideType="+divideType+"&RightType="+"ReadOnly","rightdown");
			}else{
				AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleCLDownListOrg.jsp","parentSerialNo="+clSerialNo+"&divideType="+divideType+"&RightType="+"ReadOnly","rightdown");
			}
		}else if(ObjectType == "jbo.guaranty.GUARANTY_CONTRACT"){
			if(divideType == "00"){
				AsControl.OpenView("/Blank.jsp","","rightdown");
			}else if(divideType == "10"){
				AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleGuarantyCLDownListProject.jsp","parentSerialNo="+clSerialNo+"&divideType="+divideType+"&RightType="+"ReadOnly","rightdown");
			}else{
				AsControl.OpenView("/ProjectManage/ProjectNewApply/ScaleGuarantyCLDownListOrg.jsp","parentSerialNo="+clSerialNo+"&divideType="+divideType+"&RightType="+"ReadOnly","rightdown");
			}
		}else{
			AsControl.OpenView("/Blank.jsp", "", "rightdown");
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>