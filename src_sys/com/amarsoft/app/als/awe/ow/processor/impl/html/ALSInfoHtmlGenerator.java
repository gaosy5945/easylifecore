package com.amarsoft.app.als.awe.ow.processor.impl.html;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.creator.ObjectWindowCreator;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.als.awe.ow.processor.OWHTMLGenrerator;
import com.amarsoft.app.als.awe.ow.processor.impl.html.bodyhtml.DefaultPageHTMLGenerator;
import com.amarsoft.app.als.awe.ow.validator.ALSObjectWindowValidateRulesFactory;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASObjectWindow;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.actions.IDataAction;
import com.amarsoft.awe.dw.ui.datamodel.MData;
import com.amarsoft.awe.dw.ui.datamodel.MDataBuilder;
import com.amarsoft.awe.dw.ui.htmlfactory.InfoHtmlWithASDataObjectGenerator;
import com.amarsoft.awe.dw.ui.info.DefaultAction;
import com.amarsoft.awe.dw.ui.keyfilter.jsgenerate.IKeyFilterBuilder;
import com.amarsoft.awe.dw.ui.keyfilter.jsgenerate.KeyFilterBuilder;
import com.amarsoft.awe.dw.ui.page.FilterDatasByGroup;
import com.amarsoft.awe.dw.ui.page.GenHtml;
import com.amarsoft.awe.dw.ui.style.data.PageStyleData;
import com.amarsoft.awe.dw.ui.util.Const;
import com.amarsoft.awe.dw.ui.validator.IValidateRulesFactory;
import com.amarsoft.awe.dw.ui.validator.client.IVaildateJSCode;
import com.amarsoft.awe.dw.ui.validator.client.JQueryForm;

public class ALSInfoHtmlGenerator extends InfoHtmlWithASDataObjectGenerator implements OWHTMLGenrerator{

	private BusinessObject businessObject;
	private JBOTransaction tx;
	private ALSBusinessProcess businessProcess;
	protected String javascript="";
	protected String html="";
	
	private String generate(String styleId, Hashtable values, int editstauts, boolean outputControlHtml)throws Exception{
		ArrayList datalist = MDataBuilder.getData(asObj);
		FilterDatasByGroup filter = new FilterDatasByGroup(asObj.getDONO(), datalist, outputControlHtml);
		filter.setAsDataObject(asObj);
		filter.run();
		String[][] groupInfo = filter.getGroupInfo();
		Hashtable groupDatas = filter.getGroupdatas();
		String html = "";
		PageStyleData pstyle = GenHtml.getPageStyleData(asObj.getDONO(), styleId, webRootPath, asObj.getClientID());
		//pstyle.groupBodyParser="com.amarsoft.app.als.awe.ow.processor.impl.html.bodyhtml.DefaultBodyHTMLGenerator";
		if (outputControlHtml) html += pstyle.draghead;
		html +=  pstyle.head;

		for (int i = 0; i < groupInfo.length; i++){
			ArrayList data = (ArrayList)groupDatas.get(groupInfo[i][0]);
			if ((data != null) || (!"NOGROUPSYS@".equals(groupInfo[i][0]))) {
				GenHtml htmlgenrator = new DefaultPageHTMLGenerator(asObj, data, pstyle, groupInfo[i], editstauts, webRootPath);
		        if (groupInfo.length <= 1) htmlgenrator.setHidGroupHeadAndFoot(true);
		        html += htmlgenrator.gen(values);
			}
		}
		String dwname=ObjectWindowHelper.getObjectWindowName(this.asObj);
		for (int i = 0; i < filter.getHiddenDatas().size(); i++) {
			MData hidden = (MData)filter.getHiddenDatas().get(i);
			String colName = hidden.getField(MDataBuilder.getColumnsIndex2("COLNAME")).getValue();
			String inputname=colName;
			if(!dwname.equals("0"))inputname=dwname+"_"+colName;
			String value = values.get(colName) == null ? "" : values.get(colName).toString();
			html += "<input type=\"hidden\" name=\"" + inputname + "\" value=\"" + value.replace("\"", "&#34;") + "\" alstype=\"hidden\">\n";
		}
		html += pstyle.foot;
		if (outputControlHtml) html += pstyle.dragfoot;
		return html;
	}

