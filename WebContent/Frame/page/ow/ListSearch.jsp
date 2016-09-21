<%@page import="com.amarsoft.are.lang.DataElement"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="java.net.URLDecoder"%><%@ page language="java" import="java.util.*,com.amarsoft.awe.control.model.*,com.amarsoft.awe.dw.ASDataObjectFilter,com.amarsoft.awe.dw.ASDataWindow,com.amarsoft.are.*,com.amarsoft.are.jbo.*,com.amarsoft.awe.util.ObjectConverts,com.amarsoft.awe.dw.ASDataObject,com.amarsoft.awe.dw.ui.util.Request,com.amarsoft.awe.dw.ui.actions.IDataAction,com.amarsoft.awe.dw.ui.info.DefaultAction,com.amarsoft.awe.dw.ui.htmlfactory.*,com.amarsoft.awe.dw.ui.htmlfactory.imp.*" pageEncoding="GBK"%><%
	/*
	本页面，为Ajax调用页面，无刷新运行
	功能：实现列表保存，删除操作，目前不支持保存操作
	*/
	String sJbo = "";
	boolean isSerializJbo = "1".equals(Request.GBKSingleRequest("isSerializJbo",request));//是否序列化jbo
	String sRefreshRowIndex = Request.GBKSingleRequest("RefreshRowIndex",request);
	int iRefreshRowIndex = -1;
	if(sRefreshRowIndex.trim().length()>0&&sRefreshRowIndex.matches("[0-9]+"))
		iRefreshRowIndex = Integer.parseInt(sRefreshRowIndex);
	//ARE.getLog().trace("isSerializJbo = " + isSerializJbo);
	String sCurPage = Request.GBKSingleRequest("curpage",request);
	String sRowCount = Request.GBKSingleRequest("rowcount",request);
	String sTableIndex = Request.GBKSingleRequest("index",request);
	String sSortIndex = Request.GBKSingleRequest("SYS_SortIndex",request);//排序字段序号
	String sSortDirect = Request.GBKSingleRequest("SYS_SortDirect",request);//排序方向
	int iCurPage = 0;
	if(sCurPage.matches("[0-9]+"))
		iCurPage = Integer.parseInt(sCurPage);
	int iRowCount = -1;
	if(sRowCount.trim().length()>0){
		iRowCount = Integer.parseInt(sRowCount);
	}
	//ARE.getLog().trace("iRowCount = " + iRowCount);
	String sASD = Request.GBKSingleRequest("SERIALIZED_ASD",request);
	ASDataObject asObj = Component.getDataObject(sASD);//(ASDataObject)ObjectConverts.getObject(sASD);
	//获得查询参数
	String sArgsValue = asObj.getParamstr();
	List<DataElement> initParameters = asObj.getInitParameters(); //初始参数
	List<DataElement> parameters = new ArrayList<DataElement>();
	parameters.addAll(initParameters);
	//ARE.getLog().trace("initParameters size = " + initParameters.size());
	
	if(!StringX.isSpace(sArgsValue)){
		sArgsValue = ASDataWindow.getTrueParams(asObj.getJboWhere(),sArgsValue);
	}
	//ARE.getLog().trace("sArgsValue = " + sArgsValue);
	if(asObj.getFilterCustomWhereClauses()!=null){
		asObj.appendJboWhere(" and " + asObj.getFilterCustomWhereClauses().getWhereClauses(asObj, request));
		//asObj.composeJboSql();
	}
	if(asObj.Filters!=null){
		for(int k=0;k<asObj.Filters.size();k++){
			ASDataObjectFilter asFilter = (ASDataObjectFilter)asObj.Filters.get(k);
			if(asFilter.sFilterInputs!=null){
				String sColName = asFilter.acColumn.getAttribute("ColName").toUpperCase();
				String sColFilterRefId = asObj.getColumn(sColName).getAttribute("COLFILTERREFID");
				if(sColFilterRefId!=null && sColFilterRefId.length()>0)
					sColName = sColFilterRefId.toUpperCase();//sColName = sColFilterRefId;
				//ARE.getLog().trace("sColName = " + sColName);
				String option = "";//Request.GBKSingleRequest("DOFILTER_DF_"+ sColName +"_1_OP",request);
				String value = "";//Request.GBKSingleRequest("DOFILTER_DF_"+ sColName +"_1_VALUE",request);
				String value2 = "";
				if(request.getParameter("DOFILTER_DF_"+ sColName +"_1_OP")!=null){
					option = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ sColName +"_1_OP").toString(),"UTF-8");
					//ARE.getLog().trace("option=" + option);
				}
				if(request.getParameter("DOFILTER_DF_"+ sColName +"_1_VALUE")!=null){
					value = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ sColName +"_1_VALUE").toString(),"UTF-8");
					//ARE.getLog().trace("value1 = " + value);
				}
				if(request.getParameter("DOFILTER_DF_"+ sColName +"_2_VALUE")!=null){
					value2 = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ sColName +"_2_VALUE").toString(),"UTF-8");
					//ARE.getLog().trace("value2 = " + value2);
				}
				
				if(option.equalsIgnoreCase("In"))
					asFilter.sFilterInputs[0][1] = value;//从request中取值
				else if(option.equalsIgnoreCase("Area")){
					//ARE.getLog().trace("asFilter.sFilterInputs[0].length="+asFilter.sFilterInputs[0].length+",value2=" + value2);
					asFilter.sFilterInputs[0][1] = value;//从request中取值
					asFilter.sFilterInputs[1][1] = value2;//从request中取值
				}else
					asFilter.sFilterInputs[0][1] = value;//从request中取值
				
				for(int t=0;t<asFilter.sFilterInputs.length;t++){
					if(asFilter.sFilterInputs[t][1]==null || asFilter.sFilterInputs[t][1].equals(""))continue;
					//ARE.getLog().trace(asFilter.sFilterInputs[t][0] + "==" + new String(asFilter.sFilterInputs[t][1].getBytes("UTF-8"),"GBK"));
					if(option.equalsIgnoreCase("Like")){
						parameters.add(DataElement.valueOf(asFilter.sFilterInputs[t][0], "%" + asFilter.sFilterInputs[t][1] + "%"));
					}else if(option.equalsIgnoreCase("BeginsWith")){
						parameters.add(DataElement.valueOf(asFilter.sFilterInputs[t][0], asFilter.sFilterInputs[t][1] + "%"));
					}else{
						parameters.add(DataElement.valueOf(asFilter.sFilterInputs[t][0], asFilter.sFilterInputs[t][1]));
						/* if(!value2.equals("")){
							parameters.add(DataElement.valueOf("DOFILTER_DF_"+ sColName +"_2_VALUE", value2));
						} */
					}
				}
				if(option.equalsIgnoreCase("Like")) option="BeginsWith";
				asFilter.sOperator = option;//设置查询操作符
			}
		}

		//设置包括查询参数在内的参数
		asObj.setParameters(parameters);
	}
	String sOrigJboWhere = asObj.getJboWhere();
	//设置排序
	if(!sSortIndex.equals("")){
		//ARE.getLog().trace(" " +sSortIndex+ " " + sSortDirect + " ");
		//asObj.setJboOrder(" " + (Integer.parseInt(sSortIndex)+1) + " " + sSortDirect + " " );
		asObj.setJboOrder(" " + sSortIndex + " " + sSortDirect + " " );
		asObj.composeJboSql();
	}
	if(asObj.Filters!=null && sSortIndex.equals(""))
		asObj.composeJboSql();
	
	//执行实际查询
	//ARE.getLog().trace("sArgsValue=" + sArgsValue);
	String dataQueryClass = asObj.getDataQueryClass();
	ListHtmlGenerator list = null;
	if(StringX.isEmpty(dataQueryClass)){
		list = new DefaultListHtmlGenerator(asObj,sTableIndex,sArgsValue,asObj.getPageSize(),iCurPage,request);
	}else{
		Object queryObj = Class.forName(asObj.getDataQueryClass()).newInstance();
		if(queryObj instanceof DefaultListHtmlGenerator){
			DefaultListHtmlGenerator list3 = (DefaultListHtmlGenerator)queryObj;
			list3.initConstructParams(asObj,sTableIndex,sArgsValue,asObj.getPageSize(),iCurPage,request);
			list3.beforeRun(JBOFactory.createJBOTransaction());
			list = list3;
		}else{
			ListHtmlWithASDataObjectGenerator list2 = (ListHtmlWithASDataObjectGenerator)queryObj;
			list2.initBasicParams(asObj, sArgsValue, asObj.getPageSize(), iCurPage, request);	
			list = list2;
		}
	}
	list.setEditable(asObj.isEditable());
	//增加统计信息
	int iColCount = asObj.Columns.size();
	boolean[] bServerCounts = new boolean[iColCount];
	String[] aServerCountActualNames = new String[iColCount];
	String[] aServerCountTableNames = new String[iColCount];
	for (int iCol = 0; iCol < iColCount; iCol++) {
		String sColColumnType = asObj.getColumnAttribute(iCol, "ColColumnType");
		if(sColColumnType.equals("3")){//添加到总计数组
			bServerCounts[iCol] = true;
		}else{
			bServerCounts[iCol] = false;
		}
		aServerCountActualNames[iCol] = asObj.getColumnAttribute(iCol, "ColActualName");
		aServerCountTableNames[iCol] = asObj.getColumnAttribute(iCol, "ColTableName");
	}
	list.setRowCount(iRowCount);
	list.setServerCounts(bServerCounts,aServerCountActualNames,aServerCountTableNames);
	//统计信息设置结束
	list.setWebRootPath(request.getContextPath());
	list.setRefreshRowIndex(iRefreshRowIndex);//刷新的行编号，-1表示刷新所有行
	list.run(null);
	String sListData = list.getHtmlResult();
	StringBuffer sbSerializedJBO = new StringBuffer();
	if(isSerializJbo){
		String[] aSerializedJBOs=((HtmlJboSupportor)list).getSerializedJBOs();
		if(aSerializedJBOs==null || aSerializedJBOs.length==0)
			sJbo = "";
		else{
			for(int i=0;i<aSerializedJBOs.length;i++){
				sbSerializedJBO.append("," + aSerializedJBOs[i]);
			}
			sJbo = sbSerializedJBO.toString().substring(1);
		}
	}
	StringBuffer sbResult = new StringBuffer();
	sbResult.append("{");
	sbResult.append("status:true,");
	sbResult.append("SERIALIZED_JBO:'"+ sJbo +"',");
	sbResult.append("SERIALIZED_ASD:'"+sASD+"',");
	sbResult.append("ArgValues:'"+sArgsValue+"',");
	//重新序列化dataobject
	asObj.setJboWhere(sOrigJboWhere);
	//ARE.getLog().trace("sOrigJboWhere="+sOrigJboWhere);
	ObjectConverts.saveObject(new java.io.File(Component.getDWTmpPath(asObj.getSerializableName())), asObj);
	String sNewASD = asObj.getSerializableName();//ObjectConverts.getString(asObj);
	sbResult.append("New_SERIALIZED_ASD:'"+sNewASD+"',");
	//sListData = sListData.replaceAll("\r\n","\\\\n").replaceAll("\n","\\\\n").replaceAll("\"","\\\\\"").replaceAll("\\\\'","\\\\\\\\'");
	//sListData = sListData.replace("\\n","\\\\n");
	sListData = sListData.replaceAll("\\\\","\\\\\\\\").replaceAll("\r\n","").replaceAll("\n","").replaceAll("\"","\\\\\"").replaceAll("\\\\'","\\\\\\\\'");
	sListData = sListData.replace("\\n","");
	sListData = sListData.replace("\\r","");
	//ARE.getLog().trace("ListData = " + sListData);
	if(sSortIndex.equals("")){
		sbResult.append("data:\""+ sListData +"\"");
	}else{
		sbResult.append("data:\""+ sListData +"\",");
		sbResult.append("sortIndex:'"+ sSortIndex +"',");
		sbResult.append("sortDirect:\""+ sSortDirect +"\"");
	}
	sbResult.append("}");
	out.println(sbResult.toString());
	//ARE.getLog().trace("result = " + sbResult.toString());
%>