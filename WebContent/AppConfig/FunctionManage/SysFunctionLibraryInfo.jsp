 <%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String functionId = CurPage.getParameter("FunctionID");
	if(functionId == null) functionId = "";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String editStyle = CurPage.getParameter("EditStyle");
	if(editStyle == null) editStyle = "";
	String sTempletNo = "SysFunctionLibraryInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDDDWJbo("FunctionType","jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo='FunctionType' and RelativeCode like '%"+editStyle+"%'");
	doTemp.setDefaultValue("FunctionID",functionId);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	dwTemp.setParameter("serialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存并新增","保存并新增","as_save(0,'newDetail()')","","","",""},
		{"true","All","Button","保存","保存","as_save(0)","","","",""},
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","","");
	}
	function newDetail(){
		 AsControl.OpenPage("/AppConfig/FunctionManage/SysFunctionLibraryInfo.jsp","FunctionID=XXX","_self");
	}

	function afterSave(){
		$("#A_Group_0020").show();
		serialNo=getItemValue(0,getRow(),"SerialNO");
		AsControl.OpenPage("/AppConfig/FunctionManage/SysFunctionDetailList.jsp","RelativeSerialNo="+serialNo,"frame_list");
	}

	function functionTypeChange(){
		functionType=getItemValue(0,getRow(),"FunctionType");
		if(functionType=="Tree" ||functionType=="Tab"||functionType=="Left"||functionType=="Top"||functionType=="Bottom"||functionType=="Right"){
			showItem(0,'URL');
			setItemHeader(0,0,"URL","URL路径");
			
			showItem(0,'PARAMETERS'); 
		}
		else if(functionType=="Param"){
			showItem(0,"URL");
			setItemHeader(0,0,"URL","取数脚本");
			
			hideItem(0,'PARAMETERS');
		}
		else if(functionType=="Button"){
			showItem(0,'URL');
			setItemHeader(0,0,"URL","JavaScript函数");
			
			hideItem(0,'PARAMETERS'); 
		}
		else if(functionType=="JS"){
			showItem(0,'URL');
			setItemHeader(0,0,"URL","URL路径");
			
			hideItem(0,'PARAMETERS'); 
		}
		else if(functionType=="Logic"){
			showItem(0,'URL');
			setItemHeader(0,0,"URL","执行单元");
			
			showItem(0,'PARAMETERS'); 
		}
		else if(functionType=="List"||functionType=="Info"){
			showItem(0,'URL');
			setItemHeader(0,0,"URL","URL路径");
			
			showItem(0,'PARAMETERS'); 
		}
		
		functionSubTypeChange();
	}
	
	function functionSubTypeChange(){
		functionType=getItemValue(0,getRow(),"FunctionType");
		if(functionType=="Tree" ||functionType=="Tab"||functionType=="Left"||functionType=="Top"||functionType=="Bottom"
			||functionType=="Right"||functionType=="Param"||functionType=="Logic" ||functionType=="Button"){
			showItem(0,'FUNCTIONSUBTYPE');
			
			$("[name=FUNCTIONSUBTYPE]").each(function(){
			 	$(this).parent().hide();
			 	if(functionType=="Button"){
					if(this.value=="Button" || this.value=="TabButton"){
						$(this).parent().show();
					}
			 	}
			 	if(functionType=="Left"||functionType=="Top"||functionType=="Bottom"||functionType=="Right"){
					if(this.value=="JSP" || this.value=="Funct"){
						$(this).parent().show();
					}
			 	}
			 	if(functionType=="Tree" ||functionType=="Tab"){
					if(this.value=="JSP" || this.value=="Funct" ||this.value=="Catalog"){
						$(this).parent().show();
					}
			 	}
			 	else if(functionType=="Param"){
					if(this.value=="SQL" || this.value=="AmarScript" || this.value=="Constants" || this.value=="Java"){
						$(this).parent().show();
						
					}
				}else if(functionType=="Logic"){
					if(this.value=="Funct" ||this.value=="Java"){
						$(this).parent().show();
					}
				}
		 	});
			
		}
		else{
			hideItem(0,'FUNCTIONSUBTYPE');
			setItemValue(0,getRow(),"FUNCTIONSUBTYPE","");
		}
	}
	
	functionTypeChange();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 