	public String getHtmlResult(String styleId) throws Exception {
		String dwname = ObjectWindowHelper.getObjectWindowName(this.asObj);
		String formName="myiframe"+dwname;
		//开始生成代码
		BusinessObject dwParameters = ObjectWindowHelper.getDataObjectParameters(asObj);//输入参数
		dwParameters.appendAttributes(businessObject);
		String columnNameString="";
		for(int i=0;i<asObj.Columns.size();i++){
			ASColumn column = asObj.getColumn(i);
			String columnName = column.getItemName();
			columnName="'"+columnName+"'";
			if(columnNameString.length()==0) columnNameString+=columnName;
			else  columnNameString+=","+columnName;
			
			if(!dwname.equals("0"))column.setAttribute("COLINDEX", dwname+"_"+column.getAttribute("COLINDEX"));
			
			String editSource = column.getAttribute("COLEDITSOURCE");
			if(editSource!= null){
				editSource = StringHelper.replaceString(editSource, dwParameters);//然后使用dw传入参数，这个顺序不能调整，因为新增对象时dw传入的参数为空，但对象流水是有值的。
				column.setAttribute("COLEDITSOURCE", editSource);
			}
			
			String coleditsourceType = column.getAttribute("COLEDITSOURCETYPE");
			if(coleditsourceType.equals(ObjectWindowHelper.OBJECTWINDOW_XML))
			{
				String codeTable = "";
				String[] codeArray = editSource.split(",");
				List<BusinessObject> list = com.amarsoft.app.base.util.XMLHelper.getBusinessObjectList(codeArray[0], codeArray[3], codeArray[1]);
				for(BusinessObject l:list)
				{
					codeTable += l.getString(codeArray[1])+",";
					codeTable += l.getString(codeArray[2])+",";
				}
				
				if(!StringX.isEmpty(codeTable)) codeTable = codeTable.substring(0, codeTable.length()-1);
				column.setAttribute("COLEDITSOURCETYPE", "CodeTable");
				column.setAttribute("COLEDITSOURCE", codeTable);
			}
		}
		
		html += generate(styleId,data,inputStatus,false);//invoker.generate(asObj, styleId, data, inputStatus, false, webRootPath);
		//编辑标记
		if(businessObject.getState()!=BizObject.STATE_NEW){
			html = html.replaceAll("\\{dwrowcount\\}", "1");
		}
		else
			html = html.replaceAll("\\{dwrowcount\\}", "0");
		
		//生成验证脚本
		IValidateRulesFactory factory = new ALSObjectWindowValidateRulesFactory(asObj);
		asObj.validateRules = factory.getValidateRules();
		IVaildateJSCode validCode = new JQueryForm(this.asObj.getDONO(),this.asObj.getValidateTagList());
		javascript += "_user_validator["+ formName.substring(8) +"] = " + validCode.generate(webRootPath,formName,asObj.getValidateRules())+"\n";
		//生成关键字效果
		IKeyFilterBuilder keyFilter = new KeyFilterBuilder();
		javascript +=keyFilter.getResult(Const.getDWControlPath(webRootPath) + "/AutoComplete.jsp",asObj.getDONO()) + "\n";
		
		html = html.replaceAll("\\{SERIALIZED_ASD\\}", this.asObj.getSerializableName());
		html = html.replaceAll("\\{SERIALIZED_JBO\\}", "");
		if(!dwname.equalsIgnoreCase("0")){
			html = html.replaceAll("id=\"SERIALIZED_ASD\"", "id=\"SERIALIZED_ASD_"+dwname+"\"");
		}
		
		javascript += "DisplayFields["+formName.substring(8)+"] = ["+ columnNameString+"];\n";
		//JBO序列化
		javascript += "if(typeof(filterValues)==\"undefined\") filterValues={};\n";
		javascript += "filterValues['"+formName+"']=new Array();\n";
		javascript +="if(typeof(ALSObjectWindowFunctions)==\"undefined\" || ALSObjectWindowFunctions.length==0){ALSObjectWindowFunctions={};ALSObjectWindowFunctions.objectWindowMetaData=[];ALSObjectWindowFunctions.ObjectWindowData=[];}\n";
		
		javascript += "ALSObjectWindowFunctions.ObjectWindowData["+formName.substring(8)+"] = [];\n";
		javascript += "ALSObjectWindowFunctions.ObjectWindowData["+formName.substring(8)+"][0] ="+ ObjectWindowHelper.generateClientObjectData(asObj,businessObject) +";\n";
		javascript += "DisplayDONO["+formName.substring(8)+"]='"+this.asObj.getDONO()+"';\n";
		//if(!StringX.isEmpty(this.asObj.getDONO()))
		javascript += "if(!DisplayDONO)DisplayDONO='"+this.asObj.getDONO()+"';\n";
		javascript += "$(document).ready(function(){$(\"#SERIALIZED_JBO\")[0].value=ALSObjectWindowFunctions.ObjectWindowData["+formName.substring(8)+"][0][\"SerialedString\"];});\n";
		//以下代码必须生成，以兼容Info和List共存与一个页面中
		javascript += "i=DZ.length;\r\n DZ[i]=new Array();\r\n if(typeof(aDWfilterTitles) != \"undefined\") {aDWfilterTitles[i]= new Array();}\r\n";
		
		genSubObjectHTML();
		for(int i=0;i<asObj.Columns.size();i++){
			ASColumn column = asObj.getColumn(i);
			if(!dwname.equals("0")){
				String oldIndex=column.getAttribute("COLINDEX");
				oldIndex=oldIndex.substring((dwname+"_").length());
				column.setAttribute("COLINDEX", oldIndex);
			}
		}
		String doTempString = ObjectWindowHelper.getDWMetaJSONString(asObj);
		javascript += "ALSObjectWindowFunctions.objectWindowMetaData["+formName.substring(8)+"] = "+doTempString+";\n";
		
		return html+"<script>\n"+javascript+"</script>\n";
	}
	
	private void genSubObjectHTML() throws Exception{
		
		for(Object column:asObj.Columns){
			ASColumn ascolumn=(ASColumn)column;
			String colName=ascolumn.getAttribute("COLNAME");
			String coleditsourceType=ascolumn.getAttribute("COLEDITSOURCETYPE");
			if(StringX.isEmpty(coleditsourceType)) continue;
			if(!coleditsourceType.equals(ObjectWindowHelper.OBJECTWINDOW_SUBLISTOW)
					&&!coleditsourceType.equals(ObjectWindowHelper.OBJECTWINDOW_SUBINFOOW)
					&&!coleditsourceType.equals(ObjectWindowHelper.OBJECTWINDOW_SUBPAGE)
					) continue;
			String subParameterString=ascolumn.getAttribute("COLEDITSOURCE");

			String subhtml="";
			if(coleditsourceType.equals(ObjectWindowHelper.OBJECTWINDOW_SUBLISTOW)||coleditsourceType.equals(ObjectWindowHelper.OBJECTWINDOW_SUBINFOOW)){
				subhtml=getSubObjectHTML_OW(colName,subParameterString);
			}
			else if(coleditsourceType.equals(ObjectWindowHelper.OBJECTWINDOW_SUBPAGE)){
				subhtml=getSubObjectHTML_Page(colName,subParameterString);
			}
			this.html=this.replaceColumn(this.html, colName, subhtml);
		}
	}
	
	public String replaceColumn(String infoOWHtml,String colName,String subhtml){
		colName=colName.toUpperCase();
		String startString = "<!--COLUMN_START:" + colName + "-->";
		String endString = "<!--COLUMN_END:" + colName + "-->";
		int starti=infoOWHtml.indexOf(startString);
		int endi=infoOWHtml.indexOf(endString)+endString.length();

		infoOWHtml=infoOWHtml.substring(0,starti)+subhtml+infoOWHtml.substring(endi);
		return infoOWHtml;
	}

	private String getSubObjectHTML_Page(String colName,String subParameterString) throws Exception{
		BusinessObject inputParameters=StringHelper.stringToBusinessObject(subParameterString, "&", "=");
		
		String pageHeight=inputParameters.getString("PageHeight");
		if(StringX.isEmpty(pageHeight)) pageHeight="300";
		String html="<table width=\"100%\" height=\""+pageHeight+"\"><tr><td width=\"1%\"></td><td width=\"96%\">"
				+ "<iframe type='iframe' id=\"sys_sub_page_frame_"+colName+"\" name=\"sys_sub_page_frame_"+colName+"\" width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\">"
				+ "</iframe></td></tr></table>";
		javascript+="$(document).ready(function(){sys_open_sub_page_"+colName+"();});\n";
		
		String pageURL = inputParameters.getString("PageURL");
		String pageRightType = inputParameters.getString("RightType");
		if(StringX.isEmpty(pageRightType)) this.asObj.getCurPage().getParameter("RightType");
		if(!StringX.isEmpty(pageRightType)) subParameterString="RightType="+pageRightType+"&"+subParameterString;
		javascript+="function sys_open_sub_page_"+colName+"(){AsControl.OpenComp(\""+pageURL+"\",\""+subParameterString+"\",\"sys_sub_page_frame_"+colName+"\",\"\")}\n";
		return html;
	}
	
	private String getSubObjectHTML_OW(String colName,String subParameterString) throws Exception{
		BusinessObject inputParameters=StringHelper.stringToBusinessObject(subParameterString, "&", "=");
		String dwname = ObjectWindowHelper.getObjectWindowName(this.asObj);
		String colIndex = asObj.getColumnAttribute(colName, "COLINDEX");
		String groupID = asObj.getColumnAttribute(colName, "GROUPID");
		String inputParameterString = asObj.getColumnAttribute(colName, "COLEDITSOURCE");
		if(!inputParameters.containsAttribute("DWStyle")){
			inputParameters.setAttributeValue("DWStyle", "2");
		}
		
		String className = inputParameters.getString("OWCreator");
		if(StringX.isEmpty(className))className="com.amarsoft.app.als.awe.ow.creator.BasicObjectWindowCreator";
		Class<?> c = Class.forName(className);
		ObjectWindowCreator objectWindowCreator = (ObjectWindowCreator)c.newInstance();
		ASObjectWindow subDataWindow = objectWindowCreator.createObjectWindow(inputParameters, this.businessProcess.getPage(), request);
		subDataWindow.getDataObject().getCustomProperties().setProperty("ParentColName", colName);
		
		SubObjectWindowInfoHtmlGenerator subHTMLGenerator = new SubObjectWindowInfoHtmlGenerator();
		subHTMLGenerator.setASDataWindow(subDataWindow);
		String subdwname =ObjectWindowHelper.getObjectWindowName(subDataWindow.getDataObject());

		subHTMLGenerator.getHtmlResult("");
		this.javascript+=subHTMLGenerator.getJavaScript();
		//设置从属关系
		String subowString = this.asObj.getCustomProperties().getProperty("SYS_SUB_OW");
		if(subowString==null)subowString="";
		subowString+=","+colName+"="+subdwname;
		this.asObj.getCustomProperties().setProperty("SYS_SUB_OW",subowString);
		
		String divID = "sub_object_"+dwname+"_"+colIndex;
		javascript+="if(typeof(subPageMap)==\"undefined\") {subPageMap=new Array();}\n";
		javascript+="if(!subPageMap["+dwname+"]) {subPageMap["+dwname+"]={};}\n";
		javascript+="if(!subPageMap["+dwname+"][\""+colIndex+"\"]) {subPageMap["+dwname+"][\""+colIndex+"\"]={};}\n";
		javascript+="subPageMap["+dwname+"][\""+colIndex+"\"][\"DivID\"]=\""+divID+"\";\n";
		javascript+="subPageMap["+dwname+"][\""+colIndex+"\"][\"ColName\"]=\""+colName+"\";\n";
		javascript+="subPageMap["+dwname+"][\""+colIndex+"\"][\"GroupID\"]=\""+(groupID==null?"":groupID)+"\";\n";
		javascript+="subPageMap["+dwname+"][\""+colIndex+"\"][\"SubDWName\"]=\""+subdwname+"\";\n";
		javascript+="subPageMap["+dwname+"][\""+colIndex+"\"][\"OWParamterString\"]=\""+inputParameterString+"\";\n";
		if(subDataWindow.Style.equals("1")){
			javascript+="$(document).ready(function(){ALSObjectWindowFunctions.drawSubList("+subdwname+");});";
		}
		String subhtml="<div id=\""+divID+"\" name=\"div_my"+subdwname+"\" style=\"\">"+subHTMLGenerator.getHTML()+"</div>";
		return subhtml;
	}

	public final void run(BusinessProcessData bpData) throws Exception{
		businessProcess = ALSBusinessProcess.createBusinessProcess(request, this.asObj,tx);
		BusinessObject inputParameters = ObjectWindowHelper.getDataObjectParameters(asObj);
		BusinessObjectOWQuerier querier = businessProcess.getBusinessObjectQuerier();
		querier.query(inputParameters,businessProcess);
		BusinessObject[] businessObjectArray = querier.getBusinessObjectList(0, 10);
		if(businessObjectArray==null||businessObjectArray.length==0){//如果没有找到合适的记录，自动创建一条记录
			businessObject = businessProcess.getBusinessObjectCreator().newObject(inputParameters,businessProcess).get(0);
			//执行BusinessProcess中新建记录时的自定义脚本
			IDataAction actionAdd = new DefaultAction(request,null);
			actionAdd.run(new BizObject[]{businessObject}, asObj, "addCustomize", bpData);
		}
		else if(businessObjectArray.length>1){
			throw new Exception("Datawindow={"+asObj.getDONO()+"}查询结果存在多条，请确认模板配置是否正确！");
		}
		else this.businessObject=businessObjectArray[0];
		this.data=BusinessObjectHelper.convertToHashtable(this.businessObject);
	}

	public String getJavaScript() throws Exception {
		return this.javascript;
	}

	public String getHTML() throws Exception {
		return html;
	}
}
